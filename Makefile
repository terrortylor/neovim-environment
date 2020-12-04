all: lint test

lint:
	@echo "Linting..."
	luacheck --no-color .
	@echo

test:
	@echo "Run tests..."
	busted -C=lua -v
	@echo
