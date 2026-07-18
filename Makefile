SHELL := /bin/bash

.PHONY: verify

verify:
	@bash ./scripts/verify-isolation.sh staging
