# Deployment

A [Docker image](https://hub.docker.com/repository/docker/collectionspace/cspace-converter) is available for the Converter Tool. A deployable compose file would look like:

```yml
version: '3.7'
services:
  converter:
    image: lyrasis/cspace-converter
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    depends_on:
      - mongo
    environment:
      CSPACE_CONVERTER_ASYNC_JOBS: 'true'
      CSPACE_CONVERTER_DB_HOST: mongo
      CSPACE_CONVERTER_DB_NAME: nightly_core
      CSPACE_CONVERTER_BASE_URI: https://core.dev.collectionspace.org/cspace-services
      CSPACE_CONVERTER_DOMAIN: core.collectionspace.org
      CSPACE_CONVERTER_LOG_LEVEL: debug
      CSPACE_CONVERTER_MODULE: Core
      CSPACE_CONVERTER_USERNAME: admin@core.collectionspace.org
      CSPACE_CONVERTER_PASSWORD: Administrator
  mongo:
    image: mongo:3.2
```

Fire it up:

```bash
docker-compose up
```

## Deploying the Converter to Amazon Elastic Beanstalk

The converter can be easily deployed to [Amazon Elastic Beanstalk](https://aws.amazon.com/documentation/elastic-beanstalk/)
(account required).

```bash
# from the project root directory
cp Dockerrun.aws-example.json Dockerrun.aws.json
```

Replace the `INSERT_YOUR_VALUE_HERE` values as needed. Note: for a production
environment the `username` and `password` should be for a temporary account used
only to perform the migration tasks. Delete this user from CollectionSpace when
the migration has been completed.

Follow the AWS documentation for deployment details:

- [Getting started](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/GettingStarted.html)

Summary:

- Create a new application and give it a name
- Choose Web application
- Choose Multi-container docker, single instance
- Upload your custom Dockerrun-aws.json (under application version)
- Choose a domain name (can be customized further later)
- Skip RDS and VPC (the mongo db is isolated to a docker local network)
- Select `t2.small` for instance type (everything else optional)
- Launch
