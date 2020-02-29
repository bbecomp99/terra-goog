// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("EEEo*****f.json")}"
 project     = "fox-infra"
 region      = "us-central-a"
}
