o:.z.i / pid of this process or the parent
\l qac.q

c:init i:0 

//demo[nproc;nreps]
// fork children, use counter, exit (wait on children if parent)
counterdemo:{if[x<2;x:1];
    show "atomic z:inc c;z:dec c; ",(string y)," times on ",(string x)," processes";
    pids:();do[x;if[o~.z.i;pids,:fork[]]];
    $[not o~.z.i;
        [t:system"t do[",(string y),";z:inc c;z:dec c]";
         show (string 2*y%(t%1000f))," ops/s per process pid:",(string .z.i);
	 system"\\"];wait[]]}
counterdemo2:{if[x<2;x:1]; / w/o z: assignment penalty
    show "atomic inc c;dec c; ",(string y)," times on ",(string x)," processes";
    pids:();do[x;if[o~.z.i;pids,:fork[]]];
    $[not o~.z.i;
        [t:system"t do[",(string y),";inc c;dec c]";
         show (string 2*y%(t%1000f))," ops/s per process pid:",(string .z.i);
	 system"\\"];wait[]]}
nreps:123456789
show "nreps:",(string nreps)
nreps:123456789
show "nreps:",(string nreps)
show "\t do[2*",(string nreps),";]"
\t do[2*nreps;]
show "\t do[2*",(string nreps),";;]"
\t do[2*nreps;;]
show "\t do[2*",(string nreps),":;{::}0]"
\t do[2*nreps;{::}0]
show "\t do[2*",(string nreps),";{x}0]"
\t do[2*nreps;{x}0]
show "\t do[2*",(string nreps),";x:{x}0]"
\t do[2*nreps;x:{x}0]

show "\t do[",(string nreps),";z+1;z-1]"
z:0;t:system"t do[",(string nreps),";z+1;z-1]"
show (string 2*nreps%(t%1000f))," ops/s"
/\t z:0;do[nreps;z+1;z-1]
show "\t z:0;do[",(string nreps),";z:z+1;z:z-1]"
z:0;t:system"t do[",(string nreps),";z:z+1;z:z-1]"
show (string 2*nreps%(t%1000f))," ops/s"
/\t z:0;do[nreps;z:z+1;z:z-1]
\ts counterdemo[1;nreps]
\ts counterdemo2[1;nreps]
\ts counterdemo[2;nreps]
\ts counterdemo2[2;nreps]
\ts counterdemo[.z.c div 2;nreps]
\ts counterdemo2[.z.c div 2;nreps]
\ts counterdemo[.z.c;nreps]
\ts counterdemo2[.z.c;nreps]
show "detach existing counter"
f:fname c
detach c
show "restarting existing counter works?"
c:restart f / XXX small memory leak (see notes.md)
i~print c
counterdemo2[1;nreps]

show "remove the counter from shared memory and exit"
rm c
\\
CPU: six core Intel(R) Core(TM) i7-6800K CPU @ 3.40GHz
OS: CentOS 7
KDB+ 3.4 2016.06.27 Copyright (C) 1993-2016 Kx Systems

"nreps:123456789"
"nreps:123456789"
"\t do[2*123456789;]"
1827
"\t do[2*123456789;;]"
3002
"\t do[2*123456789:;{::}0]"
12188
"\t do[2*123456789;{x}0]"
12201
"\t do[2*123456789;x:{x}0]"
28380
"\t do[123456789;z+1;z-1]"
"1.427824e+07 ops/s"
"\t z:0;do[123456789;z:z+1;z:z-1]"
"6920806 ops/s"
"atomic z:inc c;z:dec c; 123456789 times on 1 processes"
"7639416 ops/s per process pid:8161"
32321 4194960
"atomic inc c;dec c; 123456789 times on 1 processes"
"1.695951e+07 ops/s per process pid:8161"
14559 4194960
"atomic z:inc c;z:dec c; 123456789 times on 2 processes"
"6131909 ops/s per process pid:8161"
"6122027 ops/s per process pid:8448"
40333 4194960
"atomic inc c;dec c; 123456789 times on 2 processes"
"1.155854e+07 ops/s per process pid:8461"
"1.152994e+07 ops/s per process pid:8161"
21416 4194960
"atomic z:inc c;z:dec c; 123456789 times on 6 processes"
"5062090 ops/s per process pid:8481"
"5055043 ops/s per process pid:8478"
"5052250 ops/s per process pid:8479"
"5052250 ops/s per process pid:8480"
"4991380 ops/s per process pid:8482"
"4874898 ops/s per process pid:8161"
50650 4194960
"atomic inc c;dec c; 123456789 times on 6 processes"
"5225352 ops/s per process pid:8513"
"5191623 ops/s per process pid:8515"
"5166421 ops/s per process pid:8511"
"5160590 ops/s per process pid:8514"
"5147465 ops/s per process pid:8512"
"5142426 ops/s per process pid:8161"
48016 4194960
"atomic z:inc c;z:dec c; 123456789 times on 12 processes"
"3098154 ops/s per process pid:8553"
"3097299 ops/s per process pid:8161"
"3092063 ops/s per process pid:8557"
"3091250 ops/s per process pid:8551"
"3089780 ops/s per process pid:8549"
"3089084 ops/s per process pid:8550"
"3088891 ops/s per process pid:8548"
"3088041 ops/s per process pid:8552"
"3087500 ops/s per process pid:8554"
"3087230 ops/s per process pid:8555"
"3087192 ops/s per process pid:8556"
"3084222 ops/s per process pid:8558"
80058 4194960
"atomic inc c;dec c; 123456789 times on 12 processes"
"4811067 ops/s per process pid:8621"
"4810411 ops/s per process pid:8615"
"4810036 ops/s per process pid:8624"
"4809755 ops/s per process pid:8618"
"4809005 ops/s per process pid:8616"
"4807695 ops/s per process pid:8622"
"4802178 ops/s per process pid:8623"
"4799937 ops/s per process pid:8617"
"4794252 ops/s per process pid:8625"
"4793228 ops/s per process pid:8619"
"4745600 ops/s per process pid:8620"
"4735407 ops/s per process pid:8161"
52144 4194960
"detach existing counter"
"restarting existing counter works?"
1b
"atomic inc c;dec c; 123456789 times on 1 processes"
"1.792606e+07 ops/s per process pid:8161"
"remove the counter from shared memory and exit"
