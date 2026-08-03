# マルチステージビルド: Mavenでビルド後、軽量JREイメージで実行
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -q
COPY src ./src
RUN mvn package -q -DskipTests

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/task-manager.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
