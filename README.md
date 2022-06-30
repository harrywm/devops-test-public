# Birdie DevOps Engineer technical test

## Setting up the Terraform infrastructure

You need two different `terraform apply` runs to spin up all the infrastructure:

- One to setup the EKS cluster, the ALB and all the infrastructure that they depend on with `terraform apply -target=module.alb -target=module.eks`
- One full run with `terraform apply`

The reason why we need to do that is that we need the EKS Autoscaling Group and the ALB Target Group to both be created before we can assign one to the other, because the assignment uses a `for_each` statement that requires these two resources to already be created. See the [Terraform documentation](https://www.terraform.io/language/meta-arguments/for_each#limitations-on-values-used-in-for_each) for more details on why we need to do this.
