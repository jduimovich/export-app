set CURRENT_DIR=%cd%
set SCRIPT_DIR=%~dp0

for %%I in (.) do SET BASE=%%~nxI

echo Building %BASE%   

docker build -t %MY_DOCKER_USER%/%BASE% . 

docker push %MY_DOCKER_USER%/%BASE%  
 

call deploy-with-secret.cmd
 

 