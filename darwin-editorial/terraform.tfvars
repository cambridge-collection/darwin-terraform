environment                  = "editorial"
project                      = "Darwin"
component                    = "cudl-data-workflows"
subcomponent                 = "cudl-transform-lambda"
destination-bucket-name      = "releases"
web_frontend_domain_name     = "darwin-editorial.darwinproject.ac.uk"
transcriptions-bucket-name   = "unused-cul-cudl-transcriptions"
enhancements-bucket-name     = "unused-cul-cudl-data-enhancements"
source-bucket-name           = "unused-cul-cudl-data-source"
compressed-lambdas-directory = "compressed_lambdas"
lambda-jar-bucket            = "cul-cudl.mvn.cudl.lib.cam.ac.uk"

transform-lambda-bucket-sns-notifications = [

]
transform-lambda-bucket-sqs-notifications = [
  {
    "type"          = "SQS",
    "queue_name"    = "DarwinIndexTEIQueue"
    "filter_prefix" = "solr-json/tei/"
    "filter_suffix" = ".json"
    "bucket_name"   = "releases"
  },
  {
    "type"          = "SQS",
    "queue_name"    = "DarwinIndexPagesQueue"
    "filter_prefix" = "solr-json/pages/"
    "filter_suffix" = ".json"
    "bucket_name"   = "releases"
  }
]
transform-lambda-information = [
  {
    "name"                     = "AWSLambda_TEI_SOLR_Listener"
    "image_uri"                = "330100528433.dkr.ecr.eu-west-1.amazonaws.com/darwin/solr-listener@sha256:2c430a240c8716a5791e13d96928a14a10ac6075c185566233fa07ef094d513e"
    "queue_name"               = "DarwinIndexTEIQueue"
    "queue_delay_seconds"      = 10
    "vpc_name"                 = "darwin-editorial-darwin-ecs-vpc"
    "subnet_names"             = ["darwin-editorial-darwin-ecs-subnet-private-eu-west-1a", "darwin-editorial-darwin-ecs-subnet-private-eu-west-1b"]
    "security_group_names"     = ["darwin-editorial-darwin-ecs-vpc-egress", "darwin-editorial-solr-external"]
    "timeout"                  = 180
    "memory"                   = 1024
    "batch_window"             = 2
    "batch_size"               = 1
    "maximum_concurrency"      = 50
    "use_datadog_variables"    = false
    "use_additional_variables" = true
    "environment_variables" = {
      API_HOST = "solr-api-darwin-ecs.darwin-editorial-solr"
      API_PORT = "8081"
      API_PATH = "item"
    }
  },
  {
    "name"                     = "AWSLambda_Pages_SOLR_Listener"
    "image_uri"                = "330100528433.dkr.ecr.eu-west-1.amazonaws.com/darwin/solr-listener@sha256:2c430a240c8716a5791e13d96928a14a10ac6075c185566233fa07ef094d513e"
    "queue_name"               = "DarwinIndexPagesQueue"
    "vpc_name"                 = "darwin-editorial-darwin-ecs-vpc"
    "subnet_names"             = ["darwin-editorial-darwin-ecs-subnet-private-eu-west-1a", "darwin-editorial-darwin-ecs-subnet-private-eu-west-1b"]
    "security_group_names"     = ["darwin-editorial-darwin-ecs-vpc-egress", "darwin-editorial-solr-external"]
    "timeout"                  = 180
    "memory"                   = 1024
    "batch_window"             = 2
    "batch_size"               = 1
    "maximum_concurrency"      = 50
    "use_datadog_variables"    = false
    "use_additional_variables" = true
    "environment_variables" = {
      API_HOST = "solr-api-darwin-ecs.darwin-editorial-solr"
      API_PORT = "8081"
      API_PATH = "page"
    }
  }
]
dst-efs-prefix    = "/mnt/cudl-data-releases"
dst-prefix        = "html/"
dst-s3-prefix     = ""
tmp-dir           = "/tmp/dest/"
lambda-alias-name = "LIVE"

releases-root-directory-path        = "/data"
efs-name                            = "cudl-data-releases-efs"
cloudfront_route53_zone_id          = "Z0526070386P5IAM6T0L4"
cloudfront_distribution_name        = "darwin-editorial"
cloudfront_origin_path              = "/www"
cloudfront_error_response_page_path = "/404.html"
cloudfront_default_root_object      = "index.html"
cloudfront_access_logging           = false
cloudfront_access_logging_bucket    = null
cloudfront_default_cache_policy     = "Managed-CachingOptimized"
# cloudfront_ordered_cache_behaviors is in locals.tf; it references a response headers policy resource

# Base Architecture
cluster_name_suffix            = "darwin-ecs"
registered_domain_name         = "darwinproject.ac.uk."
asg_desired_capacity           = 1 # n = number of tasks
asg_max_size                   = 1 # n + 1
asg_allow_all_egress           = true
ec2_instance_type              = "t3.large"
ec2_additional_userdata        = <<-EOF
echo 1 > /proc/sys/vm/swappiness
echo ECS_RESERVED_MEMORY=256 >> /etc/ecs/ecs.config
EOF
route53_zone_id_existing       = "Z0526070386P5IAM6T0L4"
route53_zone_force_destroy     = false
acm_certificate_arn            = "arn:aws:acm:eu-west-1:330100528433:certificate/9736e15a-8e42-43e5-8b4c-aa5e96aece65"
acm_certificate_arn_us-east-1  = "arn:aws:acm:us-east-1:330100528433:certificate/abac10bc-4e17-419c-beef-16077f78e2d3"
alb_enable_deletion_protection = false
alb_idle_timeout               = "900"
vpc_cidr_block                 = "10.84.0.0/22" #1024 adresses
vpc_public_subnet_public_ip    = false
cloudwatch_log_group           = "/ecs/darwin-editorial"

# SOLR Worload
solr_name_suffix       = "solr"
solr_domain_name       = "darwin-editorial-search"
solr_application_port  = 8983
solr_target_group_port = 8081
solr_ecr_repositories = {
  "darwin/solr-api" = "sha256:ec013710a5c452f4de4456b949e3599429bca8c12aff87eb4cc3094a6bc49c78",
  "darwin/solr"     = "sha256:838e7803e2120faaa213d7f40c787dbf207f836aa41cfc05d479ca057ba05a38"
}
solr_ecs_task_def_volumes     = { "solr-volume" = "/var/solr" }
solr_container_name_api       = "solr-api"
solr_container_name_solr      = "solr"
solr_health_check_status_code = "404"
solr_allowed_methods          = ["HEAD", "GET", "OPTIONS"]
solr_ecs_task_def_cpu         = 2048
solr_use_service_discovery    = true
