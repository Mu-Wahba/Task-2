# used multi-stage builds to minimize application image size

#build artifact with maven tool
FROM maven:3.5-jdk-8-alpine
LABEL maintainer="Muhammad Wahba" release_date="March,28"
WORKDIR /java-app
COPY . /java-app
#COPY --from=0 /java-app/simple-java-maven-app /java-app
RUN mvn install

#execute application file
FROM openjdk:8-jre-alpine
WORKDIR /java-app
COPY --from=0 /java-app/target/my-app-1.0-SNAPSHOT.jar /java-app
CMD ["java -jar  my-app-1.0-SNAPSHOT.jar"]
ENTRYPOINT ["sh", "-c"]
