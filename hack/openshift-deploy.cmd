
set CURRENT_DIR=%cd%
set SCRIPT_DIR=%~dp0

kubectl delete -f deploy-openshift 
call  %SCRIPT_DIR%apply-secret.cmd 
kubectl apply -f deploy-openshift 


 