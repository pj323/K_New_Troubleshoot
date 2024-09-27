# Function to log into clusters
function k-login() {
    echo "Please select the cluster to log into:"
    echo "1) EDCO-TEST"
    echo "2) EDCR-PROD"
    echo "3) EDCO-PROD"
    read -p "Enter the number of your choice: " choice

    case $choice in
        1)
            echo "Executing: ./kubelogin_setup.sh -s -c k8s-test-edco"
            ./kubelogin_setup.sh -s -c k8s-test-edco && echo "Logged into EDCO-TEST Successfully"
            ;;
        2)
            echo "Executing: ./kubelogin_setup.sh -s -c k8s-prod-edcr"
            ./kubelogin_setup.sh -s -c k8s-prod-edcr && echo "Logged into EDCR-PROD Successfully"
            ;;
        3)
            echo "Executing: ./kubelogin_setup.sh -s -c k8s-prod-edco"
            ./kubelogin_setup.sh -s -c k8s-prod-edco && echo "Logged into EDCO-PROD Successfully"
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Function to switch between namespaces
function k-switch() {
    echo "Please select the namespace to switch to:"
    echo "1) tp2-edcb-cache-sbx-a"
    echo "2) cache-test"
    echo "3) cache-prep"
    echo "4) cache-prod"
    echo "5) cache-utility"
    echo "6) tp2-edco-cache-test-a"
    echo "7) tp2-edco-cache-test-b"
    echo "8) tp2-edco-cache-test-c"
    echo "9) tp2-edco-cache-test-d"
    echo "10) tp2-cache-prod-a"
    echo "11) tp2-cache-prod-b"
    read -p "Enter the number of your choice: " choice

    case $choice in
        1)
            echo "Executing: kubectl config set-context --current --namespace=tp2-edcb-cache-sbx-a"
            kubectl config set-context --current --namespace=tp2-edcb-cache-sbx-a && echo "Namespace switched to tp2-edcb-cache-sbx-a Successfully"
            ;;
        2)
            echo "Executing: kubectl config set-context --current --namespace=cache-test"
            kubectl config set-context --current --namespace=cache-test && echo "Namespace switched to cache-test Successfully"
            ;;
        3)
            echo "Executing: kubectl config set-context --current --namespace=cache-prep"
            kubectl config set-context --current --namespace=cache-prep && echo "Namespace switched to cache-prep Successfully"
            ;;
        4)
            echo "Executing: kubectl config set-context --current --namespace=cache-prod"
            kubectl config set-context --current --namespace=cache-prod && echo "Namespace switched to cache-prod Successfully"
            ;;
        5)
            echo "Executing: kubectl config set-context --current --namespace=cache-utility"
            kubectl config set-context --current --namespace=cache-utility && echo "Namespace switched to cache-utility Successfully"
            ;;
        6)
            echo "Executing: kubectl config set-context --current --namespace=tp2-edco-cache-test-a"
            kubectl config set-context --current --namespace=tp2-edco-cache-test-a && echo "Namespace switched to tp2-edco-cache-test-a Successfully"
            ;;
        7)
            echo "Executing: kubectl config set-context --current --namespace=tp2-edco-cache-test-b"
            kubectl config set-context --current --namespace=tp2-edco-cache-test-b && echo "Namespace switched to tp2-edco-cache-test-b Successfully"
            ;;
        8)
            echo "Executing: kubectl config set-context --current --namespace=tp2-edco-cache-test-c"
            kubectl config set-context --current --namespace=tp2-edco-cache-test-c && echo "Namespace switched to tp2-edco-cache-test-c Successfully"
            ;;
        9)
            echo "Executing: kubectl config set-context --current --namespace=tp2-edco-cache-test-d"
            kubectl config set-context --current --namespace=tp2-edco-cache-test-d && echo "Namespace switched to tp2-edco-cache-test-d Successfully"
            ;;
        10)
            echo "Executing: kubectl config set-context --current --namespace=tp2-cache-prod-a"
            kubectl config set-context --current --namespace=tp2-cache-prod-a && echo "Namespace switched to tp2-cache-prod-a Successfully"
            ;;
        11)
            echo "Executing: kubectl config set-context --current --namespace=tp2-cache-prod-b"
            kubectl config set-context --current --namespace=tp2-cache-prod-b && echo "Namespace switched to tp2-cache-prod-b Successfully"
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

function k-options() {
    echo "Please select an option:"
    echo "1) kubectl get pods"
    echo "2) kubectl get pods -w"
    echo "3) kubectl get sts"
    echo "4) kubectl get configmap"
    echo "5) k-get-logs"
    echo "6) kubectl get svc"
    echo "7) kubectl get pvc"
    echo "8) scale-sts"
    read -p "Enter the number of your choice: " choice

    case $choice in
        1)
            echo "Executing: kubectl get pods"
            kubectl get pods
            ;;
        2)
            echo "Executing: kubectl get pods -w"
            kubectl get pods -w
            ;;
        3)
            echo "Executing: kubectl-sts-options"
            kubectl-sts-options
            ;;
        4)
            echo "Executing: kubectl-configmap-options"
            kubectl-configmap-options
            ;;
        5)
            echo "Executing: k-get-logs"
            k-get-logs
            ;;
        6)
            echo "Executing: kubectl get svc"
            kubectl get svc
            ;;
        7)
            echo "Executing: kubectl get pvc"
            kubectl get pvc
            ;;
        8)
            echo "Executing: scale-sts"
            scale-sts
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

function k-get-logs() {
    read -p "Enter pod name: " POD_NAME
    echo "Executing: winpty kubectl exec -it $POD_NAME -- sh -c 'cd ../redis_data && tail -n 500 redis-server.log'"
    winpty kubectl exec -it "$POD_NAME" -- sh -c 'cd ../redis_data && tail -n 500 redis-server.log'
    if [ $? -eq 0 ]; then
        echo "First command executed successfully"
    else
        echo "First command failed"
    fi
    echo "Executing: kubectl logs pod/$POD_NAME -c redis"
    kubectl logs pod/"$POD_NAME" -c redis
    if [ $? -eq 0 ]; then
        echo "Second command executed successfully"
    else
        echo "Second command failed"
    fi
}

function scale-sts() {
    read -p "Enter the StatefulSet name: " SERVICE_NAME
    read -p "Enter the number of replicas: " REPLICAS_NUMBER
    read -p "Are you sure you want to scale $SERVICE_NAME to $REPLICAS_NUMBER replicas? (y/n): " CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
        echo "Executing: kubectl scale sts $SERVICE_NAME --replicas=$REPLICAS_NUMBER"
        kubectl scale sts "$SERVICE_NAME" --replicas="$REPLICAS_NUMBER"
        if [ $? -eq 0 ]; then
            echo "StatefulSet scaled successfully"
        else
            echo "Failed to scale StatefulSet"
        fi
    else
        echo "Operation canceled."
    fi
}

function kubectl-configmap-options() {
    echo "ConfigMap Options:"
    echo "1) kubectl get configmap"
    echo "2) kubectl get configmap <configmap-name> -o yaml"
    echo "3) kubectl edit configmap <configmap-name>"
    read -p "Enter the number of your choice: " cfg_choice

    case $cfg_choice in
        1)
            echo "Executing: kubectl get configmap"
            kubectl get configmap
            ;;
        2)
            read -p "Enter the ConfigMap name: " CONFIGMAP_NAME
            echo "Executing: kubectl get configmap $CONFIGMAP_NAME -o yaml"
            kubectl get configmap "$CONFIGMAP_NAME" -o yaml
            ;;
        3)
            read -p "Enter the ConfigMap name: " CONFIGMAP_NAME
            echo "Executing: kubectl edit configmap $CONFIGMAP_NAME"
            kubectl edit configmap "$CONFIGMAP_NAME"
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

function kubectl-sts-options() {
    echo "StatefulSet Options:"
    echo "1) kubectl get sts"
    echo "2) kubectl get sts <sts-name> -o json"
    echo "3) kubectl edit sts <sts-name>"
    read -p "Enter the number of your choice: " sts_choice

    case $sts_choice in
        1)
            echo "Executing: kubectl get sts"
            kubectl get sts
            ;;
        2)
            read -p "Enter the StatefulSet name: " STS_NAME
            echo "Executing: kubectl get sts $STS_NAME -o json"
            kubectl get sts "$STS_NAME" -o json
            ;;
        3)
            read -p "Enter the StatefulSet name: " STS_NAME
            echo "Executing: kubectl edit sts $STS_NAME"
            kubectl edit sts "$STS_NAME"
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}


