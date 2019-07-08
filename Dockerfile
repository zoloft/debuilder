FROM buildpack-deps:jessie

ARG DEBIAN_FRONTEND=noninteractive

RUN echo 'deb [check-valid-until=no] http://archive.debian.org/debian/ jessie-backports main' > /etc/apt/sources.list.d/backports.list
RUN echo 'deb http://deb.debian.org/debian testing non-free contrib main' >> /etc/apt/sources.list.d/testing.list
RUN echo 'Acquire::Check-Valid-Until "false";' >> /etc/apt/apt.conf
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt update
RUN apt-get install -y --force-yes apt-utils devscripts build-essential debhelper dh-make curl git git-buildpackage rsync vim quilt python-all python3-all python-stdeb
RUN apt-get upgrade -y --force-yes
RUN curl -OL http://ftp.debian.org/debian/pool/main/p/python-zeroconf/python-zeroconf_0.17.6-1_all.deb
RUN dpkg -i python-zeroconf_0.17.6-1_all.deb || true
RUN apt-get install -f -y --force-yes
ENV SHELL bash
RUN echo 'export LS_OPTIONS="--color=auto"' >> /root/.bashrc
RUN echo 'eval "`dircolors`"' >> /root/.bashrc
RUN echo 'alias ls="ls $LS_OPTIONS"' >> /root/.bashrc
RUN echo 'alias ll="ls -lah"' >> /root/.bashrc
RUN echo 'alias dquilt="quilt --quiltrc=/root/.quiltrc-dpkg"' >> /root/.bashrc
RUN echo -e '\
d=. ; while [ ! -d $d/debian -a $(readlink -e $d) != / ]; do d=$d/..; done \n\
if [ -d $d/debian ] && [ -z $QUILT_PATCHES ]; then \n\
    # if in Debian packaging tree with unset $QUILT_PATCHES \n\
    QUILT_PATCHES="debian/patches" \n\
    QUILT_PATCH_OPTS="--reject-format=unified" \n\
    QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto" \n\
    QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index" \n\
    QUILT_COLORS="diff_hdr=1;32:diff_add=1;34:diff_rem=1;31:diff_hunk=1;33:diff_ctx=35:diff_cctx=33" \n\
    if ! [ -d $d/debian/patches ]; then mkdir $d/debian/patches; fi \n\
fi\
' > /root/.quiltrc-dpkg

