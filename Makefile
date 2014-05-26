test: bootstrap
	./test-runner.sh

bootstrap: test-runner.sh test/assert.sh

clean: remove-test-runner.sh remove-assert.sh

test/assert.sh:
	test -f "test/assert.sh" || \
		echo "fetching assert.sh..." && \
		curl -s -L -o test/assert.sh \
			https://raw.github.com/lehmannro/assert.sh/v1.0.2/assert.sh

update-assert.sh: remove-assert.sh test/assert.sh

remove-assert.sh:
	( \
		test -f "test/assert.sh" && rm "test/assert.sh" && \
		echo "removed test/assert.sh"\
	) || exit 0

test-runner.sh:
	test -f "test-runner.sh" || \
		echo "fetching test-runner.sh..." && \
		curl -s -L -o test-runner.sh \
			https://github.com/jimeh/test-runner.sh/raw/v0.1.0/test-runner.sh && \
		chmod +x test-runner.sh

remove-test-runner.sh:
	( \
		test -f "test-runner.sh" && rm "test-runner.sh" && \
		echo "removed test-runner.sh"\
	) || exit 0

update-test-runner.sh: remove-test-runner.sh test-runner.sh

.SILENT:
.PHONY: test bootstrap
