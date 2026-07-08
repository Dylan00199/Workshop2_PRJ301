# Sử dụng image Tomcat (chọn bản jdk phù hợp với project của bro, ví dụ jdk11)
FROM tomcat:9.0-jdk8-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war của project vào thư mục webapps của Tomcat và đổi tên thành ROOT.war để chạy ở trang chủ
# LƯU Ý: Thay đổi đường dẫn tới file .war thực tế của bro
COPY ./build/web /usr/local/tomcat/webapps/ROOT/
# Mở port 8080
EXPOSE 8080

# Chạy Tomcat
CMD ["catalina.sh", "run"]
