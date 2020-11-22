FROM debian:stable-slim

RUN apt update \
    && apt upgrade \
    && apt -y install build-essential 

RUN mkdir /out
RUN mkdir /src

VOLUME [ "/out", "/src" ]

ADD compile.sh /compile.sh

RUN chmod u+x /compile.sh

CMD ["/compile.sh"]
