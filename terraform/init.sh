#!/bin/bash
set -e

# Cập nhật hệ thống và cài đặt Docker + Git
sudo yum update -y
sudo yum install -y docker git
sudo usermod -aG docker ec2-user

# Start Docker và enable auto-start
sudo systemctl start docker
sudo systemctl enable docker

# Chờ Docker khởi động
until docker info >/dev/null 2>&1; do
    echo "Đang chờ Docker khởi động..."
    sleep 3
done

sudo docker network create yentran-network
sudo docker run -d --name postgresql -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=notes_app -p 5432:5432 --network yentran-network postgres:latest

# Tải và cài đặt Amazon Corretto 17 (Java 17)
cd /tmp
wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.tar.gz
sudo mkdir -p /usr/lib/jvm
sudo tar -xzf amazon-corretto-17-x64-linux-jdk.tar.gz -C /usr/lib/jvm

# Lấy tên thư mục chính xác sau khi giải nén
JAVA_DIR=$(ls -d /usr/lib/jvm/amazon-corretto-17*)

# Cấu hình Java 17 mặc định
sudo alternatives --install /usr/bin/java java "$JAVA_DIR/bin/java" 2000
sudo alternatives --install /usr/bin/javac javac "$JAVA_DIR/bin/javac" 2000
sudo alternatives --set java "$JAVA_DIR/bin/java"
sudo alternatives --set javac "$JAVA_DIR/bin/javac"

# Clone mã nguồn và build ứng dụng
mkdir -p /home/ec2-user/app
sudo chown -R ec2-user:ec2-user /home/ec2-user/app
cd /home/ec2-user/app
export HOME=/home/ec2-user
git clone https://github.com/YenTranSl/note-app.git .
chmod +x mvnw
./mvnw package -DskipTests

# Build và chạy Docker container
sudo docker build -t note-app .
sudo docker run -d --name note-app -p 8080:8080 -e PG_URL=jdbc:postgresql://postgresql:5432/notes_app -e PG_USERNAME=postgres -e PG_PASSWORD=postgres --network yentran-network note-app
