FROM jupyter/minimal-notebook
MAINTAINER rowe@zatonovo.com

USER root
# Fix some apt issues
#RUN mkdir -p /var/lib/apt/lists/partial

# Add in requirements from opencpu/base
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  #apt-get -y dist-upgrade && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-2.0 && \
  apt-get update && \
  apt-get install -y opencpu-server

# Prints apache logs to stdout
RUN \
  ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
  ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_access.log && \
  ln -sf /proc/self/fd/1 /var/log/opencpu/apache_error.log

# Set opencpu password so that we can login
RUN \
  echo "opencpu:opencpu" | chpasswd

# Apache ports
EXPOSE 80
EXPOSE 443
EXPOSE 8004


# Add in zatonovo toolchain
RUN apt-get install -y git
RUN git clone https://github.com/muxspace/crant.git /app/crant
ENV PATH="$PATH:/app/crant"
RUN rpackage futile.logger futile.matrix
RUN rpackage formatR
RUN rpackage https://github.com/zatonovo/lambda.r.git
RUN rpackage https://github.com/zatonovo/lambda.tools.git

# For R jupyter notebook
RUN rpackage repr IRdisplay pbdZMQ uuid
RUN rpackage https://github.com/IRkernel/IRkernel.git
RUN Rscript -e "IRkernel::installspec()"

RUN mkdir /app/cache

# Start non-daemonized webserver
CMD apachectl -DFOREGROUND
