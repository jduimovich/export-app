@echo off
set CURRENT_DIR=%cd%
set SCRIPT_DIR=%~dp0

set GIT_SECRET=deploy-secret\gitsecret.yaml 
set GIT_CONFIG=deploy-secret\gitconfig.yaml

echo "Secret being installed from ENV MY_GITHUB_USER and MY_GITHUB_TOKEN"
echo "Secret Manifest is " %GIT_SECRET% 

yq e ".stringData.username=\"%MY_GITHUB_USER%\"" %GIT_SECRET% | yq e ".stringData.password=\"%MY_GITHUB_TOKEN%\"" - | kubectl apply -f -

echo "Username and password being installed from ENV MY_GITHUB_USERNAME and MY_GITHUB_EMAIL"
yq e ".data.username=\"%MY_GITHUB_USERNAME%\"" %GIT_CONFIG% | yq e ".data.email=\"%MY_GITHUB_EMAIL%\"" - | kubectl apply -f -


  
  

 