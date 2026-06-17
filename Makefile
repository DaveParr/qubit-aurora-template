.PHONY: build flash

build:
ifndef PROJECT
	$(error PROJECT is not set. Usage: make build PROJECT=hello-aurora)
endif
	$(MAKE) -C $(PROJECT)

flash:
ifndef PROJECT
	$(error PROJECT is not set. Usage: make flash PROJECT=hello-aurora MOUNT=/media/dave/AURORA)
endif
ifndef MOUNT
	$(error MOUNT is not set. Usage: make flash PROJECT=hello-aurora MOUNT=/media/dave/AURORA)
endif
	cp $(PROJECT)/build/$(PROJECT).bin $(MOUNT)/
	sync
	@echo "Flashed $(PROJECT).bin to $(MOUNT)/"
