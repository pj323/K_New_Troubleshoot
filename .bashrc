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


