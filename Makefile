test: prepare
	./test.sh

prepare:
	test -f "test/assert.sh" || ( \
		echo "fetching assert.sh..." && \
		curl -s -L -o test/assert.sh \
			https://raw.github.com/lehmannro/assert.sh/master/assert.sh \
	)

.SILENT:
.PHONY: test prepare
