# Deployment Configuration
# Defines different environment deployments from this stack

deployment "dev" {
  inputs = {
    region       = "us-east-1"
    environment  = "dev"
    project_name = "stacks-demo"
  }
}

deployment "staging" {
  inputs = {
    region       = "us-west-2"
    environment  = "staging"
    project_name = "stacks-demo"
  }
}
