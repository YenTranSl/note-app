# 🏗️ Note App Deployment with Terraform & Docker

Đây là repo minh họa cách triển khai một ứng dụng Java Spring Boot (Note App) bằng cách sử dụng mô hình **Infrastructure as Code (IaC)** với **Terraform**, **EC2**, **Docker**, và **PostgreSQL**.

## 📌 Mục tiêu

Giới thiệu quy trình tự động hóa triển khai hạ tầng và ứng dụng trên AWS thông qua:
- **Terraform** để tạo EC2 instance
- **User data script** để cài môi trường (Docker, PostgreSQL, Java)
- **Docker** để đóng gói và chạy ứng dụng
- **PostgreSQL** làm cơ sở dữ liệu
- **GitHub** làm nơi chứa mã nguồn ứng dụng

---

## 🧱 Kiến trúc tổng quan

1. Sử dụng Terraform để tạo EC2 trên AWS
2. EC2 tự động cài đặt Docker, Java (Corretto 17), PostgreSQL thông qua bash script
3. Clone source code từ GitHub và build app
4. Chạy ứng dụng Spring Boot dưới dạng Docker container
5. Ứng dụng kết nối đến PostgreSQL cài sẵn trên EC2

---

## 🚀 Hướng dẫn sử dụng

### 1. Chuẩn bị

- Tài khoản AWS và Access Key
- Cài sẵn:
  - [Java 17+](https://docs.aws.amazon.com/corretto/)
  - [Docker](https://www.docker.com/)
  - [Terraform](https://developer.hashicorp.com/terraform/downloads)
  - [Git](https://git-scm.com/)
  - [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

📌 ***Lưu ý:*** Sau khi cài đặt `AWS CLI` cần tiến hành cấu hình AWS.
```bash
aws configure --profile myprofile
```
Thiết lập các thông tin:
- Access Key ID
- Secret Access Key
- Region (ví dụ: ap-southeast-1)
- Output format (có thể để json)

Để đảm bảo Docker hoạt động, có thể chạy lệnh:
```bash
docker --version
```

---
### 2. Clone Repo

```bash
git clone https://github.com/YenTranSl/note-app.git
cd note-app
```

---
### 3. Cấu hình biến môi trường

Tạo file `.env` ở thư mục gốc chứa nội dung tương tự như file `.env.example`:

```
PG_URL=
PG_USERNAME=
PG_PASSWORD=
...
```

---
### 4. Triển khai bằng Terraform

```bash
cd terraform
terraform init
terraform apply
```

Sau khi chạy `apply`, Terraform sẽ thực hiện:

- Tạo EC2
- EC2 khởi động script trong `init.sh`
- Cài Docker, Java, PostgreSQL
- Pull mã nguồn và build Docker image
- Chạy ứng dụng trên port `8080`

---
### 5. Truy cập ứng dụng

Mở trình duyệt và truy cập:

```
http://18.140.67.249:8080/api/notes
```

> 📌 *Lưu ý:* `18.140.67.249` là public IP của EC2 instance vừa được tạo, IP này sẽ khác nhau với mỗi instance.

---
### 6. Ghi chú triển khai

- Đây là PoC (Proof of Concept) cho seminar môn học
- Ứng dụng có thể mở rộng ra nhiều instance, sử dụng S3, ALB, RDS nếu cần
- Đã áp dụng CI/CD.

---
### 7. Tài liệu tham khảo

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Spring Boot Docker](https://spring.io/guides/gs/spring-boot-docker/)
- [Amazon Corretto](https://docs.aws.amazon.com/corretto/)
