# SonarQube 6.5 on Alpine with LDAP integration

![logo](https://raw.githubusercontent.com/docker-library/docs/84479f149eb7d748d5dc057665eb96f923e60dc1/sonarqube/logo.png)

# What is SonarQube?

SonarQube is an open source platform for continuous inspection of code quality.

> [wikipedia.org/wiki/SonarQube](http://en.wikipedia.org/wiki/SonarQube)

## Pre-installed plugins

The container will start with the following plugins already installed

| Plugin      | Version      |
| ----------- | ------------ |
| Flex        | 2.3          |
| LDAP        | 2.2          |
| SonarC#     | 5.10.1       |
| SonarJS     | 3.1.1        |
| SonarJava   | 4.12.0.11033 |
| SonarPHP    | 1.8          |
| SonarPython | 1.8          |
| SCM / Git   | 1.2          |
| SCM / SVN   | 1.5          |
| SonarTS     | 1.1          |
| SonarXML    | 1.4.3        |
| Web         | 2.5.0.476    |

## Environment Variables

By default, the image will use an embedded H2 database that is not suited for
production.

The production database is configured with these variables:
SONARQUBE_JDBC_USERNAME, SONARQUBE_JDBC_PASSWORD and SONARQUBE_JDBC_URL.

| Variable             | Explanation                                                     | Example                           | Default |
| -------------------- | --------------------------------------------------------------- | --------------------------------- | ------- |
| `JDBC_USERNAME`      | Username for the internal database connection                   | myuser                            | sonar   |
| `JDBC_PASSWORD`      | Password for the internal database connection                   | mypassword                        | sonar   |
| `SONARQUBE_JDBC_URL` | The JDBC URL that was used to establish the current connection. | jdbc:postgresql://localhost/sonar | `empty` |

In order to connect to an LDAP server, you need to provide the following
environment variables

| Variable                  | Explanation                                                                  | Example                    | Default                         |
| ------------------------- | ---------------------------------------------------------------------------- | -------------------------- | ------------------------------- |
| `SONARQUBE_LDAP_ENABLE`   | If set to `true` the container will be configured to use LDAP authentication |                            | `false`                         |
| `SONARQUBE_BASE_DN`       | Base DN used for LDAP authentication                                         | dc=mycorp,dc=com           | empty                           |
| `SONARQUBE_REALM`         | LDAP domain REALM                                                            | `mycorp.com`               | `empty`                         |
| `SONARQUBE_LDAP_URL`      | LDAP URL                                                                     | `http://mycorp.com:389`    | `ldap://localhost:389`          |
| `SONARQUBE_LDAP_BINDDN`   | LDAP BindDn                                                                  | `administrator@mycorp.com` | administrator@`SONARQUBE_REALM` |
| `SONARQUBE_LDAP_PASSWORD` | LDAP Password                                                                | MyBaseDNPassword           | `empty`                         |

> Please, note that if `SONARQUBE_LDAP_ENABLE` is to `true`,both
> `SONARQUBE_LDAP_PASSWORD` and `SONARQUBE_BASE_DN` must be initialized. In case
> they are not, the container will start without any LDAP configuration

## Docker run

```console
$ docker run -d --name sonarqube \
                -p 9000:9000 -p 9092:9092 \
                -e SONARQUBE_JDBC_USERNAME=sonar \
                -e SONARQUBE_JDBC_PASSWORD=sonar \
                -e SONARQUBE_LDAP_ENABLE=true \
                -e SONARQUBE_BASE_DN=dc=foo,dc=com \
                -e SONARQUBE_REALM=foo.com \
                -e SONARQUBE_LDAP_URL=ldap://fooserver:389 \
                -e SONARQUBE_LDAP_BINDDN=administrator@foo.com \
                -e SONARQUBE_LDAP_PASSWORD=P4ssW0rd1! \
                militellovinx/sonarqube:latest
```

## Docker Compose Example

```yaml
version: '3.3'

services:
  sonar-service:
    image: militellovinx/sonarqube:latest
    restart: "unless-stopped"
    ports:
      - 9000:9000
    environment:
      - SONARQUBE_JDBC_USERNAME=sonar
      - SONARQUBE_JDBC_PASSWORD=sonar
      - SONARQUBE_LDAP_ENABLE=true
      - SONARQUBE_BASE_DN=dc=foo,dc=com
      - SONARQUBE_REALM=foo.com
      - SONARQUBE_LDAP_URL=ldap://fooserver:389
      - SONARQUBE_LDAP_BINDDN=administrator@foo.com
      - SONARQUBE_LDAP_PASSWORD=P4ssW0rd1!
```

## Useful resources

* [Official Documentation for SonarQube on Docker](https://github.com/docker-library/docs/blob/master/sonarqube/)
* [Run SonarQube with a PostgreSQL database on Docker](https://github.com/SonarSource/docker-sonarqube/blob/master/recipes.md)
* [Samba 4 AD container based on Alpine Linux 3.4 on Docker](https://hub.docker.com/r/militellovinx/samba-ad/)
