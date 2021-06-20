# examples-reverse-proxy
Some basic examples using popular reverse proxies, to get you started.

## USING DOCKER-COMPOSE
```bash
# MAKEFILE: Example testing envoy proxy, with 3 backend services
make dc-envoy
watch 'curl -v localhost:8080' # CTRL-C to stop
make dcd-envoy
```

```bash
# MANUALLY: Example testing envoy proxy, with 3 backend services
cd ./docker-compose
docker-compose -f docker-compose.yaml -f docker-compose.envoy.yaml up -d
watch 'curl -v localhost:8080' # CTRL-C to stop
docker-compose -f docker-compose.yaml -f docker-compose.envoy.yaml down
```
## USING TERRAFORM
```bash
# MAKEFILE: Example testing traefik proxy, with 3 backend services
make tf-traefik
watch 'curl -v localhost:8080' # CTRL-C to stop
make tfd-traefik
```
```bash
# MANUALLY: Example testing traefik proxy (default), with 3 backend services
cd ./terraform
terraform apply -auto-approve
watch 'curl -v localhost:8080' # CTRL-C to stop
terraform destroy -auto-approve
```