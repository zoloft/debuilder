FROM buildpack-deps:jessie

ARG DEBIAN_FRONTEND=noninteractive

RUN echo 'deb [check-valid-until=no] http://archive.debian.org/debian/ jessie-backports main' > /etc/apt/sources.list.d/backports.list
RUN echo 'deb http://deb.debian.org/debian testing non-free contrib main' >> /etc/apt/sources.list.d/testing.list
RUN echo 'Acquire::Check-Valid-Until "false";' >> /etc/apt/apt.conf
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes devscripts build-essential debhelper dh-make curl git git-buildpackage rsync
RUN apt-get upgrade -y --force-yes
RUN curl -OL http://ftp.debian.org/debian/pool/main/p/python-zeroconf/python-zeroconf_0.17.6-1_all.deb
RUN dpkg -i python-zeroconf_0.17.6-1_all.deb || true
RUN apt-get install -f -y --force-yes

