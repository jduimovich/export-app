k get pods --field-selector=status.phase=Running -o json | jq .items[0].metadata.name > pods
set /P PODSQ=< pods
del pods
Set PODS=%PODSQ:"=% 
kubectl exec --stdin --tty %PODS%  -- /bin/bash