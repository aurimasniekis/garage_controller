# Define CPU Core
PREFIX        = arm-none-eabi
ARMGCC_ROOT   = /usr/local/gcc_embedded
STELLARISWARE = /usr/local/gcc_embedded/stellarisware
PART          = LM4F120H5QR
CPU           = cortex-m4
FPU           = fpv4-sp-d16
FABI          = hard
OPTI_LVL      = s
TARGET        = main
SRC           = $(wildcard *.c) $(wildcard *.cpp) $(wildcard hardware/*.c) $(wildcard hardware/*.cpp) $(wildcard software/*.c) $(wildcard software/*.cpp) 
LIBS          = 
INC           = -I./

LINKER_FILE   = LM4F.ld
STARTUP_FILE  = $(ARMGCC_ROOT)/startup/LM4F_startup.c

CC      = $(PREFIX)-gcc
LD      = $(PREFIX)-ld
CP      = $(PREFIX)-objcopy
OD      = $(PREFIX)-objdump
AR      = $(PREFIX)-ar
SIZE    = $(PREFIX)-size

# Assembler Flags
AFLAGS = -mthumb -mcpu=$(CPU) -mfpu=$(FPU) -mfloat-abi=$(FABI) -MD

# Compiler Flags
GCCFLAGS = -mthumb -mcpu=$(CPU) -mfpu=$(FPU) -mfloat-abi=$(FABI)
GCCFLAGS+= -O$(OPTI_LVL) -ffunction-sections -fdata-sections -Wall
GCCFLAGS+= -MD -Wall #-pedantic
GCCFLAGS+= -DPART_$(PART) -c -DTARGET_IS_BLIZZARD_RA1
GCCFLAGS+= -g
GCCFLAGS+= -I $(STELLARISWARE)/

CCFLAGS = -std=c99

LIB_GCC_PATH=$(shell $(CC) $(GCCFLAGS) -print-libgcc-file-name)
LIBC_PATH=$(shell $(CC) $(GCCFLAGS) -print-file-name=libc.a)
LIBM_PATH=$(shell $(CC) $(GCCFLAGS) -print-file-name=libm.a)
LFLAGS = --gc-sections --entry ResetISR
CPFLAGS = -O binary

ODFLAGS = -S

FLASHER=lm4flash
FLASHER_FLAGS=-v

ifdef DEBUG

GCCFLAGS+=-g -D DEBUG

endif



# Define all object files.

# Start by splitting source files by type
#  C++
CPPFILES=$(filter %.cpp, $(SRC))
CCFILES=$(filter %.cc, $(SRC))
BIGCFILES=$(filter %.C, $(SRC))
#  C
CFILES=$(filter %.c, $(SRC))
#  Assembly
ASMFILES=$(filter %.S, $(SRC))


# List all object files we need to create
OBJDEPS=$(CFILES:.c=.o)    \
	$(CPPFILES:.cpp=.o)\
	$(BIGCFILES:.C=.o) \
	$(CCFILES:.cc=.o)  \
	$(ASMFILES:.S=.o)

# Define all lst files.
LST=$(filter %.lst, $(OBJDEPS:.o=.lst))

# All the possible generated assembly 
# files (.s files)
GENASMFILES=$(filter %.s, $(OBJDEPS:.o=.s)) 


.SUFFIXES : .c .cc .cpp .C .o .out .s .S \
	.hex .ee.hex .h .hh .hpp
    
all: clean $(OBJDEPS) $(TARGET).elf $(TARGET) stats

disasm: $(DUMPTRG) stats

stats: $(TARGET)
	$(OD) -h bin/$(TARGET).elf
	$(SIZE) bin/$(TARGET).elf

$(TARGET).elf: $(OBJDEPS) 
	$(LD) -T $(LINKER_FILE) $(LFLAGS) -o bin/$(TARGET).elf $(OBJDEPS) $(STELLARISWARE)/driverlib/gcc-cm4f/libdriver-cm4f.a $(LIBM_PATH) $(LIBC_PATH) $(LIB_GCC_PATH)

$(TARGET): $(TARGET).elf
	$(CP) $(CPFLAGS) bin/$(TARGET).elf bin/$(TARGET).bin
	$(OD) $(ODFLAGS) bin/$(TARGET).elf > bin/$(TARGET).lst


#### Generating assembly ####
# asm from C
%.s: %.c
	$(CC) -S $(CCFLAGS) $(GCCFLAGS) $< -o $@

# asm from (hand coded) asm
%.s: %.S
	$(CC) -S $(AFLAGS) $< > $@


# asm from C++
.cpp.s .cc.s .C.s :
	$(CC) -S $(GCCFLAGS) $(CPPFLAGS) $< -o $@



#### Generating object files ####
# object from C
.c.o: 
	$(CC) $(GCCFLAGS) -c $< -o $@


# object from C++ (.cc, .cpp, .C files)
.cc.o .cpp.o .C.o :
	$(CC) $(GCCFLAGS) $(CPPFLAGS) -c $< -o $@

# object from asm
.S.o :
	$(CC) $(AFLAGS) -c $< -o $@
    
clean:
	rm -f *.o *.d bin/* hardware/*.o hardware/*.d software/*.o software/*.d
     