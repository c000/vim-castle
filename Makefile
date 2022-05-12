.PHONY: install
install:
	cd start/coc.nvim && yarn install --frozen-lockfile

install-config:
	ln -s -t ~/.local/share/nvim/site/pack/ $(PWD)
