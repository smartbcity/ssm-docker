ARG BUILD_DIR=/opt/gopath/src/github.com/hyperledger/fabric/peer
ARG VERSION

FROM alpine:3.11.5 as FETCHER

WORKDIR /git

ARG VERSION

RUN apk update && \
	apk upgrade && \
	apk --no-cache add tar wget unzip


RUN wget --no-check-certificate -O clone.zip https://github.com/civis-blockchain/blockchain-ssm/archive/$VERSION.zip
RUN unzip clone.zip
RUN mv blockchain-ssm-* blockchain-ssm

FROM hyperledger/fabric-tools:2.3.0 as BUILDER

ARG VERSION
ARG BUILD_DIR

WORKDIR $BUILD_DIR

COPY --from=FETCHER /git/blockchain-ssm/chaincode /opt/gopath/src/blockchain-ssm/chaincode
RUN peer chaincode package -n ssm -p blockchain-ssm/chaincode/go/ssm -v $VERSION ssm-$VERSION.pak

FROM alpine:latest

ARG VERSION
ARG BUILD_DIR

WORKDIR /opt/smartbcity/ssm

RUN echo CHAINCODE=ssm >> env
RUN echo VERSION=$VERSION >> env
COPY --from=FETCHER /git/blockchain-ssm/sdk/cli/util ./util
COPY --from=FETCHER /git/blockchain-ssm/chaincode ./chaincode

COPY --from=BUILDER $BUILD_DIR/ssm-$VERSION.pak ./
