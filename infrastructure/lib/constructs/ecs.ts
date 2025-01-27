import {
  aws_iam,
  aws_ec2,
  aws_ecs,
  Duration,
  aws_elasticloadbalancingv2,
  aws_certificatemanager,
  aws_route53,
  aws_route53_targets,
} from "aws-cdk-lib";
import { Construct } from "constructs";

export interface IEcsRoles {
  prefix: string;
}

export class EcsRoles extends Construct {
  public readonly taskRole: aws_iam.IRole;
  public readonly executionRole: aws_iam.IRole;

  constructor(scope: Construct, id: string, params: IEcsRoles) {
    super(scope, id);
    const { prefix } = params;

    /** タスクを作成する際に必要な権限 */
    this.executionRole = new aws_iam.Role(this, "ExecutionRole", {
      roleName: `${prefix}-ecs-execution`,
      assumedBy: new aws_iam.ServicePrincipal("ecs-tasks.amazonaws.com"),
      managedPolicies: [
        aws_iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "executeCloudWatchFullAccess",
          "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs",
        ),
        aws_iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "executeEcrReadAccess",
          "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
        ),
      ],
    });

    /** 実際のFargateインスタンス上にて必要な実行権限 */
    this.taskRole = new aws_iam.Role(this, "TaskRole", {
      roleName: `${prefix}-ecs-task`,
      assumedBy: new aws_iam.ServicePrincipal("ecs-tasks.amazonaws.com"),
      managedPolicies: [
        aws_iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "taskCloudWatchFullAccess",
          "arn:aws:iam::aws:policy/CloudWatchFullAccessV2",
        ),
        /** Add managed policy to use SSM */
        aws_iam.ManagedPolicy.fromManagedPolicyArn(
          this,
          "taskAmazonEC2RoleforSSM",
          "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
        ),
      ],
    });
  }
}

export interface IEcsService {
  vpc: aws_ec2.IVpc;
  albSecurityGroup: aws_ec2.ISecurityGroup;
  ecsSecurityGroup: aws_ec2.ISecurityGroup;
  ecsService: {
    taskCpu: 1024 | 2048;
    taskMemoryLimit: 2048 | 8192;
    healthcheckPath: string;
  };
  alb: {
    route53DomainName: string;
    route53RecordName: string;
  };
  prefix: string;
}

export type IEcsServiceConstants = Omit<IEcsService, "vpc" | "albSecurityGroup" | "ecsSecurityGroup">;

export class EcsService extends Construct {
  constructor(scope: Construct, id: string, params: IEcsService) {
    super(scope, id);

    const { vpc, albSecurityGroup, ecsSecurityGroup, prefix } = params;

    const cluster = new aws_ecs.Cluster(this, "FargateCluster", {
      vpc: vpc,
      clusterName: `${prefix}-cluster`,
    });

    // create a task definition with CloudWatch Logs
    const logging = new aws_ecs.AwsLogDriver({
      streamPrefix: `${prefix}-log`,
    });

    const { taskRole, executionRole } = new EcsRoles(this, "EcsRoles", {
      prefix,
    });

    const taskDefinition = new aws_ecs.FargateTaskDefinition(this, "TaskDefinition", {
      memoryLimitMiB: params.ecsService.taskMemoryLimit,
      cpu: params.ecsService.taskCpu,
      taskRole,
      executionRole,
    });

    taskDefinition.addContainer("StreamlitContainer", {
      image: aws_ecs.ContainerImage.fromAsset("../python/fastapi"),
      portMappings: [
        {
          containerPort: 80,
          hostPort: 80,
        },
      ],
      command: ["uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"],
      logging,
    });

    const service = new aws_ecs.FargateService(this, "StreamlitService", {
      cluster,
      taskDefinition,
      healthCheckGracePeriod: Duration.seconds(5),
      assignPublicIp: false,
      securityGroups: [ecsSecurityGroup],
    });

    // https://<alb-domain>/oauth2/idpresponse
    const alb = new aws_elasticloadbalancingv2.ApplicationLoadBalancer(this, "ApplicationLoadBalancer", {
      loadBalancerName: "StreamlitALB",
      vpc: vpc,
      idleTimeout: Duration.seconds(30),
      // scheme: true to access from external internet
      internetFacing: true,
      securityGroup: albSecurityGroup,
    });

    const albHostedZone = aws_route53.HostedZone.fromLookup(this, "AlbHostedZone", {
      domainName: params.alb.route53DomainName,
    });

    const certificate = new aws_certificatemanager.Certificate(this, "Certificate", {
      domainName: params.alb.route53RecordName,
      validation: aws_certificatemanager.CertificateValidation.fromDns(albHostedZone),
    });
    const listenerHttp1 = alb.addListener("ListenerHttps", {
      protocol: aws_elasticloadbalancingv2.ApplicationProtocol.HTTPS,
      certificates: [certificate],
    });

    const targetGroup = listenerHttp1.addTargets("HttpBlueTarget", {
      targetGroupName: "http-target",
      protocol: aws_elasticloadbalancingv2.ApplicationProtocol.HTTP,
      deregistrationDelay: Duration.seconds(30),
      targets: [service],
      healthCheck: {
        healthyThresholdCount: 2,
        interval: Duration.seconds(10),
        path: params.ecsService.healthcheckPath,
      },
    });
    // redirect to https
    alb.addListener("ListenerRedirect", {
      protocol: aws_elasticloadbalancingv2.ApplicationProtocol.HTTP,
      defaultAction: aws_elasticloadbalancingv2.ListenerAction.redirect({
        port: "443",
        protocol: aws_elasticloadbalancingv2.ApplicationProtocol.HTTPS,
      }),
    });

    // Route 53 for alb
    new aws_route53.ARecord(this, "AlbARecord", {
      zone: albHostedZone,
      target: aws_route53.RecordTarget.fromAlias(new aws_route53_targets.LoadBalancerTarget(alb)),
    });
  }
}
