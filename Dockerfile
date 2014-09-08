FROM ubuntu:14.10
# Frank Base
MAINTAINER Direkt SPEED Europe <frank@dspeed.eu> (irc://SP33D@freenode.org#docker)
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
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
ADD http://packages.couchbase.com/releases/3.0.0-beta2/couchbase-server_3.0.0-beta2_x86_64_ubuntu_1204.deb /tmp/couchbase-server_3.0.0-beta2_x86_64_ubuntu_1204.deb
RUN dpkg -i /tmp/couchbase-server_3.0.0-beta2_x86_64_ubuntu_1204.deb
RUN rm /tmp/couchbase-server_3.0.0-beta2_x86_64_ubuntu_1204.deb
RUN /etc/init.d/couchbase-server stop
RUN rm -r /opt/couchbase/var/lib
 
ADD http://cbfs-ext.hq.couchbase.com/dustin/software/confsed/confsed.lin64.gz /usr/local/sbin/confsed.gz
RUN gzip -d /usr/local/sbin/confsed.gz
RUN chmod 755 /usr/local/sbin/confsed
 
ADD http://cbfs-ext.hq.couchbase.com/dustin/software/docker/cb/couchbase-script /usr/local/sbin/couchbase
RUN chmod 755 /usr/local/sbin/couchbase
 
# 7081 is 8091 with rewrites
EXPOSE 7081 8092 11210
 
CMD ["/usr/local/sbin/couchbase""]
