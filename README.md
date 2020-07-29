# matomo

[![Build Status](https://drone.owncloud.com/api/badges/owncloud-ops/matomo/status.svg)](https://drone.owncloud.com/owncloud-ops/matomo/)
[![Docker Hub](https://img.shields.io/badge/docker-latest-blue.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/owncloudops/matomo)

Custom Docker image for [matomo](https://matomo.org/) analytics platform.

## Build

You could use the `BUILD_VERSION` to specify the target version.

```Shell
docker build --build-arg BUILD_VERSION=1.8 -f Dockerfile -t matomo:latest .
```

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](https://github.com/owncloud-ops/matomo/blob/master/LICENSE) file for details.
