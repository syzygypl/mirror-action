#!make
include .env
export

ORIGIN_SSH_KEY=`cat ${ORIGIN_SSH_KEY_FILE}`
MIRROR_SSH_KEY=`cat ${MIRROR_SSH_KEY_FILE}`

build:
	docker build -t syzygypl/mirror-action:latest .

run: build
	docker run \
	-e "INPUT_ORIGINSSHKEY=${ORIGIN_SSH_KEY}" \
	-e "INPUT_MIRRORSSHKEY=${MIRROR_SSH_KEY}" \
	-e "INPUT_MIRRORREPOURL=${REPO_URL}" \
	-e "GITHUB_REPOSITORY=syzygypl/mirror-action" \
	-e "HOME=/github/actions" \
	syzygypl/mirror-action:latest

run-bash: build
	docker run \
	-e "INPUT_ORIGINSSHKEY=${ORIGIN_SSH_KEY}" \
	-e "INPUT_MIRRORSSHKEY=${MIRROR_SSH_KEY}" \
	-e "INPUT_MIRRORREPOURL=${REPO_URL}" \
	-e "GITHUB_REPOSITORY=${REPO_URL}" \
	-e "HOME=/github/actions" \
	-it --entrypoint="/bin/bash" \
	syzygypl/mirror-action:latest
