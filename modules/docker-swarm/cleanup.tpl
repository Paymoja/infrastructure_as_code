params="-e LINODE_CLI_TOKEN=${token}"
params="$params -e LINODE_CLI_OBJ_ACCESS_KEY=DOAV6P7692B64PLL8A80"
params="$params -e LINODE_CLI_OBJ_SECRET_KEY=qt5hUupKXeCv4KDjlhtqbNWuctfHj4tBjpmwwnja"
docker run $params --rm linode-cli linode-cli obj --cluster eu-central-1 rm docker-swarm-bucket-${environment_name} join-swarm-as-worker
docker run $params --rm linode-cli linode-cli obj --cluster eu-central-1 rm docker-swarm-bucket-${environment_name} join-swarm-as-manager
