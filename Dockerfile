# Build Stage
FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app

# Install Maven
RUN apk add --no-cache maven

# Copy project files
COPY pom.xml .
COPY src ./src

# Build application with verbose output
RUN mvn clean package -DskipTests -X

# List the target directory to verify jar creation
RUN ls -la /app/target/

# Runtime Stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy the executable jar from build stage
COPY --from=build /app/target/inventory.jar app.jar

# Verify the jar file
RUN jar -tf app.jar | grep -i manifest || echo "No manifest found"

# Expose port
EXPOSE 8080

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]
