source "yandex" "yc-toolbox" {
  disk_type           = "network-hdd"
  folder_id           = "......................"
  image_description   = "my custom debian with docker"
  image_name          = "yc-toolbox"
  source_image_family = "ubuntu-2004-lts"
  ssh_username        = "ubuntu"
  subnet_id           = "......................"
  token               = "y0_........................"
  use_ipv4_nat        = true
  zone                = "ru-central1-a"
}

build {
  sources = ["source.yandex.yc-toolbox"]

  provisioner "shell" {
    inline = [
      "echo 'hello from packer'",
      
      # Docker
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce containerd.io",
      "sudo usermod -aG docker $USER",
      "sudo chmod 666 /var/run/docker.sock",
      "sudo useradd -m -s /bin/bash -G docker yc-user",

      # Other packages
      "sudo apt-get install -y htop tmux"
    ]  
  }
}
