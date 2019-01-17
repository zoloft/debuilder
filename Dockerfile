FROM buildpack-deps:jessie

RUN echo 'deb http://deb.debian.org/debian/ jessie-backports main' > /etc/apt/sources.list.d/backports.list
RUN echo 'deb http://security.debian.org/ jessie/updates main contrib non-free' > /etc/apt/sources.list.d/security.list
RUN apt-get update
RUN apt-get install -y --force-yes devscripts build-essential debhelper dh-make curl git git-buildpackage

