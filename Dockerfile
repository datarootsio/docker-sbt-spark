FROM openjdk:8

ARG spark_version="3.0.0"
ARG hadoop_version="3.2"

RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 \
    && apt-get update && apt-get install -y \
    git \
    sbt \
    scala \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sfLo cs https://git.io/coursier-cli-linux \
    && chmod +x cs \
    && mv cs /usr/local/bin

ENV PATH="${HOME}/.local/share/coursier/bin:${PATH}"

RUN curl -fsLo spark-${spark_version}-bin-hadoop${hadoop_version}.tgz https://apache.belnet.be/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz \
    && tar -xvf spark-${spark_version}-bin-hadoop${hadoop_version}.tgz \
    && mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/local/spark \
    && ln -s /usr/local/spark-${spark_version}-bin-hadoop${hadoop_version}/ /usr/local/spark

ENV SPARK_HOME="/usr/local/spark"
ENV PATH="${PATH}:${SPARK_HOME}/bin:${SPARK_HOME}/sbin"