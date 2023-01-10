FROM jupyter/minimal-notebook
MAINTAINER AUTHOR

USER root
# Fix some apt issues
#RUN mkdir -p /var/lib/apt/lists/partial

# Add in requirements from opencpu/base
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update && \
  #apt-get -y dist-upgrade && \
  apt-get install -qy software-properties-common && \
  add-apt-repository -y ppa:opencpu/opencpu-2.2 && \
  apt-get update && \
  apt-get install -qy opencpu-server x11-apps

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

RUN rpackage futile.logger
RUN rpackage testit roxygen2 devtools reticulate formatR
RUN rpackage https://github.com/zatonovo/lambda.r.git
RUN rpackage https://github.com/zatonovo/lambda.tools.git

# For R jupyter notebook
RUN rpackage repr IRdisplay pbdZMQ uuid \
  https://github.com/IRkernel/IRkernel.git
RUN Rscript -e "IRkernel::installspec()"
RUN pip install numpy pandas scikit-learn

RUN mkdir /app/cache

COPY . /app/PACKAGE
WORKDIR /app/PACKAGE
RUN crant -SCi
