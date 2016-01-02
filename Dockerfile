FROM opensuse:leap
MAINTAINER martin@gabelmann.biz

RUN zypper --gpg-auto-import-keys --non-interactive ref && \
    zypper --gpg-auto-import-keys --non-interactive up

RUN zypper --non-interactive in --auto-agree-with-licenses \
    openssh sshpass python python-paramiko python-PyYAML \
    python-Jinja2 python-httplib2 python-six git vim ca-certificates 

ENV ANSIBLE_VERSION="stable-1.9" \
    ANSIBLE_SSH=false \
    ANSIBLE_CONFIG="/etc/ansible/ansible.cfg" \
    VERBOSE=true

RUN mkdir -p /root/.ansible && \
    mkdir -p /etc/ansible && \
    echo "127.0.0.1" > /etc/ansible/hosts && \
    /usr/bin/ssh-keygen -A

#TODO: unable to get local issuer certificate
#ca=certificates is installed, whats missing here?
RUN git config --global http.sslVerify false

RUN git clone --recursive https://github.com/ansible/ansible.git /root/.ansible

ADD ansible-install /usr/bin/ansible-install

WORKDIR /root/.ansible

VOLUME ["/etc/ansible/"]
VOLUME ["/root/.ssh/"]

EXPOSE 22
EXPOSE 443
EXPOSE 80

ENTRYPOINT ["ansible-install"]
