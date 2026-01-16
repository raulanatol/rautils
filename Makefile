.PHONY: help validate test release clean

# Default target
help:
	@echo "rautils - Release Management"
	@echo ""
	@echo "Available targets:"
	@echo "  make validate          - Run bash syntax checks and validation"
	@echo "  make test              - Run validation and tests"
	@echo "  make release type=TYPE - Create and push release (TYPE: patch|minor|major)"
	@echo "  make clean             - Clean temporary files"
	@echo ""
	@echo "Example:"
	@echo "  make release type=patch"

# Validate bash syntax and project structure
validate:
	@echo "Running validation checks..."
	@bash scripts/validate.sh

# Test alias for validate (for now, same as validate)
test: validate
	@echo "All tests passed!"

# Release target - requires type parameter
release:
ifndef type
	$(error type parameter is required. Usage: make release type=patch|minor|major)
endif
	@if [ "$(type)" != "patch" ] && [ "$(type)" != "minor" ] && [ "$(type)" != "major" ]; then \
		echo "Error: type must be patch, minor, or major"; \
		exit 1; \
	fi
	@echo "Creating $(type) release..."
	@bash scripts/create-release.sh $(type)

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.tmp" -delete
	@find . -name "*.bak" -delete
	@echo "Clean complete"
