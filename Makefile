#!/usr/bin/make -f

IMAGE := mileschou/lapis
.PHONY: alpine debian

# ------------------------------------------------------------------------------

all: alpine debian

alpine:
	docker build -t=$(IMAGE):alpine -f alpine/Dockerfile .

debian:
	docker build -t=$(IMAGE):latest -f Dockerfile .
