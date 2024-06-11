#!/bin/bash

# მიზნის IP მისამართი
target_ip="127.0.0.1"

# შედეგების ფაილის სახელი
output_file="web_server_scan_$(date +%Y%m%d_%H%M%S).txt"

# შეტყობინება სკანირების დაწყების შესახებ
echo "ვებსერვერის სკანირება მიმდინარეობს $target_ip მისამართზე..." >> $output_file

# Nmap-ის სრული TCP პორტების სკანირება
echo "Nmap სრული TCP პორტების სკანირება:" >> $output_file
nmap -p- -oN nmap_tcp_scan.txt $target_ip
cat nmap_tcp_scan.txt >> $output_file

# Nmap-ის სრული UDP პორტების სკანირება
echo "Nmap სრული UDP პორტების სკანირება:" >> $output_file
nmap -sU -p- -oN nmap_udp_scan.txt $target_ip
cat nmap_udp_scan.txt >> $output_file

# Nmap-ის სერვისების და ვერსიების სკანირება
echo "Nmap სერვისების და ვერსიების სკანირება:" >> $output_file
nmap -sV -sC -oN nmap_service_version_scan.txt $target_ip
cat nmap_service_version_scan.txt >> $output_file

# Apache-ის კონფიგურაციის შემოწმება
echo "Apache კონფიგურაციის შემოწმება:" >> $output_file
if apache2ctl -t 2>/dev/null; then
    echo "Apache კონფიგურაცია სწორია" >> $output_file
else
    echo "Apache კონფიგურაციაში შეცდომებია" >> $output_file
fi

# საიტის კატალოგის შემოწმება
echo "საიტის კატალოგის შემოწმება:" >> $output_file
if [ -d "/var/www/html" ]; then
    echo "/var/www/html კატალოგი არსებობს" >> $output_file
    echo "შემდეგი ფაილებია ამ კატალოგში:" >> $output_file
    ls -l /var/www/html >> $output_file
else
    echo "/var/www/html კატალოგი არ არსებობს" >> $output_file
fi

# MySQL მონაცემთა ბაზის შემოწმება
echo "MySQL მონაცემთა ბაზის შემოწმება:" >> $output_file
mysql --version >> $output_file
mysql -u root -e "SELECT User, Host FROM mysql.user;" >> $output_file

# მომხმარებლის უფლებების შემოწმება
echo "მომხმარებლის უფლებების შემოწმება:" >> $output_file
cat /etc/passwd >> $output_file

# რეკომენდაციები
echo "რეკომენდაციები:" >> $output_file
echo "1. გააქტიურეთ ძირითადი HTTP უსაფრთხოების დაცვა, როგორიცაა XSS და SQL ინექციების თავიდან აცილება" >> $output_file
echo "2. დაინსტალირეთ და გამოიყენეთ ვებ აპლიკაციის ბრაუზერები, როგორიცაა OWASP ZAP ან Burp Suite" >> $output_file
echo "3. დაყენეთ სისუსტეების სკანერები და პერიოდულად გაიარეთ სკანირება" >> $output_file
echo "4. გამოიყენეთ ძლიერი პაროლები და გააქტიურეთ ორფაქტორიანი ავთენტიფიკაცია" >> $output_file
echo "5. პერიოდულად განაახლეთ ოპერაციული სისტემა, ვებსერვერი და დანარჩენი პროგრამები" >> $output_file

echo "სკანირება დასრულდა. შედეგები შენახულია $output_file ფაილში."
