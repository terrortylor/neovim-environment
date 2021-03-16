all: lint test

lint:
	@echo "Linting..."
	luacheck --no-color .
	@echo

test:
	@echo "Run tests..."
	nvim --headless -c 'PlenaryBustedDirectory lua/spec/'
	@echo
