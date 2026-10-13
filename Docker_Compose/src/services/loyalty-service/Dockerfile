FROM eclipse-temurin:8-jdk AS builder

ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres

WORKDIR /app

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .

RUN chmod +x mvnw && ./mvnw dependency:go-offline -B
COPY src ./src

RUN ./mvnw package -DskipTests


FROM eclipse-temurin:8-jre

WORKDIR /app

COPY wait-for-it.sh .
RUN chmod +x wait-for-it.sh

COPY --from=builder /app/target/*.jar app.jar

ENTRYPOINT ["./wait-for-it.sh", "postgres:5432", "--", "java", "-jar", "app.jar"]

