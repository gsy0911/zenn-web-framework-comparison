import { aws_ec2 } from "aws-cdk-lib";
import { Construct } from "constructs";
/**
 * 検証・本番環境に共通して必要なVPC環境
 * Auroraを利用するためにavailabilityZoneが2つある。
 */
export class Vpc extends Construct {
  public readonly vpc: aws_ec2.IVpc;

  constructor(scope: Construct, id: string) {
    super(scope, id);

    this.vpc = new aws_ec2.Vpc(this, "Vpc", {
      vpcName: "zenn-vpc",
      ipAddresses: aws_ec2.IpAddresses.cidr("172.30.0.0/16"),
      maxAzs: 2,
      natGateways: 0,
      subnetConfiguration: [
        {
          subnetType: aws_ec2.SubnetType.PUBLIC,
          name: "public",
          cidrMask: 24,
        },
        {
          subnetType: aws_ec2.SubnetType.PRIVATE_WITH_EGRESS,
          name: "application",
          cidrMask: 24,
        },
        {
          subnetType: aws_ec2.SubnetType.PRIVATE_ISOLATED,
          name: "database",
          cidrMask: 28,
        },
      ],
    });
  }
}

/**
 * VPC環境に作成するSecurityGroupを一括して作成する
 * - ECS
 * - ALB
 */
export class SecurityGroups extends Construct {
  public readonly albSecurityGroup: aws_ec2.ISecurityGroup;
  public readonly ecsSecurityGroup: aws_ec2.ISecurityGroup;

  constructor(scope: Construct, id: string, props: { vpc: aws_ec2.IVpc; prefix: string }) {
    super(scope, id);
    const { vpc, prefix } = props;

    // SecurityGroupsの定義
    const albSecurityGroup = new aws_ec2.SecurityGroup(this, "AlbForAppServiceSg", {
      vpc,
      securityGroupName: `${prefix}-alb-sg`,
      description: "security group to ALB for application",
    });
    albSecurityGroup.addIngressRule(aws_ec2.Peer.anyIpv4(), aws_ec2.Port.tcp(80), "allow HTTP");
    albSecurityGroup.addIngressRule(aws_ec2.Peer.anyIpv4(), aws_ec2.Port.tcp(443), "allow HTTPS");
    const ecsSecurityGroup = new aws_ec2.SecurityGroup(this, "EcsForAppServiceSg", {
      vpc,
      securityGroupName: `${prefix}-ecs-sg`,
      description: "security group to ECS for application",
    });
    ecsSecurityGroup.addIngressRule(albSecurityGroup, aws_ec2.Port.tcp(80), "allow HTTP");

    this.albSecurityGroup = albSecurityGroup;
    this.ecsSecurityGroup = ecsSecurityGroup;
  }
}
