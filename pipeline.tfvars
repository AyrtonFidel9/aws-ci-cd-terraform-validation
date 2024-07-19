aws_region                   = "us-east-1"
aws_profile                  = "kloud"
environment                  = "dev"

stages_input = [ 
  { name = "validate", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "SourceOutput", output_artifacts = "ValidateOutput" },
  { name = "plan", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "ValidateOutput", output_artifacts = "PlanOutput" },
  { name = "apply", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "PlanOutput", output_artifacts = "ApplyOutput" },
  { name = "destroy", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "ApplyOutput", output_artifacts = "DestroyOutput" }
]
build_projects = [ "validate", "plan", "apply", "destroy"]


created_by         = "Fidel Avalos"
application        = "terraform-cicd"
cost_center        = "ND"
contact            = "aavalos@krugercorporation.com"
maintenance_window = "ND"
deletion_date      = "ND"