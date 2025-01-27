import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";
import { Vpc, SecurityGroups, EcsService } from "./constructs";

export class ApplicationStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    const prefix = "zenn";
    const { vpc } = new Vpc(this, "VPC");
    const { albSecurityGroup, ecsSecurityGroup } = new SecurityGroups(this, "SecurityGroups", { vpc, prefix });
    new EcsService(this, "EcsService", {
      vpc,
      prefix,
      albSecurityGroup,
      ecsSecurityGroup,
      ecsService: {
        taskCpu: 1024,
        taskMemoryLimit: 2048,
        healthcheckPath: "/healthcheck",
      },
      alb: {
        route53DomainName: "",
        route53RecordName: "",
      },
    });
  }
}
