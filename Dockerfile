FROM ubuntu:14.10
MAINTAINER Frank Lemanschik
# Limits
RUN sed -i.bak '/\# End of file/ i\\# Following 4 lines added by couchbase-server' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\* hard memlock unlimited' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\* soft memlock unlimited\n' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\* hard nofile 65536' /etc/security/limits.conf
RUN sed -i.bak '/\# End of file/ i\\* soft nofile 65536\n' /etc/security/limits.conf
RUN sed -i.bak '/\# end of pam-auth-update config/ i\\# Following line was added by docker-couchbase-server' /etc/pam.d/common-session
RUN sed -i.bak '/\# end of pam-auth-update config/ i\session required pam_limits.so\n' /etc/pam.d/common-session

RUN apt-get update
RUN apt-get install -y librtmp0 python-httplib2
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
 
CMD /usr/local/sbin/couchbase
