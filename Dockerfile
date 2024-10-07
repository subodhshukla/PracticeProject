FROM openjdk:21-slim

WORKDIR /app

# Install wget and unzip
RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Download and install Gradle 8.3 from the new URL
RUN wget https://services.gradle.org/distributions/gradle-8.3-bin.zip && \
    unzip gradle-8.3-bin.zip -d /opt/ && \
    mv /opt/gradle-8.3 /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/bin/gradle && \
    rm gradle-8.3-bin.zip

# Copy your application code
COPY . .
# Make the Gradle wrapper executable
RUN chmod +x gradlew
# Build the application
RUN ./gradlew build --no-daemon

# Set the command to run your tests
CMD ["java", "-cp", "build/classes/java/test:build/libs/*:src/test/resources/", "org.testng.TestNG", "src/test/resources/testng.xml"]