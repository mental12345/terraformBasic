provider digitalocean {
}

data "digitalocean_image" "jenkins_vault_image" {
  name = "jenkins-vault-image"
}

data "digitalocean_volume_snapshot" "jenkins_vault_snapshot" {
  name_regex  = "jenkins_vault*"
  region      = "${var.region}"
  most_recent = true
}

resource "digitalocean_volume" "jenkins_vault_volume" {
    region      = "${var.region}"
    name        = "jenkins_vault_volume"
    size        = "${data.digitalocean_volume_snapshot.jenkins_vault_snapshot.min_disk_size}"
    snapshot_id = "${data.digitalocean_volume_snapshot.jenkins_vault_snapshot.id}"
}

resource "digitalocean_ssh_key" "default" {
    name = "default"
    public_key = "${file("ssh/digitalKey.pub")}"
}

resource "digitalocean_droplet" "jenkins-vault-droplet" {
    image  = "${data.digitalocean_image.jenkins_vault_image.image}"
    name   = "JenkinsVaultDroplet"
    region = "${var.region}"
    size   = "${var.droplet_size}"
    ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
}

resource "digitalocean_volume_attachment" "jenkins_volume_attachment" {
    droplet_id = "${digitalocean_droplet.jenkins-vault-droplet.id}"
    volume_id  = "${digitalocean_volume.jenkins_vault_volume.id}"
}
