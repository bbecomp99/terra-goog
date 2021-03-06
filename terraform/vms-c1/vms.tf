variable "node_count" {
 default = "0"
}

variable "tag" {
 default = "gcp"
}
variable "ssh_user" {
        default = "bbelliv"
}

variable "public_key" {
        default = "/Users/theus******y.pub"
}

variable "private_key" {
	default = "/Users/theu******ey"
}

resource "google_compute_address" "static-ip-address" {
  count = "${var.node_count}"
  name = "***dwebc1-static-ip-${count.index + 1}"
  region = "us-central1"
}

resource "google_compute_disk" "***rdwebc1" {
  count   = "${var.node_count}"
  name    = "***dwebc1${count.index}-data"
  type    = "pd-standard"
  zone    = "us-central1-a"
  size    = "5"



}
resource "google_compute_instance" "**webc1" {
  count = "${var.node_count}"
  name = "***webc1${count.index}"
  machine_type = "n1-highmem-4"
  zone = "us-central1-a"
  allow_stopping_for_update = true

boot_disk {
  initialize_params {
  image = "ubuntu-1804-lts"
  }
}
attached_disk {
    source      = "${element(google_compute_disk.***webc1.*.self_link, count.index)}"
    device_name = "${element(google_compute_disk.***dwebc1.*.name, count.index)}"
}


network_interface {
  network = "default"
  access_config {
    nat_ip = "${element(google_compute_address.static-ip-address.*.address, count.index)}"
  }

}

 metadata = {
        block-project-ssh-keys = false
    }

/*
	metadata = {
    	sshKeys = "${var.ssh_user}:${file("${var.public_key}")}"
  	}

    	connection {
		type = "ssh"
		user = "${var.ssh_user}"
	host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}" 
		private_key = "${file("${var.private_key}")}"
	}
*/

}
