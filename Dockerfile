FROM gradle:8.3-jdk21

WORKDIR /app

# Copy your application code
COPY . .

# Build the application
RUN ./gradlew build --no-daemon

# Set the command to run your tests
CMD ["java", "-cp", "build/classes/java/test:build/libs/*:src/test/resources/", "org.testng.TestNG", "src/test/resources/testng.xml"]