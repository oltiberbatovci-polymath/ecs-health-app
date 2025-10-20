# HealthTech Analytics Dashboard

## Architecture Overview
![Architecture Diagram](docs/architecture.png)

### Components
- **VPC**: Public/private subnets, IGW, NAT for secure networking
- **ECS Fargate**: Node.js microservice for health analytics
- **ALB**: Secure, scalable API access
- **S3**: Stores patient data, logs, and static assets
- **CloudFront**: Delivers dashboards with caching
- **CloudWatch & X-Ray**: Metrics, logs, tracing, alarms
- **IAM**: Secure roles and policies
- **SNS**: Alert notifications

## Observability & WAF Pillars
- **Operational Excellence**: Automated CI/CD, health checks, logging
- **Security**: IAM least privilege, encrypted S3, security scans
- **Reliability**: Multi-AZ, health checks, alarms, auto-scaling
- **Performance Efficiency**: Fargate, CloudFront, scalable modules
- **Cost Optimization**: Pay-per-use, cost estimation, tagging
- **Sustainability**: Efficient resource sizing, automated pipelines

## Getting Started
1. Configure AWS credentials and ECR secrets in GitHub
2. Run `terraform init` and `terraform apply` in `terraform/environments/dev`
3. Push app changes to trigger CI/CD

## Outputs
- ALB DNS: API endpoint
- CloudFront: Dashboard delivery
- S3: Data and logs
- CloudWatch: Dashboards
- X-Ray: Tracing

## Documentation
- Architecture diagram: `docs/architecture.png`
- CloudWatch dashboard screenshots: `docs/cloudwatch_dashboard.png`
- Alarm evidence: `docs/alarm_evidence.png`
- Short report: `docs/report.md`
# ecs-health-app