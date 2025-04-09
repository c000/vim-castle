.PHONY: install
install: install-config

.PHONY: install-config
install-config:
	ln -s -t ~/.local/share/nvim/site/pack/ $(PWD)
