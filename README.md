# vimis_test
материал по задаче ITOSAVIMIS-1040

кластер разворачивается на трех виртуальных машинах с IP 10.15.25.53, 10.15.25.54. 10.15.25.55

(ssh: user/user)

10.15.25.53 используется как manager , соответственно 10.15.25.54 и 10.15.25.55 как worker

на 10.15.25.53 развёрнут nfs сервер, директория /mnt/docker/nfs хранит расшаренные конфиги 

1. Поднять кластер docker swarm (количество ВМ на ваше усмотрение);
   
создать новый swarm командой :

    docker swarm init --advertise-addr 10.15.25.53

выполнить следующую команду чтобы получить команду join

    docker swarm join-token worker

полученую строку ввксти на нодах 1 и 2 
  пример строки

    docker swarm join --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c 10.15.25.53:2377

Для просмотра состояния swarm выполнить команду

    docker info 

Для просмотра информации об узлах выполнить команду  
    
    docker node ls  


2. Описание сериса nginx,

Создать файл index.html

    <html lang="en">
      <head><title>Hello Docker</title></head>
        <body>
          <p>Hello User! I'm test service docker_swarm.</p>
        </body>
      </html>

создать файл docker-test.yml

    version: "3"
    services:
      nginx:
        image: nginx:alpine
        ports:
          - 3000:80
        volumes:
          - test-nfs:/usr/share/nginx/html/
        deploy:
          replicas: 3
    volumes:
      nginx:
        driver: local
      test-nfs:
        driver_opts:
          type: "nfs"
          o: "addr=10.15.25.53,nolock,soft,rw"
          device: ":/mnt/docker/nfs"

запустить стек командой  
  
      docker stack deploy -c docker-test.yml test --detach=false



3   проверка работы сервиса
использовать bash скрипты  nginx-chek.sh

    #!/bin/bash
    for run in {1..13}; do
    UP=$(curl -I http://10.15.25.55/ -s |grep HTTP |grep 200 |wc -l);
      if [ "$UP" -ne 1 ];
    then
      echo "Webserver Is DOWN";
    else
      echo "Webserver Is UP";
    fi
    sleep 5s
    done
    
и nginx-chek-all.sh

    #!/bin/bash
    for run in {1..13}; do
    UP=$(docker ps |grep healthy |wc -l);
      if [ "$UP" -ne 1 ];
    then
      echo "Nginx Service Is DOWN";
    else
      echo "Nginx Service Is UP";
    fi

