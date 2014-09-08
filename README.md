couchbase
=========

Couchbase Dockerfile

Build

    docker build -t couchbase:3.0 git://github.com/dockerimages/couchbase 

Run

    docker run -i -t -d -e CB_REST_USER=user-e CB_REST_PASSWORD=password --name=COUCHBASE -p 11210:11210 -p 8091:7081 -p 8092:8092 dockerimages/couchbase:3.0
