resource "google_service_account" "this" {
  account_id   = "${var.name}-sa"
  display_name = "Service Account for ${var.name}"
}

resource "google_compute_instance" "this" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone
  tags = merge(
    var.additional_tags,
    {
      created-by = "iac-tf"
    },
  )
  boot_disk {
    initialize_params {
      image  = var.initialize_params.image
      labels = var.initialize_params.labels
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  # subnetwork must exist in the same region this instance will be created in
  network_interface {
    network    = var.network_interface.network_name
    subnetwork = var.network_interface.subnetwork_name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.this.email
    scopes = ["cloud-platform"] # list: https://cloud.google.com/sdk/gcloud/reference/alpha/compute/instances/set-scopes#--scopes
  }
}
