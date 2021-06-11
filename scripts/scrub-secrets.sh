
for o in $1/*.yaml; do 
    echo Scrubbing $o
    cat $o |  yq eval '.data.username="hidden-username"' - |   yq eval '.data.".dockercfg"="hidden-docker"'  - | yq eval '.data.password="hidden-password"'  - > tmp.yaml 
    mv tmp.yaml $o
    echo 'Scrubbed file: ' $o
    cat $o
    echo '----'
done