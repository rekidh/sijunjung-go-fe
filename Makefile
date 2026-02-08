.PHONY: customer driver merchant sync help

help:
	@echo "Sijunjung Go - Command Shortcuts"
	@echo ""
	@echo "Usage:"
	@echo "  make customer    - Start Customer App"
	@echo "  make driver      - Start Driver App"
	@echo "  make merchant    - Start Merchant App"
	@echo "  make sync        - Sync all dependencies"
	@echo ""
	@echo "You can also run the script directly:"
	@echo "  ./start-apps --customer-app"

customer:
	./start-apps --customer-app

driver:
	./start-apps --driver-app

merchant:
	./start-apps --merchant-app

sync:
	./start-apps --sync
