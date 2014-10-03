couchbase 3
=========

Couchbase Dockerfile

Build

    docker build -t couchbase:3.0 git://github.com/dockerimages/couchbase 

Run local

    docker run -i -t -d \
        -e CB_REST_USER=user \
        -e CB_REST_PASSWORD=password \
        -v /home/core/data/couchbase:/opt/couchbase/var
        -name=COUCHBASE dockerimages/couchbase:3.0


Run external

    int=`ip route | awk '/^default/ { print $5 }'`
    addr=`ip route | egrep "^[0-9].*$int" | awk '{ print $9 }'`


    docker run -i -t -d \
        -e CB_REST_USER=user \
        -e CB_REST_PASSWORD=password \
        -e DOCKER_EXT_ADDR=yourip \
        -name=COUCHBASE \
        -v /home/user/data/couchbase:/opt/couchbase/var
        -p 11210:11210 -p 8091:7081 -p 8092:8092 \
        dockerimages/couchbase:3.0
        
Init Cluster via ambassadors or local cotnainers.

    docker run -i -t -d \
        --link COUCHBASE:alpha
        -e CB_REST_USER=user \
        -e CB_REST_PASSWORD=password \
        -name=CB2 dockerimages/couchbase:3.0
        

# note ambassadors 

    docker run -d \
    --expose 11210 \
    -e CB_PORT_11210_TCP=tcp://192.168.1.52:11210 svendowideit/ambassador
    --link COUCHBASE:alpha
    -name=cb2_ambassador dockerimages/couchbase:3.0
