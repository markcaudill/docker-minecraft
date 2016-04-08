FROM fedora:latest

RUN dnf -y update

# Install Oracle JRE
ENV JRE_VERSION=8u77 JRE_BUILD=b03
RUN cd /tmp && \
    curl -LsO -b "oraclelicense=a" "http://download.oracle.com/otn-pub/java/jdk/${JRE_VERSION}-${JRE_BUILD}/jre-${JRE_VERSION}-linux-x64.rpm" && \
    dnf -y install /tmp/jre-${JRE_VERSION}-linux-x64.rpm && \
    rm -f /tmp/jre-${JRE_VERSION}-linux-x64.rpm && \
    ln -sf /usr/java/latest/bin/java /usr/bin/java

# Download Minecraft
ENV MINECRAFT_DIR=/opt/minecraft
ENV MINECRAFT_VERSION=1.9.2
RUN mkdir ${MINECRAFT_DIR} && cd ${MINECRAFT_DIR} && \
    curl -sO https://s3.amazonaws.com/Minecraft.Download/versions/${MINECRAFT_VERSION}/minecraft_server.${MINECRAFT_VERSION}.jar && \
    ln -sf minecraft_server.${MINECRAFT_VERSION}.jar minecraft_server.jar && \
    echo 'eula=true' > eula.txt

EXPOSE 25565
ENV MAX_MEM=8G MIN_MEM=1G
CMD cd ${MINECRAFT_DIR} && java -jar -Xmx${MAX_MEM} -Xms${MIN_MEM} ${MINECRAFT_DIR}/minecraft_server.jar nogui
