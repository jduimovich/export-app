@echo off
set CURRENT_DIR=%cd%
set SCRIPT_DIR=%~dp0

set GIT_SECRET=deploy-secret\gitsecret.yaml
echo "Secret being installed from ENV MY_GITHUB_USER and MY_GITHUB_TOKEN"
echo "Secret Manifest is " %GIT_SECRET% 

yq e ".stringData.username=\"%MY_GITHUB_USER%\"" %GIT_SECRET% | yq e ".stringData.password=\"%MY_GITHUB_TOKEN%\"" - | kubectl apply -f -


  

 