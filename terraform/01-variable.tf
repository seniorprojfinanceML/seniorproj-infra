variable "db_username" {
  description = "The username for the database"
  type        = string
}
variable "db_password" {
  description = "The password for the database"
  type        = string
}

variable "db_name" {
  description = "The name for the database"
  type        = string
}
variable "db_url" {
  description = "The url for the database"
  type        = string
}

variable "s3_access" {
  description = "s3_access"
  type        = string
}

variable "s3_secret_access" {
  description = "s3_secret_access"
  type        = string
}

variable "mlflow_url" {
  description = "mlflow_url"
  type        = string
}

variable "do_credentials" {
  description = "do_credentials"
  type        = string
}

variable "cron_lambda_schedules" {
  default = {
    midnight = "cron(0 0 * * ? *)"
    noon     = "cron(0 12 * * ? *)"
  }
}