docker-fpm70
============

This repository contains a Dockerfile of PHP 7+ FPM for Docker's automated build published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

### Installation

1. Install [Docker](https://www.docker.com/).

2. Download the [automated build](https://registry.hub.docker.com/u/uqlibrary/docker-fpm56/) from the public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull uqlibrary/docker-fpm70`

   (or, you can build an image from Dockerfile: `docker build -t uqlibrary/docker-fpm70 .)

### Usage

1. Start the container:

    ```sh
    docker run uqlibrary/docker-fpm70
    ```
