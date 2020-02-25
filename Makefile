ASM = rgbasm
LINK = rgblink
GFX = rgbgfx
FIX = rgbfix

ROM_NAME = dino
FIX_FLAGS = -v -p 0

SOURCES = $(wildcard src/*)
GRAPHICS = $(wildcard gfx/*.?bpp.png)

INCLUDE = -iinc/ -i$(OBJDIR)/gfx/
OBJDIR = out
DIRS = $(OBJDIR)/src $(OBJDIR)/gfx
OBJECTS = $(addprefix out/, $(SOURCES:.asm=.o))
GFXOBJECTS = $(addprefix out/, $(GRAPHICS:.png=))

all: $(ROM_NAME)

${OBJDIR}/%.o: %.asm
	$(ASM) $(INCLUDE) -o $@ $<

$(OBJDIR)/%.1bpp: %.1bpp.png
	$(GFX) -d 1 -o $@ $<

$(OBJDIR)/src/graphics.o: $(GFXOBJECTS)

$(ROM_NAME): $(OBJECTS)
	$(LINK) -o $@.gb -n $@.sym -m $@.map $(OBJECTS)
	$(FIX) $(FIX_FLAGS) $@.gb

clean:
	rm -rf $(ROM_NAME).gb $(ROM_NAME).sym $(OBJDIR)

$(shell mkdir -p $(DIRS))
