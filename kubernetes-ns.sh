#!/bin/bash

echo "1- Delete Stuck Terminatin NameSpace"
echo "2- Get Resource in NameSpace"
echo -n "Enter Number: "
read NUMBER

case $NUMBER in

  1)
    echo "Delete Stuck Terminatin NameSpace"
    echo -n "Enter your namespace: "
    read NAMESPACE  # get namespace from user
    
    # run command
    kubectl get namespace "$NAMESPACE" -o json \
    | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
    | kubectl replace --raw /api/v1/namespaces/$NAMESPACE/finalize -f -
    ;;

  2)
    echo "Get Resource in NameSpace"
    echo -n "Enter your namespace: "
    read NAMESPACE  # get namespace from user

    #run command
    kubectl api-resources --verbs=list --namespaced -o name \
    | xargs -n 1 kubectl get --show-kind --ignore-not-found -n $NAMESPACE
    ;;

  *)
    echo "unknown"
    ;;
esac
