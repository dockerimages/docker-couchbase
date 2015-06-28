FROM ubuntu:14.10
MAINTAINER DIREKTSPEED LTD <frank@dspeed.eu> (irc://SP33D@freenode.org#docker)
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

ENV CB_REST_USERNAME access
ENV CB_VERSION 3.0.1
ENV CB_BASE_URL http://packages.couchbase.com/releases
ENV CB_PACKAGE couchbase-server-community_${CB_VERSION}-ubuntu12.04_amd64.deb
ENV CB_DOWNLOAD_URL ${CB_BASE_URL}/${CB_VERSION}/${CB_PACKAGE}
ENV CB_LOCAL_PATH /tmp/${CB_PACKAGE}

RUN echo "# Adding Apt Magic" \
 && echo 'APT::Install-Recommends "0"; \n\
APT::Get::Assume-Yes "true"; \n\
APT::Get::force-yes "true"; \n\
APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01buildconfig \
 && echo "deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse \n\
deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse" > /etc/apt/sources.list \
 && echo "# Limits" \
 && sed -i.bak '/\# End of file/ i\\# Following 4 lines added by couchbase-server' /etc/security/limits.conf \
 && sed -i.bak '/\# End of file/ i\\* hard memlock unlimited' /etc/security/limits.conf \
 && sed -i.bak '/\# End of file/ i\\* soft memlock unlimited\n' /etc/security/limits.conf \
 && sed -i.bak '/\# End of file/ i\\* hard nofile 65536' /etc/security/limits.conf \
 && sed -i.bak '/\# End of file/ i\\* soft nofile 65536\n' /etc/security/limits.conf \
 && sed -i.bak '/\# end of pam-auth-update config/ i\\# Following line was added by docker-couchbase-server' /etc/pam.d/common-session \
 && sed -i.bak '/\# end of pam-auth-update config/ i\session required pam_limits.so\n' /etc/pam.d/common-session \
 && apt-get update \
 && apt-get install -y librtmp0 python-httplib2

# Download Couchbase Server package to /tmp & install
ADD $CB_DOWNLOAD_URL $CB_LOCAL_PATH
RUN dpkg -i $CB_LOCAL_PATH
RUN rm $CB_LOCAL_PATH
RUN /etc/init.d/couchbase-server stop
RUN rm -r /opt/couchbase/var/lib
 
ADD http://cbfs-ext.hq.couchbase.com/dustin/software/confsed/confsed.lin64.gz /usr/local/sbin/confsed.gz
RUN gzip -d /usr/local/sbin/confsed.gz
RUN chmod 755 /usr/local/sbin/confsed
 
ADD http://cbfs-ext.hq.couchbase.com/dustin/software/docker/cb/couchbase-script /usr/local/sbin/couchbase
RUN chmod 755 /usr/local/sbin/couchbase
# Couchbase Server ports 
# note: 7081 is 8091 with rewrites (confused)
EXPOSE 4369 7081 8091 8092 11209 11210 11211
VOLUME /home/couchbase-server:/opt/couchbase/var

CMD ["/usr/local/sbin/couchbase"]
