#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: list list-makefiles
list list-makefiles:
	@for target in $(MAKEFILE_LIST); do \
	echo "$$target"; \
	done

#├─────────────────────────────────────────────────────────────────────────────┤

.PHONY: help helps list-helps
help helps list-helps:
	$(info Help Commands)
	$(info -------------)
	@for target in $(basename $(notdir $(MAKEFILE_LIST))); do \
	test "$$target" != "Makefile" && echo "make $$target-help"; \
	done

#├─────────────────────────────────────────────────────────────────────────────┤
