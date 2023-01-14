FROM --platform=arm64 ubuntu:22.04

# default values for environment variables
# they can be overriden while building an image:
# example:
# docker build --build-arg workspace_directory=/usr/src/app --build-arg github_actor=BillRaymond --build-arg github_token=yourGHtoken --build-arg user_site_repsitory=BillRaymond/agile-in-action-podcast-website -t jekyll:alpine .
ARG workspace_directory=/github/workspace
ENV env_workspace_directory=$workspace_directory
ARG github_actor=""
ENV env_github_actor=${github_actor}
ARG github_token=""
ENV env_github_token=${github_token}
ARG user_site_repository=""
ENV env_user_site_repository=${user_site_repository}

RUN echo "#################################################"
RUN echo "Get the latest APT packages"
RUN echo "apt-get update"
RUN apt-get update

RUN echo "#################################################"
RUN echo "Install Jekyll pre-requisites"
RUN echo "Partially based on https://gist.github.com/jhonnymoreira/777555ea809fd2f7c2ddf71540090526"
RUN echo "apt-get -y install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev"
RUN apt-get -y install git curl autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
RUN echo "ENV RBENV_ROOT /usr/local/src/rbenv"
ENV RBENV_ROOT /usr/local/src/rbenv
RUN echo "ENV RUBY_VERSION 3.1.2"
ENV RUBY_VERSION 3.1.2
RUN echo "ENV PATH ${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH"
ENV PATH ${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH

RUN echo "#################################################"
RUN echo "Install custom prerequisites for this repo"
RUN echo "RUN apt-get install -y imagemagick"
RUN apt-get install -y imagemagick
RUN echo "RUN apt-get install -y build-base gcc cmake git python3"
RUN apt-get install -y build-base gcc cmake git python3

RUN echo "env_workspace_directory"
RUN echo ${env_workspace_directory}
RUN echo "workspace_directory"
RUN echo ${workspace_directory}


ENV JEKYLL_ENV: production
WORKDIR ${env_workspace_directory}

RUN echo "COPY . ${env_workspace_directory}"
COPY . ${env_workspace_directory}

RUN echo "ADD entrypoint.sh /"
ADD entrypoint.sh /
RUN echo "RUN chmod +x /entrypoint.sh"
RUN chmod +x /entrypoint.sh

RUN echo "ENTRYPOINT entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
