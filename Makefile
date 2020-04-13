include .make-env

package:
	@docker build --build-arg VERSION=${VERSION} -f Dockerfile -t ${IMG} .

push:
	@docker push ${IMG}

push-latest:
	@docker tag ${IMG} ${LATEST}
	@docker push ${LATEST}

inspect-ssm:
	@docker run -it ${IMG} sh
