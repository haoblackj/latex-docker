# syntax=docker/dockerfile:1

FROM node:18

MAINTAINER haoblackj

ARG TEXLIVE_VERSION=2022

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="/usr/local/texlive/bin:$PATH"

RUN --mount=type=cache,target=/var/cache/apt \
  --mount=type=cache,target=/var/lib/apt \
  apt-get update && \
  apt-get install -y --no-install-recommends \
        libfontconfig1-dev \
        libfreetype6-dev \
        ghostscript \
        build-essential \
        python3-pip \
        python3-dev


RUN pip3 install --no-cache-dir pygments && \
    mkdir /tmp/install-tl-unx && \
    wget -O - ftp://tug.org/historic/systems/texlive/${TEXLIVE_VERSION}/install-tl-unx.tar.gz \
        | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
        > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
        --profile /tmp/install-tl-unx/texlive.profile \
        -repository  ftp://tug.org/texlive/historic/${TEXLIVE_VERSION}/tlnet-final/ && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linux /usr/local/texlive/bin && \
    apt-get remove -y --purge \
        build-essential \
        python3

RUN tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet
RUN tlmgr update --self && \
    tlmgr install \
        collection-bibtexextra \
        collection-fontsrecommended \
        collection-langenglish \
        collection-langjapanese \
        collection-latexextra \
        collection-latexrecommended \
        collection-luatex \
        collection-mathscience \
        collection-plaingeneric \
        collection-xetex \
        latexmk \
        latexdiff

WORKDIR /workdir

COPY .latexmkrc /
COPY .latexmkrc /root/

