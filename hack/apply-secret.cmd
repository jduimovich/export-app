@echo off
set CURRENT_DIR=%cd%
set SCRIPT_DIR=%~dp0

set DEPLOY_GIT_SECRET=deploy-secret\gitsecret.yaml 
set DEPLOY_GIT_CONFIG=deploy-secret\gitconfigmap.yaml

echo "Secret being installed from ENV MY_GITHUB_USER and MY_GITHUB_TOKEN"
echo "Secret Manifest is " %DEPLOY_GIT_SECRET% 

yq e ".stringData.username=\"%MY_GITHUB_USER%\"" %DEPLOY_GIT_SECRET% | yq e ".stringData.password=\"%MY_GITHUB_TOKEN%\"" - | kubectl apply -f -

yq e ".data.username=\"%MY_GITHUB_USERNAME%\"" %DEPLOY_GIT_CONFIG% > tmp.yaml
yq e ".data.email=\"%MY_GITHUB_EMAIL%\"" tmp.yaml > tmp2.yaml
yq e ".data.repo=\"%MY_GITHUB_REPO%\"" tmp2.yaml > tmp.yaml
kubectl apply -f tmp.yaml
type tmp.yaml
del tmp*.yaml



 


 