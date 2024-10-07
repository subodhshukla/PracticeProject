# Use an official OpenJDK runtime as a parent image
FROM openjdk:21-slim

# Set the working directory in the container
WORKDIR /app
# Install Gradle
RUN apt-get update && apt-get install -y wget && \
    wget https://downloads.gradle-dn.com/distributions/gradle-8.3-bin.zip && \
    unzip gradle-8.3-bin.zip && \
    mv gradle-8.3 /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/bin/gradle && \
    rm gradle-8.3-bin.zip
# Copy the Gradle wrapper script and make it executable
COPY gradlew ./
COPY gradle/ gradle/
COPY build.gradle settings.gradle ./
COPY src/ src/
COPY src/test/resources/testng.xml src/test/resources/

# Ensure gradlew is executable
RUN chmod +x gradlew

# Build the application
RUN ./gradlew build --no-daemon

# Set the command to run your tests
CMD ["java", "-cp", "build/classes/java/test:build/libs/*:src/test/resources/", "org.testng.TestNG", "src/test/resources/testng.xml"]