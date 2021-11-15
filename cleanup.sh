params="-e LINODE_CLI_TOKEN=7f5678249474167c15a36ddc60c7a2656f9b4caf53b7fb5fa5907a9b932ed71c"
params="$params -e LINODE_CLI_OBJ_ACCESS_KEY=DOAV6P7692B64PLL8A80"
params="$params -e LINODE_CLI_OBJ_SECRET_KEY=qt5hUupKXeCv4KDjlhtqbNWuctfHj4tBjpmwwnja"
docker run $params --rm linode-cli linode-cli obj --cluster eu-central-1 rm docker-swarm-bucket-test join-swarm-as-worker
docker run $params --rm linode-cli linode-cli obj --cluster eu-central-1 rm docker-swarm-bucket-test join-swarm-as-manager
