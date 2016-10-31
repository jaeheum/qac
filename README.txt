.set GIT=https://github.com/jaeheum/qac
.set VER=2016.10.19

Title: README

Date: &date()

# qac 

Qac provides shared memory atomic counter to multiple q processes on Linux.
These processes can be either parent/children or unrelated.

# Contents

.toc

# Copyright and License

```
Copyright (c) 2016 Jaeheum Han <jay.han@gmail.com>
Licensed under Apache License v2.0 - see LICENSE file for details 
```
# Example

```
q)\l qac.q
q)c:init 0;n:123456789
q)do[n;inc c];print c
123456789
q)do[n;dec c];0~print c
1b
q)
```

# API

```
o:.z.i; do[.z.c;if[o~.z.i;pids,:fork[]]]; ... ; wait[]
wait[] / blocks until all fork[]ed children are dead
kill[pids] / kill all pids
c:init j / c~(kc(-KJ);kj(intptr_t))
c:restart fname / `:/dev/rszshm_xxxxxx/0 or fname c
f:fname c / f~`:/dev/rszshm_xxxxxx/0 (useful for restart f)
detach c / detach c from current process, all ops but fname and rm are no-ops afterwards
rm c / rm the underlying shm file, preventing future processes from accessing it
xx:inc,dec,print c / xx:the value of counter, or nothing after detach or rm
```

For better performance ignore return values of `inc`/`dec`, and `print`
afterwards (see [demo.q][demo.q]).

## Opaque type

Treat counter or the return value of `init` and `restart` as opaque type.

# Installation

`make install` copies `qac.so` and `rszshm.o` to `~/q/l64` and `qac.q` to `~/q/`.

Note [makefile][makefile] assumes that

- kdb+ version > 3.0 on 64-bit linux (l64) with gcc
  - add `-m32` flag and change `l64` to `l32` for 32-bit
- `q` and `c.o` are installed in `~/q/l64`
- `k.h` is in `~/q/c/`

# Implementation Details and Bugs

See [notes.md][notes.md].

.- Reference
.-
[notes.md]: ./notes.md
[demo.q]: ./demo.q
[makefile]: ./makefile
