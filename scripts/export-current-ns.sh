#!/bin/bash 
 
# Identify all objects
EXCLUSIONS="images|image.openshift.io|events|machineautoscalers.autoscaling.openshift.io|credentialsrequests.cloudcredential.openshift.io|podnetworkconnectivitychecks.controlplane.operator.openshift.io|leases.coordination.k8s.io|machinehealthchecks.machine.openshift.io|machines.machine.openshift.io|machinesets.machine.openshift.io|baremetalhosts.metal3.io|pods.metrics.k8s.io|alertmanagerconfigs.monitoring.coreos.com|alertmanagers.monitoring.coreos.com|podmonitors.monitoring.coreos.com|volumesnapshots.snapshot.storage.k8s.io|profiles.tuned.openshift.io|tuneds.tuned.openshift.io|endpointslice.discovery.k8s.io|ippools.whereabouts.cni.cncf.io|overlappingrangeipreservations.whereabouts.cni.cncf.io|packagemanifests.packages.operators.coreos.com|endpointslice.discovery.k8s.io|endpoints|pods"

IGNORES="argocd|primer|secret-key|kube-root-ca.crt|image-puller|kubernetes.io/service-account-token|builder|default|default-token|default-dockercfg|deployer|openshift-gitops-operator|redhat-openshift-pipelines-operator|edit|admin|pipeline-dockercfg"

RESOURCES=`kubectl api-resources --verbs=list --namespaced -o name | egrep -v $EXCLUSIONS | awk -F. '{print $1}'`

DBG_DIR=$(pwd)/debug
OUTPUT_DIR=$(pwd)/export
rm -rf $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
rm -rf $DBG_DIR
mkdir -p $DBG_DIR

echo Output to $OUTPUT_DIR

SCRIPT_DIR=$(dirname "$0")

# Generate yamls
for o in $RESOURCES; do  
      bash $SCRIPT_DIR/export-resources.sh $OUTPUT_DIR $DBG_DIR $IGNORES $o   
done 
bash $SCRIPT_DIR/scrub-secrets.sh $OUTPUT_DIR/secrets

tar cvf html/export.tar export
echo 'files can be found in export.tar'

tree $OUTPUT_DIR > tree.txt
echo 'tree view in html/tree.html'    
echo  '<!DOCTYPE html>' > html/tree.html
echo  '<html lang="en"> <title>Export Tree</title><body><pre>' >> html/tree.html
cat tree.txt  >> html/tree.html
echo  '</pre></body></html>' >> html/tree.html


 
