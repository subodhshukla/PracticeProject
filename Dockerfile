# Use an official OpenJDK runtime as a parent image
FROM openjdk:21-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Gradle wrapper script and make it executable
COPY gradlew ./
COPY gradle gradle/

# Ensure gradlew is executable
RUN chmod +x gradlew

# Copy Gradle build files
COPY build.gradle settings.gradle ./

# Copy your source code into the container
COPY src src/

# Copy the testng.xml configuration file from the resources folder
COPY src/test/resources/testng.xml src/test/resources/

# Run Gradle to build the application
RUN ./gradlew build --no-daemon

# Set the command to run your tests
CMD ["java", "-cp", "build/classes/java/test:build/libs/*:src/test/resources/", "org.testng.TestNG", "src/test/resources/testng.xml"]