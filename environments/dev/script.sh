#!/bin/bash
echo "Hello, world! This is Jyldyz!"
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
