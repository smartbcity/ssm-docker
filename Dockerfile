ARG BUILD_DIR=/go/src/github.com/hyperledger/fabric/peer
ARG SSM_VERSION
ARG VERSION

FROM alpine:3.11.5 as FETCHER

WORKDIR /git

ARG SSM_VERSION
ARG VERSION

RUN apk update && \
	apk upgrade && \
	apk --no-cache add tar wget unzip


#RUN wget --no-check-certificate -O clone.zip https://github.com/civis-blockchain/blockchain-ssm/archive/$SSM_VERSION.zip
RUN wget --no-check-certificate -O clone.zip https://github.com/civis-blockchain/blockchain-ssm/archive/fabric-v2-images.zip
RUN unzip clone.zip
RUN mv blockchain-ssm-* blockchain-ssm

FROM hyperledger/fabric-tools:2.3.0 as BUILDER

ARG VERSION

WORKDIR /go/src/blockchain-ssm

COPY --from=FETCHER /git/blockchain-ssm/chaincode /go/src/blockchain-ssm/chaincode
RUN go mod init
RUN go get github.com/golang/protobuf/proto
RUN go get google.golang.org/grpc
RUN go get github.com/hyperledger/fabric-protos-go
RUN go mod vendor
RUN peer chaincode package -n ssm -p blockchain-ssm/chaincode/go/ssm -v $VERSION ssm-$VERSION.pak

FROM alpine:latest

ARG VERSION

WORKDIR /opt/smartbcity/ssm

RUN echo CHAINCODE=ssm >> env
RUN echo VERSION=$VERSION >> env
COPY --from=FETCHER /git/blockchain-ssm/sdk/cli/util ./util
COPY --from=FETCHER /git/blockchain-ssm/chaincode ./chaincode

COPY --from=BUILDER /go/src/blockchain-ssm/ssm-$VERSION.pak ./

