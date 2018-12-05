# подключаем переменные среды от композера
include ./.env
export $(shell sed 's/=.*//' ./.env)

# проверка наличия переменной с именем пользователя
ifeq ($(USER_NAME),)
  $(error USER_NAME is not set)
endif

# генерация сертификатов
certs:
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
	-subj "/C=RU/ST=Moscow/L=Moscow/O=Test/CN=httpd.local" \
	-keyout server.key  -out server.crt
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
	-subj "/C=RU/ST=Moscow/L=Moscow/O=Test/CN=httpd.local" \
	-keyout server2.key  -out server2.crt

# сборка образов
.PHONY: build build_httpd
build: build_httpd
build_httpd:
	docker build -t $(USER_NAME)/httpd:$(HTTPD_VERSION) .


# заливка образов в репозиторий, требуется предварителньо залогиниться
.PHONY: check_login push push_httpd
push: check_login push_httpd
check_login:
	if grep -q 'auths": {}' ~/.docker/config.json ; then echo "Please login to Docker HUB first" && exit 1; fi
push_httpd: check_login
	docker push $(USER_NAME)/httpd:$(HTTPD_VERSION)

# запуск и остановка
.PHONY: up down stop restart reload
up:
	docker-compose up -d
down:
	docker-compose down
stop:
	docker-compose stop
log:
	docker-compose logs --follow
restart: down up
reload: stop up


.PHONY: test_env clean clean_all
test_env:
	env | sort

# очистка системы
clean:
	docker system prune --all

clean_all:
	docker system prune --all --volumes

# Kubernetes deployment
k8s_deploy_httpd:
	cd k8s && envsubst < httpd-deployment.yml | kubectl apply -f -
	cd k8s && envsubst < httpd-service.yml | kubectl apply -f -
