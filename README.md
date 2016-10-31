
Title: README

Date: 20161031

<A name="toc1-7" title="qac " />
# qac 

Qac provides shared memory atomic counter to multiple q processes on Linux.
These processes can be either parent/children or unrelated.

<A name="toc1-13" title="Contents" />
# Contents


**<a href="#toc1-18">Copyright and License</a>**

**<a href="#toc1-25">Example</a>**

**<a href="#toc1-38">API</a>**
*  <a href="#toc2-56">Opaque type</a>

**<a href="#toc1-61">Installation</a>**

**<a href="#toc1-73">Implementation Details and Bugs</a>**

<A name="toc1-18" title="Copyright and License" />
# Copyright and License

```
Copyright (c) 2016 Jaeheum Han <jay.han@gmail.com>
Licensed under Apache License v2.0 - see LICENSE file for details 
```
<A name="toc1-25" title="Example" />
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

<A name="toc1-38" title="API" />
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

<A name="toc2-56" title="Opaque type" />
## Opaque type

Treat counter or the return value of `init` and `restart` as opaque type.

<A name="toc1-61" title="Installation" />
# Installation

`make install` copies `qac.so` and `rszshm.o` to `~/q/l64` and `qac.q` to `~/q/`.

Note [makefile][makefile] assumes that

- kdb+ version > 3.0 on 64-bit linux (l64) with gcc
  - add `-m32` flag and change `l64` to `l32` for 32-bit
- `q` and `c.o` are installed in `~/q/l64`
- `k.h` is in `~/q/c/`

<A name="toc1-73" title="Implementation Details and Bugs" />
# Implementation Details and Bugs

See [notes.md][notes.md].

[notes.md]: ./notes.md
[demo.q]: ./demo.q
[makefile]: ./makefile

_This documentation was generated from qac/README.txt using [Gitdown](https://github.com/zeromq/gitdown)_
