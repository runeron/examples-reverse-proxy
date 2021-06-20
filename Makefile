.PHONY: dc-traefik dcd-traefik dc-haproxy dcd-haproxy dc-nginx dcd-nginx dc-envoy dcd-envoy tf-traefik tfd-traefik clean

export COMPOSE_ROOT := ./docker-compose
export TF_ROOT      := ./terraform

# ===============================================
# Traefik
# ===============================================
dc-traefik: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.traefik.yaml up -d
dcd-traefik: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.traefik.yaml down

tf-traefik: # terraform
	@cd ${TF_ROOT} && terraform init && terraform apply -auto-approve
tfd-traefik: # terraform
	@cd ${TF_ROOT} && terraform destroy -auto-approve

# ===============================================
# HAProxy
# ===============================================
dc-haproxy: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.haproxy.yaml up -d
dcd-haproxy: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.haproxy.yaml down

# ===============================================
# NGINX
# ===============================================
dc-nginx: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.nginx.yaml up -d
dcd-nginx: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.nginx.yaml down

# ===============================================
# Envoy
# ===============================================
dc-envoy: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.envoy.yaml up -d
dcd-envoy: # docker-compose
	@cd ${COMPOSE_ROOT} && docker-compose -f docker-compose.yaml -f docker-compose.envoy.yaml down

# ===============================================
# Cleanup
# ===============================================
clean:
	@echo Todo
