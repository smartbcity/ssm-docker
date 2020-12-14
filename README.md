# SSM-DOCKER

## Package ssm in docker image

The image smartbcity/ssm is based on linux alpine and contains
```
/opt/smartbcity/ssm/chaincode/go/ssm/  --> Sources of the chaincode
/opt/smartbcity/ssm/util               --> Bash script to instanciate, invoke and query the chaincode
/opt/smartbcity/ssm/env                --> Env properties: CHAINCODE=ssm VERSION=0.8.1
/opt/smartbcity/ssm/ssm-$VERSION.pak      --> Packaged chaincode
```

`/opt/civis-blockchain/ssm/env` contains:
```
CHAINCODE=ssm
VERSION=0.8.1
```

## Build proccess

* Create tag with ssm version (ex: v0.8.1)
```
export SSM_VERSION=v0.8.1
export VERSION=2.3.0-0.8.2
git tag -a ${VERSION} -m "${VERSION} version"
git push origin ${VERSION}
```

* Package, tag as latest version and push docker images
```
make package push push-latest -e VERSION=${VERSION} -e SSM_VERSION=${SSM_VERSION}
```

## Docker image
 * Package docker image

```
make package -e VERSION=0.4.2
```

 * Push docker image

```
make push -e VERSION=0.4.2
```

 * Inspect docker image's content

```
make inspect-ssm -e VERSION=0.4.2
```
