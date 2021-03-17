all: lint test

lint:
	@echo "Linting..."
	luacheck --no-color .
	@echo

test:
	@echo "Run tests..."
	nvim --headless -c "PlenaryBustedDirectory lua/spec/"
	# nvim --headless --noplugin -u lua/spec/minimal_init.vim -c "PlenaryBustedDirectory lua/spec/ { minimal_init = './lua/spec/minimal_init.vim' }"
	@echo
