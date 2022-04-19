FROM ruby:alpine as jekyll

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

# APK reference: https://wiki.alpinelinux.org/wiki/Package_management
RUN apk update

RUN apk add --no-cache build-base gcc bash cmake git python3

RUN echo "env_workspace_directory"
RUN echo ${env_workspace_directory}
RUN echo "workspace_directory"
RUN echo ${workspace_directory}

# install both bundler 1.x and 2.x incase you're running
# old gem files
# https://bundler.io/guides/bundler_2_upgrade.html#faq
RUN echo "gem update bundler && gem install bundler jekyll"
RUN gem update bundler && gem install bundler jekyll

ENV JEKYLL_ENV: production
WORKDIR ${env_workspace_directory}

RUN echo "COPY . ${env_workspace_directory}"
COPY . ${env_workspace_directory}

RUN echo "apk add --no-cache git"
RUN apk add --no-cache git

RUN echo "ADD entrypoint.sh /"
ADD entrypoint.sh /
run echo "RUN chmod +x /entrypoint.sh"
RUN chmod +x /entrypoint.sh

RUN echo "ENTRYPOINT entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
