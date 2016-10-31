/// qac - shared memory atomic counter for q on linux
/// 
/// qac contains two APIs:
/// - counter -- atomic counter for q on linux 
/// - proc -- fork/wait/kill q processes
///
/// Copyright (c) 2016 Jaeheum Han <jay.han@gmail.com>
/// Licensed under Apache License v2.0 - see LICENSE file for details
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <unistd.h>
#include <errno.h>
#include <assert.h>
#include <rszshm.h>
#include "k.h"

#define RZ R(K)0
#define K0(f) K f(void)
#define VSK(x) (V*)(intptr_t)(x->j) // void* from K; dual: ptr(V*). c.f. ZTK.
ZK ptr(V*x){if(x){R kj((intptr_t)x);}else{RZ;}} // K from opaque types e.g. void*, zctx_t, etc; dual: VSK(x).
#define ZTK(t,v) t*v=(t*)(intptr_t)(x->j)
#define KRR(x) krr(strerror(x))
#define TC(x,T) P(x->t!=T,krr("type")) // typechecker
#define tblsize(x) (sizeof(x)/sizeof((x)[0]))

#define rptr(x) struct rszshm*r=VSK(kK(x)[1])
#define __ASC __ATOMIC_SEQ_CST

/// o:.z.i; do[.z.c;if[o~.z.i;pids,:fork[]]]; ... ; wait[]
K0(qfork){setpgid(0,0);pid_t pid=fork();if(pid>0)signal(SIGCHLD,SIG_IGN);
    R pid==-1?KRR(errno):ki(pid);}

/// wait[] / blocks until all fork[]ed children are dead
K0(qwait){waitpid(0,NULL,0);signal(SIGCHLD,SIG_DFL);RZ;}

/// kill[pids] / kill all pids
K1(qkill){DO(xn,kill(xI[i],SIGKILL));RZ;}

/// c:init j / c~(kc(-KJ);kj(intptr_t))
K1(init){TC(x,-KJ);struct rszshm*r;P(!rszshm_mkm(r,sizeof(J),NULL),KRR(errno));K v;
    memcpy((J*)r->dat,&xj,sizeof(J));
    R v=ktn(0,2),kK(v)[0]=kc(-KJ),kK(v)[1]=ptr(r),v;}

/// c:restart fname / `:/dev/rszshm_xxxxxx/0 or fname c
K1(restart){TC(x,-KS);struct rszshm*r;P(!rszshm_atm(r,++xs),KRR(errno));K v;
    R v=ktn(0,2),kK(v)[0]=kc(-KJ),kK(v)[1]=ptr(r),v;}

/// f:fname c / f~`:/dev/rszshm_xxxxxx/0 (useful for restart f)
K1(fname){TC(x,0);rptr(x);U(r);struct stat st;P(-1==stat(r->fname,&st),KRR(errno));
    S s;R -1==asprintf(&s,"%s%s",":",r->fname)?(K)0:ks(s);}

/// detach c / detach c from current process, all ops but fname and rm are no-ops afterwards
K1(detach){TC(x,0);rptr(x);U(r);U(-1==rszshm_dt(r));RZ;}

/// rm c / rm the underlying shm file, preventing future processes from accessing it
K1(rm){TC(x,0);rptr(x);U(r);P(-1==rszshm_rm(r),KRR(errno));free(r);RZ;}

/// xx:inc,dec,print c / xx:the value of counter, or nothing after detach or rm
K1(inc){TC(x,0);U(xn==2);rptr(x);U(r);U(r->dat);U(r->fd!=-1);
    R kj(__atomic_add_fetch((J*)(r->dat),1,__ASC));}
K1(dec){TC(x,0);U(xn==2);rptr(x);U(r);U(r->dat);U(r->fd!=-1);
    R kj(__atomic_sub_fetch((J*)(r->dat),1,__ASC));}
K1(print){TC(x,0);U(xn==2);rptr(x);U(r);U(r->dat);U(r->fd!=-1);
    J j;__atomic_load((J*)(r->dat),&j,__ASC);R kj(j);}

typedef struct{S apiname; S fnname; V* fn; I argc;} cqacapi;
Z cqacapi procapi[]={
    {"proc","fork",qfork,0},
    {"proc","wait",qwait,0},
    {"proc","kill",qkill,1},
    {NULL, NULL, NULL, 0}};
Z cqacapi counterapi[]={
    {"counter","init",init,1},
    {"counter","restart",restart,1},
    {"counter","detach",detach,1},
    {"counter","fname",fname,1},
    {"counter","rm",rm,1},
    {"counter","inc",inc,1},
    {"counter","dec",dec,1},
    {"counter","print",print,1},
    {NULL, NULL, NULL, 0}};
#define APITAB(fnname,fn,argc) xS[i]=ss(fnname);kK(y)[i]=dl(fn,argc>0?argc:1)
#define EXPAPI(name) K1(name){int n=tblsize(name##api)-1; K y=ktn(0,n);x=ktn(KS,n); \
    DO(n, APITAB(name##api[i].fnname, name##api[i].fn, name##api[i].argc)); \
    R xD(x,y);}
EXPAPI(proc);
EXPAPI(counter);

