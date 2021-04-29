FROM zatonovo/r-base
RUN cd /app/crant && git pull origin master

COPY . /app/PACKAGE
WORKDIR /app/PACKAGE
RUN crant -SCi
