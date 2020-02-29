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
        default = "/Users/theuser/Documents/gcp/fox-master/terraform/tools_key.pub"
}

variable "private_key" {
	default = "/Users/theuser/Documents/gcp/fox-master/terraform/tools_key"
}

resource "google_compute_address" "static-ip-address" {
  count = "${var.node_count}"
  name = "fxprdwebw1-static-ip-${count.index + 1}"
  region = "us-west1"
}

resource "google_compute_disk" "fxprdwebw1" {
  count   = "${var.node_count}"
  name    = "fxprdwebw1${count.index}-data"
  type    = "pd-standard"
  zone    = "us-west1-c"
  size    = "5"
}
resource "google_compute_instance" "fxprdwebw1" {
  count = "${var.node_count}"
  name = "fxprdwebw1${count.index}"
  machine_type = "n1-standard-1"
  zone = "us-west1-c"
  allow_stopping_for_update = true
  

boot_disk {
  initialize_params {
  image = "ubuntu-1804-lts"
  }
}
attached_disk {
    source      = "${element(google_compute_disk.fxprdwebw1.*.self_link, count.index)}"
    device_name = "${element(google_compute_disk.fxprdwebw1.*.name, count.index)}"
}


network_interface {
  network = "default"
  access_config {
    nat_ip = "${element(google_compute_address.static-ip-address.*.address, count.index)}"
  }

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