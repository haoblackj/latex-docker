# syntax=docker/dockerfile:1

FROM nikolaik/python-nodejs:python3.11-nodejs18-alpine

ARG TEXLIVE_VERSION=2023

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="/usr/local/texlive/bin:$PATH"

RUN apt-get update && \
    apt update && \
    apt-get install -y --no-install-recommends \
        curl \
        make \
        wget \
        libfontconfig1-dev \
        libfreetype6-dev \
        ghostscript \
        perl && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir pygments && \
    mkdir /tmp/install-tl-unx && \
    wget -O - http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz \
        | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
        > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
        --profile /tmp/install-tl-unx/texlive.profile \
        -repository  http://mirror.ctan.org/systems/texlive/tlnet/ && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linux /usr/local/texlive/bin && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN tlmgr --repository http://mirror.ctan.org/systems/texlive/tlnet/ update --self && \
    tlmgr --repository http://mirror.ctan.org/systems/texlive/tlnet/ install \
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
