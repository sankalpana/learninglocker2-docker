# Learning Locker version 2 Docker image

This is a dirty and quick dockerized version of Learning Locker 2 used for testing purpose ([A better version of another Learning Locker docker image here](https://github.com/michzimny/learninglocker2-docker))

Is based on the installation guides at http://docs.learninglocker.net/guides-custom-installation/

Official images of Mongo and Redis are used, no nginx is used.

## Usage

To build the images:

```
docker-compose build
```

To run the services:

```
docker-compose up
```

To create a new user and organisation for the site:

```
docker-compose exec learninglocker bash -c "cd /src/learninglocker && node cli/dist/server createSiteAdmin [email] [organisation] [password]"
```
