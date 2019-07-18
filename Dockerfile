FROM os_ubuntu18:latest


WORKDIR ./

COPY *.sh scripts/

RUN chmod 755 scripts/*.sh \
    && scripts/provision.sh
