# Apache httpd в контейнере

Проект предназначен для запуска в docker-контейнере сервиса `Apache httpd` на заданном порту с поддержкой SSL сертфикатов.

 - Образ для контейнера собирается на базе библиотечного контейнера Apache `https://hub.docker.com/r/library/httpd/`
 - Сборка и запуск параметризованы с помощью `.env` файла
 - Команды собраны в `Makefile`
 - Пример деплоймента в `Kubernetes`

Пример собранного образа размещен в репозитории https://hub.docker.com/r/spinor72/httpd/

## Как запустить проект
Для запуска проекта должны быть установлены утилиты `make`, `docker`, `docker-compose`, `envsubst`, `kubectl`. Для развертывания в Kubernetes должен быть соответствущим образом настроен `kubectl` (например, для локального теста установить утилиту `minikube` и запустить  командой `minikube start`)

- Переименовать `.env.example` в `.env` и  задать свои значения переменных
- сгенерировать сертификаты командой `make cert` или прописать свои файлы в `.env`
- собрать образ `make build`
- запустить с помощью команды `make up`
- разместить образ в репозиториии  `make push`, предварительно нужно залогиниться `docker login`
- для переопределения сертификатов и содержимого сайта переименовать `docker-compose.override.example` в  `docker-compose.override` и задать, если требуется, свои пути и файлы в опци `volumes`
- для запуска в Kubernetes использовать команду `make k8s_deploy_httpd`

## Как првоерить
- для проверки открыть страничку вида `https://127.0.0.1:<HTTPD_PORT>` , должно появиться предупреждение о сертификате. Если подтвердить работу с самоподписанным сертификатом, откроется вэб-страничка
- если запустить docker-compose с `override`-файлом, то убедиться, что будут использованы другие сертификаты и стартовая страничка
- при запуске в Kubernetes узнать порт сервиса и адрес командой `kubectl get service httpd` и открыть соответствующую вэб-страничку
