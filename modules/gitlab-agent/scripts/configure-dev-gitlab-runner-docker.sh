gitlab-runner register -n \
  --url "https://git.risa.gov.rw" \
  --registration-token "wbK4mcBYCFtRs3x_iiE9" \
  --executor "docker" \
  --description $1 \
  --docker-image "docker:19.03.12" \
  --docker-volumes "/var/run/docker.sock:/var/run/docker.sock" \
  --tag-list $2