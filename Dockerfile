FROM docker.io/library/python:3.11

RUN set -x && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get autoremove

ARG USER=runner
ARG UID=1001
ARG HOME=/home/$USER

RUN set -x && \
    useradd --create-home --uid $UID --gid 0 $USER

WORKDIR $HOME/ansible

RUN chown -R ${USER}:0 $HOME

USER $USER

ENV PATH $HOME/.local/bin:$PATH

RUN set -x && \
    python3 -m pip install --no-cache-dir --user --upgrade pip && \
    python3 -m pip install --no-cache-dir --user --upgrade ansible && \
    python3 -m pip install --no-cache-dir --user --upgrade netaddr

COPY --chown=${USER}:0 assets/ ./assets/
COPY --chown=${USER}:0 generic/ ./generic/
COPY --chown=${USER}:0 inventory.yaml playbook.yaml .

LABEL ansible-automation.description="resources and ansible playbook to initialize matchbox data volume"
LABEL ansible-automation.maintainer="Glenn Marcy <homelab-admin@gmarcy.com>"

VOLUME /var/lib/matchbox

ENTRYPOINT ["ansible-playbook", "-i", "inventory.yaml", "playbook.yaml"]
