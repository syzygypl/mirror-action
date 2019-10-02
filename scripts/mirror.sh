#!/usr/bin/env bash

set -eux

export ROOT="$( cd "$( dirname ""${BASH_SOURCE[0]}"" )" >/dev/null && pwd )"

source "$ROOT/init_inputs.sh"
source "$ROOT/ssh.sh"
source "$ROOT/git.sh"

prepare_ssh

ORIGIN_REPO_IP=$(discover_host_ip ${ORIGIN_REPO_HOST})
MIRROR_REPO_IP=$(discover_host_ip ${MIRROR_REPO_HOST})
add_to_known_hosts "${ORIGIN_REPO_HOST}" "${ORIGIN_REPO_IP}"
add_to_known_hosts "${MIRROR_REPO_HOST}" "${MIRROR_REPO_IP}"
create_ssh_key "${ORIGIN_REPO_SSH_KEY}" "${ORIGIN_REPO_SSH_KEY_FILE}"
create_ssh_key "${MIRROR_REPO_SSH_KEY}" "${MIRROR_REPO_SSH_KEY_FILE}"

configure_ssh "${ORIGIN_REPO_HOST}" "${ORIGIN_REPO_IP}" "${ORIGIN_REPO_SSH_KEY_FILE}"
clone "${ORIGIN_REPO_URL}" "${TMP_REPO_DIR}"

modify_git_config "${ORIGIN_REPO_USER}"
modify_repo_git_config "${TMP_REPO_DIR}"

configure_ssh "${MIRROR_REPO_HOST}" "${MIRROR_REPO_IP}" "${MIRROR_REPO_SSH_KEY_FILE}"
push "${TMP_REPO_DIR}" "${MIRROR_REPO_URL}"
