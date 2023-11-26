FROM docker.io/alpine:3

# installation settings
ARG TL_MIRROR="https://texlive.info/CTAN/systems/texlive/tlnet"
ARG TL_YEAR="2023"
SHELL [ "/bin/sh", "-x", "-c" ]

RUN apk add --no-cache perl curl fontconfig libgcc gnupg ghostscript && \
    mkdir "/tmp/texlive" && cd "/tmp/texlive" && \
    wget -nv "$TL_MIRROR/install-tl-unx.tar.gz" && \
    tar xzvf ./install-tl-unx.tar.gz && \
    ( \
    echo "selected_scheme scheme-minimal" && \
    echo "instopt_adjustpath 0" && \
    echo "tlpdbopt_install_docfiles 0" && \
    echo "tlpdbopt_install_srcfiles 0" && \
    echo "TEXDIR /opt/texlive/${TL_YEAR}" && \
    echo "TEXMFLOCAL /opt/texlive/texmf-local" && \
    echo "TEXMFSYSCONFIG /opt/texlive/${TL_YEAR}/texmf-config" && \
    echo "TEXMFSYSVAR /opt/texlive/${TL_YEAR}/texmf-var" && \
    echo "TEXMFHOME ~/.texmf" \
    ) > "/tmp/texlive.profile" && \
    "./install-tl-${TL_YEAR}"*"/install-tl" --location "$TL_MIRROR" -profile "/tmp/texlive.profile" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl" && \
    rm -vf "/opt/texlive/${TL_YEAR}/install-tl.log" && \
    rm -vrf /tmp/*

ENV PATH="${PATH}:/opt/texlive/${TL_YEAR}/bin/x86_64-linuxmusl"

RUN tlmgr install scheme-medium && tlmgr paper a4

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]