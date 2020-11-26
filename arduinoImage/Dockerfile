FROM debian:stable-slim

ADD https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh /install.sh

RUN apt update \
    && apt upgrade \
    && apt install -y -q --no-install-recommends ca-certificates curl \
    && chmod u+x /install.sh \
    && /install.sh 

RUN arduino-cli config init \
    && arduino-cli core update-index \
    && arduino-cli core install arduino:avr

