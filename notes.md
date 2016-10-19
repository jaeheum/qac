
Title: notes 

Date: 20161019

<A name="toc1-7" title="Implementation Details" />
# Implementation Details

<A name="toc2-10" title="Atomic operation" />
## Atomic operation

Qac updates/reads its counters atomically with [GCC's atomic operations][gccatomic].

<A name="toc2-15" title="rszshm" />
## rszshm

Qac uses [rszshm][rszshm] to mmap shared memory across processes.
A copy is included in `rszshm` directory. rszshm has the same Apache 2.0 License.

`rszshm` creates a file `0` inside a directory prefixed by `rszshm_xxxxxx`
under `/dev/shm`.

<A name="toc2-24" title="/dev/shm" />
## /dev/shm

On modern Linux `/dev/shm` is mounted as a tmpfs whose size is
typically less than half of RAM (see [tmpfs reference][tmpfs]).

<A name="toc1-30" title="Bugs" />
# Bugs

<A name="toc2-33" title="Memory leak" />
## Memory leak

Reusing a `detatch`ed but not yet `rm`ed counter can leak a small amount of memory
for the unfreed (`rm`) `rszshm` data structure.

<A name="toc2-39" title="Safety and security" />
## Safety and security

- Treat counters as opaque type
- `detach` counters to prevent accidental modification from a process (safety)
- `rm` counters to prevent leaking information to future processes (security)
- Note that shm files can be read/modified, obeying the usual linux file acccess rights
- If the shm file is removed from the file system `fname` and `rm` raise `'No such file or directory`

<A name="toc3-48" title="Content of the shm file" />
### Content of the shm file

    q)c:init 999999999
    q)fname c
    `:/dev/shm/rszshm_yjnYJh/0
    q)\od -j 24 -l /dev/shm/rszshm_yjnYJh/0
    "0000030            999999999                    0"

[gccatomic]: https://gcc.gnu.org/onlinedocs/gcc/_005f_005fatomic-Builtins.html#g_t_005f_005fatomic-Builtins
[rszshm]: http://ccodearchive.net/info/rszshm.html
[tmpfs]: https://www.kernel.org/doc/Documentation/filesystems/tmpfs.txt

_This documentation was generated from qac/notes.txt using [Gitdown](https://github.com/zeromq/gitdown)_
