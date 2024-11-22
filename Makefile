DOCKER_COMPOSE=docker-compose
MONGO_PRIMARY_CONTAINER=mongo-primary

all: up init-replica-set

up:
	@echo "Levantando servicios de Docker..."
	$(DOCKER_COMPOSE) up -d

down:
	@echo "Deteniendo servicios de Docker..."
	$(DOCKER_COMPOSE) down

init-replica-set:
	@echo "Esperando que el contenedor de Mongo esté listo..."
	sleep 10
	@echo "Inicializando Replica Set..."
	docker run --rm --network replics_mongo_mongo-cluster mongo:latest mongosh "mongodb://mongo-primary:27017" --eval 'rs.initiate({"_id":"rsTournament","members":[{"_id":0,"host":"mongo-primary:27017"},{"_id":1,"host":"mongo-secondary1:27017"},{"_id":2,"host":"mongo-secondary2:27017"}]})'
	@echo "Replica Set inicializado correctamente."

check-status:
	@echo "Verificando el estado del Replica Set..."
	docker exec -it $(MONGO_PRIMARY_CONTAINER) mongosh --eval "printjson(rs.status())"

clean:
	@echo "Eliminando contenedores y volúmenes..."
	$(DOCKER_COMPOSE) down -v

reset: clean all
