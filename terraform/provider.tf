// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("Fox Infra-3668afdf9e8f.json")}"
 project     = "fox-infra"
 region      = "us-central-a"
}