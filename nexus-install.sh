#!/bin/bash

# Install Java
sudo yum install -y java-11-amazon-corretto wget

# Download Nexus
cd /opt
sudo wget https://download.sonatype.com/nexus/3/nexus-3.79.1-04-linux-x86_64.tar.gz
sudo tar -xvf nexus-3.79.1-04-linux-x86_64.tar.gz
sudo mv nexus-3.79.1-04 nexus

# Create nexus user
sudo useradd nexus
sudo chown -R nexus:nexus /opt/nexus /opt/sonatype-work

# Set low memory for t3.small
echo -e "-Xms256m\n-Xmx1024m\n-XX:MaxDirectMemorySize=256m\n-Dkaraf.home=/opt/nexus\n-Dkaraf.base=/opt/nexus\n-Dkaraf.data=/opt/sonatype-work/nexus3\n-Dkaraf.log=/opt/sonatype-work/nexus3/log" | sudo tee /opt/nexus/bin/nexus.vmoptions

sudo chown nexus:nexus /opt/nexus/bin/nexus.vmoptions

# Run as nexus user
sudo sed -i 's/#run_as_user=""/run_as_user="nexus"/' /opt/nexus/bin/nexus

# Start Nexus
sudo -u nexus /opt/nexus/bin/nexus start

echo "Nexus started on: http://<EC2-PUBLIC-IP>:8081"
