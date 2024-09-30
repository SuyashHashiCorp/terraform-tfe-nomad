provider "nomad" {
  address = "http://${aws_instance.instance[0].public_ip}:4646"
  region  = "global"
}


#TFE NAmespace Create
resource "nomad_namespace" "tfe_ns" {
  name        = "terraform-enterprise"
  description = "TFE namespace."
  depends_on = [
    aws_instance.instance,
    aws_elasticache_cluster.redis_cache
  ]
}


#TFE Variable Create in Nomad
resource "nomad_variable" "example" {
  path      = "/nomad/jobs/tfe-job/tfe-group/tfe-task"
  namespace = nomad_namespace.tfe_ns.name
  items = {
    tfe_tls_key_file       = base64encode(tls_private_key.private_key.private_key_pem)
    tfe_tls_cert_file      = base64encode(tls_self_signed_cert.self_signed_cert.cert_pem)
    tfe_tls_ca_bundle_file = base64encode(tls_self_signed_cert.self_signed_cert.cert_pem)
    tfe_license            = var.tfe_license
    tfe_hostname           = "tfe-nomad.${var.domain_name}"
  }
  depends_on = [
    nomad_namespace.tfe_ns
  ]
}


#TFE Job File to Deploy on Nomad
resource "nomad_job" "tfe_job" {
  jobspec          = <<EOT
job "tfe-job" {
  datacenters = ["dc1"]
  namespace   = "${nomad_namespace.tfe_ns.name}"
  type        = "service"

  group "tfe-group" {
    count = 1

    restart {
      attempts = 3
      delay    = "60s"
      interval = "10m"
      mode     = "fail"
    }

    update {
      max_parallel      = 1
      min_healthy_time  = "30s"
      healthy_deadline  = "15m"
      progress_deadline = "20m"
      health_check      = "checks"
    }

    network {
      port "tfe" {
        # static port is not required if load balancer is used.
        static = 443
        to     = 8443
      }
      port "tfehttp" {
        # static port is not required if load balancer is used.
        static = 80
        to     = 8080
      }
      port "vault" {
        to = 8201
      }
    }

    service {
      name     = "tfe-svc"
      port     = "tfe"
      provider = "nomad"
      check {
        name     = "tfe_probe"
        type     = "http"
        protocol = "https"
        port     = "tfe"
        path     = "/_health_check"
        interval = "5s"
        timeout  = "2s"
        method   = "GET"
      }
    }

    task "tfe-task" {
      driver = "docker"

      identity {
        # Expose Workload Identity in NOMAD_TOKEN env var
        env = true
      }

      template {
        data        = <<EOF
              {{- with nomadVar "nomad/jobs/tfe-job/tfe-group/tfe-task" -}}
              TFE_LICENSE={{ .tfe_license }}
              TFE_HOSTNAME={{ .tfe_hostname }}
              {{- end -}}
              EOF
        destination = "secrets/env.env"
        env         = true
        change_mode = "restart"
      }

      template {
        data        = <<EOF
              {{- with nomadVar "nomad/jobs/tfe-job/tfe-group/tfe-task" -}}
              {{ base64Decode .tfe_tls_cert_file.Value }}
              {{- end -}}
              EOF
        destination = "secrets/cert.pem"
        env         = false
        change_mode = "restart"
        perms = 0777
      }

      template {
        data        = <<EOF
              {{- with nomadVar "nomad/jobs/tfe-job/tfe-group/tfe-task" -}}
              {{ base64Decode .tfe_tls_key_file.Value }}
              {{- end -}}
              EOF
        destination = "secrets/key.pem"
        env         = false
        change_mode = "restart"
        perms = 0777
      }

      template {
        data        = <<EOF
              {{- with nomadVar "nomad/jobs/tfe-job/tfe-group/tfe-task" -}}
              {{ base64Decode .tfe_tls_ca_bundle_file.Value }}
              {{- end -}}
              EOF
        destination = "secrets/bundle.pem"
        env         = false
        change_mode = "restart"
        perms = 0777
      }

      config {
        image = "${var.tfe_image}"
        ports = ["tfe", "tfehttp", "vault"]

        auth {
          username = "terraform"
          password = "${var.tfe_license}"
        }

        volumes = [
          "secrets:/etc/ssl/private/terraform-enterprise",
        ]
      }

      resources {
        cpu    = 2500
        memory = 2048
      }

      env {
        # Database settings. See the configuration reference for more settings.
        TFE_DATABASE_HOST       = "${aws_db_instance.postgres_db.endpoint}"
        TFE_DATABASE_USER       = "${aws_db_instance.postgres_db.username}"
        TFE_DATABASE_PASSWORD   = "${aws_db_instance.postgres_db.password}"
        TFE_DATABASE_NAME       = "${aws_db_instance.postgres_db.db_name}"
        TFE_DATABASE_PARAMETERS = "sslmode=require"

        # Object storage settings. See the configuration reference for more settings.
        TFE_OBJECT_STORAGE_TYPE                 = "s3"
        TFE_OBJECT_STORAGE_S3_REGION            = "${aws_s3_bucket.tfe_nomad_s3_bucket.region}"
        TFE_OBJECT_STORAGE_S3_BUCKET            = "${aws_s3_bucket.tfe_nomad_s3_bucket.id}"
        TFE_OBJECT_STORAGE_S3_USE_INSTANCE_PROFILE = true

        # Redis settings. See the configuration reference for more settings.
        TFE_REDIS_HOST     = "${aws_elasticache_cluster.redis_cache.cache_nodes[0].address}:${aws_elasticache_cluster.redis_cache.port}"
        TFE_REDIS_USE_TLS  = "false"
        TFE_REDIS_USE_AUTH = "false"

        TFE_RUN_PIPELINE_DRIVER                       = "nomad"
        TFE_VAULT_DISABLE_MLOCK                       = "true"
        TFE_ENCRYPTION_PASSWORD                       = ""

        # If you are using the default internal vault, this should be the private routable IP address of the node itself.
        TFE_VAULT_CLUSTER_ADDRESS = "https://${aws_instance.instance[1].private_ip}:8201"

        TFE_HTTP_PORT = "8080"
        TFE_HTTPS_PORT = "8443"

        TFE_TLS_CERT_FILE      = "/etc/ssl/private/terraform-enterprise/cert.pem"
        TFE_TLS_KEY_FILE       = "/etc/ssl/private/terraform-enterprise/key.pem"
        TFE_TLS_CA_BUNDLE_FILE = "/etc/ssl/private/terraform-enterprise/bundle.pem"

        #ADDITIONAL ENV TO TEST
        TF_LOG = "TRACE"
      }
      
    }
  }
}
  EOT
  purge_on_destroy = true
  depends_on = [
    nomad_variable.example,
    aws_elasticache_cluster.redis_cache,
    aws_db_instance.postgres_db,
    aws_s3_bucket.tfe_nomad_s3_bucket
  ]
}
