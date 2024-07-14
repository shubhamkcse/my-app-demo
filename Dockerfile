# Stage 1: Build the application
FROM maven:3.8.5-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and download the dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn package -DskipTests

# Debug step: List the contents of the /app/target directory
RUN ls -al /app/target

# Stage 2: Create the runtime image
FROM openjdk:11-jre-slim

# Copy the JAR file from the build stage
COPY --from=build /app/target/my-app-demo-0.0.1-SNAPSHOT.jar /app/my-app-demo-0.0.1-SNAPSHOT.jar

# Set the entry point
ENTRYPOINT ["java", "-jar", "/app/my-app-demo-0.0.1-SNAPSHOT.jar"]
