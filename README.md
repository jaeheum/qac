
Title: README

Date: 20161019

<A name="toc1-7" title="qac " />
# qac 

Qac provides shared memory atomic counter to multiple q processes on Linux.
These processes can be either parent/children or unrelated.

<A name="toc1-13" title="Contents" />
# Contents


**<a href="#toc1-18">Copyright and License</a>**

**<a href="#toc1-24">API</a>**
*  <a href="#toc2-40">Opaque type</a>

**<a href="#toc1-45">Installation</a>**

**<a href="#toc1-56">Implementation Details and Bugs</a>**

<A name="toc1-18" title="Copyright and License" />
# Copyright and License

    Copyright (c) 2016 Jaeheum Han <jay.han@gmail.com>
    Licensed under Apache License v2.0 - see LICENSE file for details 

<A name="toc1-24" title="API" />
# API

    \l qac.q
    o:.z.i; do[.z.c;if[o~.z.i;pids,:fork[]]]; ... ; wait[]
    wait[] / blocks until all fork[]ed children are dead
    kill[pids] / kill all pids
    c:init j / c~(kc(-KJ);kj(intptr_t))
    c:restart fname / `:/dev/rszshm_blah/0 or fname c
    f:fname c / f~`:/dev/rszshm_xxxxxx/0 (useful for restart f)
    detach c / detach c from current process, all ops but fname and rm are no-ops afterwards
    rm c / rm the underlying shm file, preventing future processes from accessing it
    xx:inc,dec,print c / xx:the value of counter, or nothing after detach or rm

See `demo.q` for examples.

<A name="toc2-40" title="Opaque type" />
## Opaque type

Treat counter or the return value of `init` and `restart` as opaque type.

<A name="toc1-45" title="Installation" />
# Installation

Run `make all` -- this puts `qac.so` and `rszshm.o` to `~/q/l64`.

Note `makefile` assumes that

- `q` and `c.o` are installed in `~/q/l64`
- `k.h` is in `~/q/c/`
- 64-bit linux and gcc (for extensions); add `-m32` flag and change `l64` to `l32` for 32-bit

<A name="toc1-56" title="Implementation Details and Bugs" />
# Implementation Details and Bugs

See [notes.md][notes.md].

[notes.md]: ./notes.md

_This documentation was generated from qac/README.txt using [Gitdown](https://github.com/zeromq/gitdown)_
