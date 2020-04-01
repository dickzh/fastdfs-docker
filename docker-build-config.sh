 #!/bin/bash
 #rm -rf deps/config.tar.gz
 #tar cvzf deps/config.tar.gz conf/* images/* script/*
 docker build -t  dickzh/fastdfs-resty-alpine:1.0.0  . -f ./Dockerfile