#!/usr/bin/env bash

SSH_CONFIG_DIR="${HOME}/.ssh"
SSH_CONFIG="${SSH_CONFIG_DIR}/config"
KNOWN_HOSTS_FILE="${SSH_CONFIG_DIR}/known_hosts"

function prepare_ssh(){
    mkdir -p "${SSH_CONFIG_DIR}"
    touch "${SSH_CONFIG}"
    touch "${KNOWN_HOSTS_FILE}"
    chmod 700 "${SSH_CONFIG_DIR}"
    chmod 644 "${KNOWN_HOSTS_FILE}"
}

function configure_ssh(){
    local repo_host="$1"
    local ip="$2"
    local private_key="$3"

    echo "" > "${SSH_CONFIG}"
    echo "Host ${repo_host}" >> "${SSH_CONFIG}"
    echo " HostName ${ip}" >> "${SSH_CONFIG}"
    echo " LogLevel DEBUG3" >> "${SSH_CONFIG}"
    echo " IdentitiesOnly=yes" >> "${SSH_CONFIG}"
    echo " StrictHostKeyChecking=no" >> "${SSH_CONFIG}"
    echo " IdentityFile=${private_key}" >> "${SSH_CONFIG}"
}

function create_ssh_key(){
    local content="$1"
    local private_key_file="$2"
    echo "$content" > "${private_key_file}"
    chmod 600 "${private_key_file}"
}

function add_to_known_hosts(){
    local host="$1"
    local ip="$2"
    ssh-keygen -R "${host}"
    ssh-keygen -R "${ip}"
    ssh-keygen -R "${host},${ip}"
    ssh-keyscan -T 240 -H "${host},${ip}" >> "${KNOWN_HOSTS_FILE}"
    ssh-keyscan -T 240 -H "${ip}" >> "${KNOWN_HOSTS_FILE}"
    ssh-keyscan -T 240 -H "${host}" >> "${KNOWN_HOSTS_FILE}"
}

function discover_host_ip(){
    local host="$1"
    local ip=$(dig +short "${host}")
    if ! [[ $? -eq 0 ]]; then
        echo "Cannot discover host"
        exit 21;
    fi
    echo "$ip" | head -n1
}
