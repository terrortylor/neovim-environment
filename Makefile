all: lint test

lint:
	@echo "Linting..."
	luacheck --no-color .
	@echo

test:
	@echo "Run tests..."
	# TODO add these to runtime: /usr/share/nvim/runtime/lua/vim/
	# TODO use nvim's lua
	busted -m "./lua/?.lua;./lua/?/?.lua;./lua/?/init.lua" lua
	@echo
