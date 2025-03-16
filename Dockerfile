# Stage 1: Build the Spring Boot application
FROM openjdk:21-jdk-slim AS build
WORKDIR /app
COPY gradlew .
COPY gradle/ gradle/
COPY build.gradle .
COPY settings.gradle .
COPY src/ src/
RUN chmod +x ./gradlew
RUN ./gradlew build -x test --stacktrace --info || echo "Gradle build failed with exit code $?"  # Detailed logs with stacktrace
RUN ls -la /app/build/libs/ || echo "build/libs/ directory not found or empty"  # List JARs

# Stage 2: Create the runtime image
FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=build /app/build/libs/contactapi-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]