all: lint fmt test

install_dependencies:
	luarocks install luacheck --local
	luarocks path > ~/.bashrc.d/luacheck.sh

lint:
	@echo "Linting ..."
	luacheck --no-color .

fmt:
	@echo "Formatting ..."
	stylua -c lua
	@echo

unit:
	@echo "Run unit tests..."
	# hanging tests, see issue: https://github.com/nvim-lua/plenary.nvim/issues/319
	nvim --headless --noplugin -c 'packadd plenary.nvim' -c "PlenaryBustedDirectory lua/spec"
	@echo

integration:
	@echo "Run integration tests..."
	nvim --headless -c "PlenaryBustedDirectory tests"
	@echo

test: unit integration
