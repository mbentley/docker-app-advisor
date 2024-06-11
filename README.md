# Spring Application Advisor

## Building the Application Advisor Image

To get your token, follow the instructions in the [Guide for Artifact Repository Administrators](https://docs.vmware.com/en/Tanzu-Spring-Runtime/Commercial/Tanzu-Spring-Runtime/guide-artifact-repository-administrators.html#accessing-spring-enterprise-subscription-artifact-repositories) documentation.

```bash
docker build -t mbentley/app-advisor --build-arg ARTIFACTORY_TOKEN="<token-here>" .
```

## Running Application Advisor

```bash
docker run -d -p 8080:8080 --name app-advisor mbentley/app-advisor
```

## Using Application Advisor

I would suggest checking out the [Running Apring Application Advisor](https://docs.vmware.com/en/Tanzu-Spring-Runtime/Commercial/Tanzu-Spring-Runtime/app-advisor-run-app-advisor-cli.html) documentation in full as you also need to install the `advisor` command. The [Dockerfile](./Dockerfile) also has some commented out commands to get you started - you could run the `advisor` client in the container but that's not the intended usage.

Here are some very basic commands:

```bash
advisor build-config get
advisor build-config publish --url=http://<ip-to-app-advisor>:8080
advisor upgrade-plan get --url=http://<ip-to-app-advisor>:8080
advisor upgrade-plan apply --url=http://<ip-to-app-advisor>:8080
```
