
version:= 0.1
name:= encrypt
libname:= lib$(name).a.$(version)

build-dir:= build
src-dir:= src
test-dir:= test

src-c:= $(shell find $(src-dir)/ -type f -regex ".*\.c")
src-s:= $(shell find $(src-dir)/ -type f -regex ".*\.S")

objtmp:= $(src-c:.c=.o)
objtmp+= $(src-s:.S=.o)
obj:= $(objtmp:$(src-dir)/%=$(build-dir)/%)
dep:= $(obj:.o=.d)

test-src-c:= $(shell find $(test-dir)/ -type f -regex ".*\.c")
test-objtmp:= $(test-src-c:.c=.o)
test-obj:= $(test-objtmp:$(test-dir)/%=$(build-dir)/%)

CC:= gcc
AR:= ar
AS:= gcc

CFLAGS:= -Wall -Wextra -fpic -MMD -I. -g3
ARFLAGS:= rc


.PHONY: all
all: $(libname)

.PHONY: test
test: $(libname) $(test-obj)
	$(CC) -pie $(test-obj) $(libname) -o testlib

$(libname): $(obj)
	$(AR) $(ARFLAGS) $@ $^

-include $(dep)

$(build-dir)/%.o: $(src-dir)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ -c $<

$(build-dir)/%.o: $(test-dir)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ -c $<

$(build-dir)/%.o: $(src-dir)/%.S
	@mkdir -p $(dir $@)
	$(AS) $(CFLAGS) -o $@ -c $<

.PHONY: all
clean:
	$(RM) $(obj)
	$(RM) -r $(build-dir)
	$(RM) $(libname)
	$(RM) testlib

.PHONY: all
re: clean all
