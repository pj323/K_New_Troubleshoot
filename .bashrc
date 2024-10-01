Determine Your Shell
You can check which shell you're currently using by running:

STEP 1:

`echo $SHELL`
If it returns /bin/zsh, you're using zsh.
If it returns /bin/bash, you're using bash.

STEP 2:

`nano ~/.bashrc` or `nano ~/.zshrc` based on what result you get. or you can open the file with any editor you want of yoiu choice.

STEP 4:

Just copy the contents from the this file: 
SAVE and EXIT

STEP 5:

`source ~/.bashrc` or `source ~/.zshrc`

Once you have sourced successfully:

Try running these commands:

`k-login`
`k-switch`
`k-opyions`


# Function to fetch Redis configuration
function fetch_redis_conf() {
    read -p "Enter instance name: " INSTANCE_NAME

    # Try to find ConfigMap for cache environments
    CONFIGMAP_NAME=$(kubectl get configmaps | grep "${INSTANCE_NAME}-test-redis-ha-configmap" | awk '{print $1}')
    if [[ ! -z "$CONFIGMAP_NAME" ]]; then
        echo "Found ConfigMap: $CONFIGMAP_NAME"
        echo "Fetching redis.conf section..."
        # Fetch the entire ConfigMap and extract the redis.conf section until 'logfile'
        kubectl get configmap "$CONFIGMAP_NAME" -o yaml | sed -n '/redis\.conf:/,/logfile/p'
    else
    fi
}

# Function to fetch StatefulSet details
function fetch_sts() {
    read -p "Enter instance name: " INSTANCE_NAME

    # Try to find StatefulSet for cache environments
    STS_NAME=$(kubectl get sts | grep "${INSTANCE_NAME}-test-redis-ha-server" | awk '{print $1}')
    if [[ ! -z "$STS_NAME" ]]; then
        echo "Found StatefulSet: $STS_NAME"
        echo "Fetching StatefulSet details..."
        kubectl get sts "$STS_NAME" -o json | jq '{name: .metadata.name, replicas: .spec.replicas, containers: [.spec.template.spec.containers[] | {name: .name, image: .image, resources: .resources}]}'
    else
        # Try to find StatefulSet for tp2 environments
        STS_NAME=$(kubectl get sts | grep "${INSTANCE_NAME}-cache-redis" | awk '{print $1}')
        if [[ ! -z "$STS_NAME" ]]; then
            echo "Found StatefulSet: $STS_NAME"
            echo "Fetching StatefulSet details..."
            kubectl get sts "$STS_NAME" -o json | jq '{name: .metadata.name, replicas: .spec.replicas, containers: [.spec.template.spec.containers[] | {name: .name, image: .image, resources: .resources}]}'
        else
            echo "No StatefulSet found for $INSTANCE_NAME in the current namespace."
        fi
    fi
}

# Function for troubleshooting options
function troubleshoot() {
    echo "Troubleshoot Options:"
    echo "1) Fetch Redis Config"
    echo "2) Fetch StatefulSet (sts)"
    read -p "Enter the number of your choice: " ts_choice

    case $ts_choice in
        1)
            echo "Executing: Fetch Redis Config"
            fetch_redis_conf
            ;;
        2)
            echo "Executing: Fetch StatefulSet (sts)"
            fetch_sts
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Existing k-options function with the new troubleshoot option added
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
    echo "9) troubleshoot"
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
            echo "Executing: kubectl get sts"
            kubectl get sts
            ;;
        4)
            echo "Executing: kubectl get configmap"
            kubectl get configmap
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
        9)
            echo "Executing: troubleshoot"
            troubleshoot
            ;;
        *)
            echo "Invalid option."
            ;;
    esac
}

# Existing k-get-logs function
function k-get-logs() {
    read -p "Enter pod name: " POD_NAME
    read -p "Are you using Windows or macOS? (Enter 'Windows' or 'macOS'): " OS_TYPE

    # Convert input to lowercase to handle case variations
    OS_TYPE=$(echo "$OS_TYPE" | tr '[:upper:]' '[:lower:]')

    if [[ "$OS_TYPE" == "macos" ]]; then
        echo "Executing: kubectl exec -it $POD_NAME -- sh -c 'cd ../redis_data && tail -n 500 redis-server.log'"
        kubectl exec -it "$POD_NAME" -- sh -c 'cd ../redis_data && tail -n 500 redis-server.log'
    elif [[ "$OS_TYPE" == "windows" ]]; then
        echo "Executing: winpty kubectl exec -it $POD_NAME -- sh -c 'cd ../redis_data && tail -n 500 redis-server.log'"
        winpty kubectl exec -it "$POD_NAME" -- sh -c 'cd ../redis_data && tail -n 500 redis-server.log'
    else
        echo "Invalid input. Please enter 'Windows' or 'macOS'."
        return 1
    fi

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

# Existing scale-sts function
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

