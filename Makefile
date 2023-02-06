
progname:= encrypt

build-dir:= build
src-dir:= src

src-c:= $(shell find $(src-dir)/ -type f -regex ".*\.c")
src-s:= $(shell find $(src-dir)/ -type f -regex ".*\.S")

objtmp:= $(src-c:.c=.o)
objtmp+= $(src-s:.S=.o)
obj:= $(objtmp:$(src-dir)/%=$(build-dir)/%)
dep:= $(obj:.o=.d)

CC:= ${target}gcc
AS:= ${target}gcc

CFLAGS:= -Wall -Wextra -fpic -MMD -I $(src-dir) -g3
LDFLAGS:= -pie

.PHONY: all
all: $(progname)

$(progname): $(obj)
	$(CC) $(LDFLAGS) -o $@ $^ 

-include $(dep)

$(build-dir)/%.o: $(src-dir)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ -c $<

$(build-dir)/%.o: $(src-dir)/%.S
	@mkdir -p $(dir $@)
	$(AS) $(CFLAGS) -o $@ -c $<

.PHONY: all
clean:
	$(RM) $(obj)
	$(RM) -r $(build-dir)
	$(RM) $(progname)

.PHONY: all
re: clean all
