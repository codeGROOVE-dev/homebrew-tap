.PHONY: test style audit

test: style audit

style:
	brew style --fix codegroove-dev/tap

audit:
	brew audit --except=installed --tap=codegroove-dev/tap
