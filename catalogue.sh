script=$(realpath "$0")
#realpath $0
script_path=$(dirname "$script")
#echo $script_path
source ${script_path}/common.sh
#/root/roboshop-shell/catalogue.sh
#echo $script_name1
#echo $script
echo -e "\e[36m>>>>>>>>> Configuring NodeJS repos <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<\e[0m"
yum install nodejs -y
echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
useradd ${app_user}
echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
rm -rf /app
mkdir /app
echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/catalogue.zip
echo -e "\e[36m>>>>>>>>> Install NodeJS Dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[36m>>>>>>>>> Copy Catalogue SystemD file <<<<<<<<\e[0m"
cp ${script_path}/catalogue.service /etc/systemd/system/catalogue.service
echo -e "\e[36m>>>>>>>>> Start Catalogue Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
echo -e "\e[36m>>>>>>>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[36m>>>>>>>>> Install MongoDB Client <<<<<<<<\e[0m"
yum install mongodb-org-shell -y
echo -e "\e[36m>>>>>>>>> Load Schema <<<<<<<<\e[0m"
mongo --host mongod.panda4u.online </app/schema/catalogue.js

