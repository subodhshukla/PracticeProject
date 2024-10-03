# Step 1: Use a base image for building the app
FROM openjdk:21-jdk-slim AS builder

# Step 2: Install Gradle
RUN apt-get update && apt-get install -y wget unzip && \
    wget https://services.gradle.org/distributions/gradle-8.3-bin.zip && \
    unzip gradle-8.3-bin.zip -d /opt && \
    ln -s /opt/gradle-8.3/bin/gradle /usr/bin/gradle && \
    rm gradle-8.3-bin.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Step 3: Set the working directory
WORKDIR /app

# Step 4: Copy the Gradle build files
COPY build.gradle settings.gradle ./

# Step 5: Copy the source code, including testng.xml
COPY src ./src

# Step 6: Build the application
RUN gradle build --no-daemon

# Step 7: Use a smaller base image to run the tests
FROM openjdk:21-slim
WORKDIR /app

# Step 8: Copy the built application from the builder
COPY --from=builder /app/build/libs/*.jar ./app.jar

# Step 9: Specify the command to run the TestNG tests
CMD ["java", "-cp", "app.jar:src/test/resources/*:libs/*", "org.testng.TestNG", "src/test/testng.xml"]