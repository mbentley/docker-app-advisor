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

If you want to test an application that does a few upgrade steps, here is an example app: [github.com/mbentley/tanzu-java-web-app](https://github.com/mbentley/tanzu-java-web-app). As of the time of this writing, it will perform the following upgrade plan:

```
 - Step 1:
    * Upgrade spring-framework from 5.3.x to 6.0.x
    * Upgrade spring-boot from 2.7.x to 3.0.x
 - Step 2:
    * Upgrade spring-boot from 3.0.x to 3.1.x
 - Step 3:
    * Upgrade spring-boot from 3.1.x to 3.2.x
```

Here are some basic commands which are better outlined in the official documentation:

```bash
# set variable so the rest of the commands are copy/paste
APP_ADVISOR_SERVER="http://<IP-to-your-app-advisor-server>:8080"

# create a build config
advisor build-config get

# push the generated build config to the app advisor server
advisor build-config publish --url="${APP_ADVISOR_SERVER}"

# get the upgrade plan from the published build config
advisor upgrade-plan get --url="${APP_ADVISOR_SERVER}"

# apply the first step of the upgrade
advisor upgrade-plan apply --url="${APP_ADVISOR_SERVER}"

# repeat the above steps if you have multiple steps to complete
```
