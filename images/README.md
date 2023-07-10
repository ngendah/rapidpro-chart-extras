Build and push images
-----------------------

### Pre-requisites:

1. GNU Make

2. Json Processor, [jq](https://jqlang.github.io/jq/). 

3. Docker

### Steps:

1. Build and push the images

    ```sh
        docker login -u <username> <registry host>
        make -e REGISTRY_HOST="<registry host>" -j 3
    ```
