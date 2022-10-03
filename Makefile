IMAGE=m1tk4/nimble-docker
TESTCTR=nimble

build:
	docker build --pull --rm --tag $(IMAGE) .

clean:
	-docker image rm --force $(IMAGE)
	-docker image prune --force
	-docker container prune --force

run:
	-docker stop $(CONT_NAME)
	-docker rm $(CONT_NAME)
	docker run --detach --restart always --shm-size=5G --network host \
		--tmpfs /tmp --tmpfs /run \
		--volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
		--volume $(LOCALCFG):/opt/dctv/conf \
		--name $(CONT_NAME) --hostname $(CONT_NAME) \
		$(IMAGE)

shell:
	docker exec -ti $(CONT_NAME) /bin/bash
	

push:
	docker push $(IMAGE)
