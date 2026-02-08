.PHONY: customer driver merchant sync help

help:
	@echo "Sijunjung Go - Command Shortcuts"
	@echo ""
	@echo "Usage (Default: Production):"
	@echo "  make customer    - Start Customer App (Prod)"
	@echo "  make driver      - Start Driver App (Prod)"
	@echo "  make merchant    - Start Merchant App (Prod)"
	@echo "  make sync        - Sync all dependencies"
	@echo ""
	@echo "Development Environment:"
	@echo "  make customer-dev - Start Customer App (Dev)"
	@echo "  make driver-dev   - Start Driver App (Dev)"
	@echo "  make merchant-dev - Start Merchant App (Dev)"
	@echo ""
	@echo "You can also run the script directly with more options:"
	@echo "  ./start-apps --customer-app --env dev --clean"

customer:
	./start-apps --customer-app --env prod

customer-dev:
	./start-apps --customer-app --env dev

driver:
	./start-apps --driver-app --env prod

driver-dev:
	./start-apps --driver-app --env dev

merchant:
	./start-apps --merchant-app --env prod

merchant-dev:
	./start-apps --merchant-app --env dev

sync:
	./start-apps --sync
