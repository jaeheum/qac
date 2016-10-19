.proc:(`qac 2:(`proc;1))`
fork:.proc.fork
wait:.proc.wait
.counter:(`qac 2:(`counter;1))`
init:.counter.init
restart:.counter.restart
inc:.counter.inc
dec:.counter.dec
print:.counter.print
detach:.counter.detach
fname:.counter.fname
rm:.counter.rm
\
.shm:(`qac 2:(`shm;1))`
copy:.shm.copy
peek:.shm.peek
join:.shm.join
amend:.shm.amend

