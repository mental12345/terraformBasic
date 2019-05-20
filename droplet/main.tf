provider digitalocean {
}

variable "region" {
	default  = "nyc1"
}

resource "digitalocean_ssh_key" "default" {
    	name = "test_key"
    	public_key = "${file("sshKeys/id_rsa.pub")}"
}

resource "digitalocean_droplet" "web_server" {
	image = "ubuntu-18-04-x64"
	name  = "www-1"
	region = "${var.region}"
	size = "1gb"
	private_networking = true
	ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
}

