test: prepare
	./test.sh

prepare:
	test -f "test/assert.sh" || ( \
		echo "fetching assert.sh..." && \
		curl -s -L -o test/assert.sh \
			https://raw.github.com/lehmannro/assert.sh/v1.0.2/assert.sh \
	)

.SILENT:
.PHONY: test prepare
