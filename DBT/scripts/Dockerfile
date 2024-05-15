# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update \
    && apt-get install -y gnupg2 curl

# Add GraalVM repository and install GraalVM JDK 17
RUN curl -fsSL https://github.com/graalvm/graalvm-ce-builds/raw/master/install.sh | bash -s -- --jdk 17 --no-man
ENV PATH="/opt/graalvm-ce-java17-<version>/bin:$PATH"

# Set JAVA_HOME environment variable
ENV JAVA_HOME /opt/graalvm-ce-java17-<version>

# Install Maven
RUN apt-get install -y maven

# Set Maven to use GraalVM JDK
RUN echo "export JAVA_HOME=/opt/graalvm-ce-java17-<version>" >> /etc/profile.d/java.sh \
    && echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile.d/java.sh \
    && echo "export MAVEN_HOME=/usr/share/maven" >> /etc/profile.d/java.sh \
    && echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile.d/java.sh

# Update alternatives to point to GraalVM JDK
RUN update-alternatives --install /usr/bin/java java /opt/graalvm-ce-java17-<version>/bin/java 1 \
    && update-alternatives --set java /opt/graalvm-ce-java17-<version>/bin/java \
    && update-alternatives --install /usr/bin/javac javac /opt/graalvm-ce-java17-<version>/bin/javac 1 \
    && update-alternatives --set javac /opt/graalvm-ce-java17-<version>/bin/javac

# CMD ["mvn", "-version"] # Optionally, you can include this line to print Maven version during container startup
