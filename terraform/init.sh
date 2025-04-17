#!/bin/bash
sudo yum update -y
sudo yum install -y docker git
sudo service docker start
sudo usermod -aG docker ec2-user

# Clone app từ GitHub
cd /home/ec2-user
git clone https://github.com/<your-username>/note-app.git
cd note-app
./mvnw package -DskipTests
docker build -t note-app .
docker run -d -p 8081:8080 note-app
