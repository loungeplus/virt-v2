#!/bin/bash
line_count=$(oc get namespace -o custom-columns=":metadata.name" | egrep -c "showroom-user")

for ((i=1; i<=line_count; i++)); do
    NS="showroom-user"$i
    oc scale -n $NS deploy/showroom --replicas=0
    sleep 1
    oc patch -n $NS deploy/showroom --patch='{"spec":{"template":{"spec":{"containers": [{"name": "content","env": [{"name": "GIT_REPO_URL", "value": "https://github.com/RH-OPEN/openshift-virt-roadshow-cnv-multi-user-jp-2025"}, {"name": "GIT_REPO_REF", "value": "main"}]}]}}}}'
    oc scale -n $NS deploy/showroom --replicas=1
done