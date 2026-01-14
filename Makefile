.PHONY: test style audit upgrade reinstall

# Run all checks
test: style audit

# Fix style issues
style:
	brew style --fix codegroove-dev/tap

# Audit the tap (skip false positive about homebrew-core conflict)
audit:
	brew audit --except=installed,token_conflicts --tap=codegroove-dev/tap

# Upgrade review-goose to a new version
# Usage: make upgrade VERSION=v0.9.7
upgrade:
ifndef VERSION
	$(error VERSION is required. Usage: make upgrade VERSION=v0.9.7)
endif
	@echo "Upgrading review-goose to $(VERSION)..."
	@# Get the commit SHA for the tag (handles signed/annotated tags)
	@# Try dereferenced commit first (for annotated/signed tags), then fall back to direct ref
	@COMMIT=$$(git ls-remote https://github.com/codeGROOVE-dev/goose.git "$(VERSION)^{}" 2>/dev/null | head -1 | cut -f1); \
	if [ -z "$$COMMIT" ]; then \
		echo "Trying lightweight tag..."; \
		COMMIT=$$(git ls-remote --refs https://github.com/codeGROOVE-dev/goose.git $(VERSION) | head -1 | cut -f1); \
	fi; \
	if [ -z "$$COMMIT" ]; then \
		echo "Error: Could not find tag $(VERSION)"; \
		exit 1; \
	fi; \
	echo "Tag $(VERSION) -> commit $$COMMIT"; \
	VERSION_NUM=$$(echo $(VERSION) | sed 's/^v//'); \
	echo "Updating Formula/review-goose.rb..."; \
	sed -i '' -E "s/tag:[ ]*\"v[0-9]+\.[0-9]+\.[0-9]+\"/tag:      \"$(VERSION)\"/" Formula/review-goose.rb; \
	sed -i '' -E "s/revision:[ ]*\"[a-f0-9]+\"/revision: \"$$COMMIT\"/" Formula/review-goose.rb; \
	echo "Updating Casks/review-goose.rb..."; \
	sed -i '' -E "s/version \"[0-9]+\.[0-9]+\.[0-9]+\"/version \"$$VERSION_NUM\"/" Casks/review-goose.rb; \
	sed -i '' -E "s/revision:[ ]*\"[a-f0-9]+\"/revision: \"$$COMMIT\"/" Casks/review-goose.rb
	@echo "Done. Run 'make test' to lint and 'make reinstall' to test install."

# Copy files to tap location and reinstall cask
reinstall:
	@echo "Copying files to tap..."
	@cp Formula/review-goose.rb /opt/homebrew/Library/Taps/codegroove-dev/homebrew-tap/Formula/
	@cp Casks/review-goose.rb /opt/homebrew/Library/Taps/codegroove-dev/homebrew-tap/Casks/
	@echo "Clearing cache..."
	@rm -rf ~/Library/Caches/Homebrew/Cask/goose* ~/Library/Caches/Homebrew/downloads/*goose* 2>/dev/null || true
	@echo "Removing old app..."
	@rm -rf "/Applications/reviewGOOSE.app" 2>/dev/null || true
	@echo "Installing cask..."
	brew reinstall --cask codegroove-dev/tap/review-goose
	@echo "Verifying version..."
	@"/Applications/reviewGOOSE.app/Contents/MacOS/reviewGOOSE" --version
