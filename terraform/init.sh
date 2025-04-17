#!/bin/bash
set -e

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

# Tải và cài đặt Amazon Corretto 17
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

# Khởi tạo cơ sở dữ liệu PostgreSQL
sudo amazon-linux-extras enable postgresql14
sudo yum clean metadata
sudo yum install -y postgresql postgresql-server
sudo postgresql-setup initdb
sudo systemctl start postgresql
sudo systemctl enable postgresql
# Cấu hình PostgreSQL để lắng nghe kết nối từ bên ngoài
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf
sudo sed -i "s/host    all             all             127.0.0.1\/32            md5/host    all             all             0.0.0.0\/0            md5/" /var/lib/pgsql/data/pg_hba.conf

# Khởi động lại PostgreSQL để áp dụng thay đổi cấu hình
sudo systemctl restart postgresql

# Tạo thư mục cho app
mkdir -p /home/ec2-user/app
sudo chown -R ec2-user:ec2-user /home/ec2-user/app
cd /home/ec2-user/app
git clone https://github.com/YenTranSl/note-app.git .

chmod +x mvnw
./mvnw package -DskipTests

# Build và chạy Docker container
sudo docker build -t note-app .
sudo docker run -d -p 8080:8080 --name note-app note-app
sudo docker rm note-app