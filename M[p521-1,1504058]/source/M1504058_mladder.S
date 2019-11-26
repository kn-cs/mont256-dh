/*
+-----------------------------------------------------------------------------+
| This code corresponds to the the paper "Efficient Elliptic Curve            |
| Diffie-Hellman Computation at the 256-bit Security Level" authored by	      |
| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	              |
+-----------------------------------------------------------------------------+
| Copyright (c) 2019, Kaushik Nath and Palash Sarkar.                         |
|                                                                             |
| Permission to use this code is granted.                          	      |
|                                                                             |
| Redistribution and use in source and binary forms, with or without          |
| modification, are permitted provided that the following conditions are      |
| met:                                                                        |
|                                                                             |
| * Redistributions of source code must retain the above copyright notice,    |
|   this list of conditions and the following disclaimer.                     |
|                                                                             |
| * Redistributions in binary form must reproduce the above copyright         |
|   notice, this list of conditions and the following disclaimer in the       |
|   documentation and/or other materials provided with the distribution.      |
|                                                                             |
| * The names of the contributors may not be used to endorse or promote       |
|   products derived from this software without specific prior written        |
|   permission.                                                               |
+-----------------------------------------------------------------------------+
| THIS SOFTWARE IS PROVIDED BY THE AUTHORS ""AS IS"" AND ANY EXPRESS OR       |
| IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   |
| OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.     |
| IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,      |
| INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT    |
| NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   |
| DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY       |
| THEORY LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING |
| NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,| 
| EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                          |
+-----------------------------------------------------------------------------+
*/

.p2align 5
.globl M1504058_mladder
M1504058_mladder:

movq 	%rsp, %r11
subq 	$1016, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

movq	0(%rsi), %r8
movq	%r8, 72(%rsp)
movq	%r8, 288(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 296(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 304(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 312(%rsp)
movq	32(%rsi), %r8
movq	%r8, 104(%rsp)
movq	%r8, 320(%rsp)
movq	40(%rsi), %r8
movq	%r8, 112(%rsp)
movq	%r8, 328(%rsp)
movq	48(%rsi), %r8
movq	%r8, 120(%rsp)
movq	%r8, 336(%rsp)
movq	56(%rsi), %r8
movq	%r8, 128(%rsp)
movq	%r8, 344(%rsp)
movq	64(%rsi), %r8
movq	%r8, 136(%rsp)
movq	%r8, 352(%rsp)  // X1 = XP, X3 = XP

movq	$1, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)	// X2 = 1

movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)
movq	$0, 240(%rsp)
movq	$0, 248(%rsp)
movq	$0, 256(%rsp)
movq	$0, 264(%rsp)
movq	$0, 272(%rsp)
movq	$0, 280(%rsp) // Z2 = 0

movq	$1, 360(%rsp)
movq	$0, 368(%rsp)
movq	$0, 376(%rsp)
movq	$0, 384(%rsp)
movq	$0, 392(%rsp)
movq	$0, 400(%rsp)
movq	$0, 408(%rsp)
movq	$0, 416(%rsp)
movq	$0, 424(%rsp) // Z3 = 1

// X1: rsp(72)-rsp(136),
// X2: rsp(144)-rsp(208), Z2: rsp(216)-rsp(280),  
// X3: rsp(288)-rsp(352), Z3: rsp(360)-rsp(424).

leaq	144(%rsp), %r11  // &X2
leaq	216(%rsp), %r12  // &Z2
leaq	288(%rsp), %r13  // &X3
leaq	360(%rsp), %r14  // &Z3

movq	%r11, 432(%rsp)  // &X2
movq	%r12, 440(%rsp)  // &Z2
movq	%r13, 448(%rsp)  // &X3
movq	%r14, 456(%rsp)  // &Z3

movq	%r13, 464(%rsp)  // &X3
movq	%r14, 472(%rsp)  // &Z3
movq	%r11, 480(%rsp)  // &X2
movq	%r12, 488(%rsp)  // &Z2

// r15 = i, rcx = j
movq    $65, 504(%rsp) // r15
movb	$0, 496(%rsp)  // cl
movq    %rdx, 64(%rsp)

movq    %rdx, %rax  	// rax = &n[0]

/* 
 * Montgomery ladder step
 *
 * T1 <- X2 + Z2
 * T2 <- X2 - Z2
 * T3 <- X3 + Z3
 * T4 <- X3 - Z3
 * T5 <- T1^2
 * T6 <- T2^2
 * T2 <- T2 · T3
 * T1 <- T1 · T4
 * T1 <- T1 + T2
 * T2 <- T1 - T2
 * X3 <- T1^2
 * T2 <- T2^2
 * Z3 <- T2 · X1
 * X2 <- T5 · T6
 * T5 <- T5 - T6
 * T1 <- ((A + 2)/4) · T5
 * T6 <- T6 + T1
 * Z2 <- T5 · T6
 *
 */

.L1:
addq    504(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 498(%rsp)

.L2:
movb	496(%rsp), %cl
movb	498(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl    	// %bl = bit

leaq    432(%rsp), %rdx
leaq    464(%rsp), %rax
cmpb    $1, %bl
cmove   %rax, %rdx
movq    %rdx, 512(%rsp) 

movq    0(%rdx),  %rcx

// X2
movq    0(%rcx),  %r8
movq    8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15
movq    64(%rcx), %rdi

// copy X2
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi

movq    8(%rdx),  %rcx

// T1 <- X2 + Z2
addq    0(%rcx),  %r8
adcq    8(%rcx),  %r9
adcq    16(%rcx), %r10
adcq    24(%rcx), %r11
adcq    32(%rcx), %r12
adcq    40(%rcx), %r13
adcq    48(%rcx), %r14
adcq    56(%rcx), %r15
adcq    64(%rcx), %rdi

movq    %r8,  520(%rsp)
movq    %r9,  528(%rsp)
movq    %r10, 536(%rsp)
movq    %r11, 544(%rsp)
movq    %r12, 552(%rsp)
movq    %r13, 560(%rsp)
movq    %r14, 568(%rsp)
movq    %r15, 576(%rsp)
movq    %rdi, 584(%rsp)

movq    0(%rdx),  %rcx
movq    32(%rcx), %r8
movq    40(%rcx), %r9
movq    48(%rcx), %r10
movq    56(%rcx), %r11
movq    64(%rcx), %r12

// T2 <- X2 - Z2
addq    _4p0,   %rax
adcq    _4p1_7, %rbx
adcq    _4p1_7, %rbp
adcq    _4p1_7, %rsi
adcq    _4p1_7, %r8
adcq    _4p1_7, %r9
adcq    _4p1_7, %r10
adcq    _4p1_7, %r11
adcq    _4p8,   %r12

movq    8(%rdx),  %rcx
subq    0(%rcx),  %rax
sbbq    8(%rcx),  %rbx
sbbq    16(%rcx), %rbp
sbbq    24(%rcx), %rsi
sbbq    32(%rcx), %r8
sbbq    40(%rcx), %r9
sbbq    48(%rcx), %r10
sbbq    56(%rcx), %r11
sbbq    64(%rcx), %r12

movq    %rax, 592(%rsp)
movq    %rbx, 600(%rsp)
movq    %rbp, 608(%rsp)
movq    %rsi, 616(%rsp)
movq    %r8,  624(%rsp)
movq    %r9,  632(%rsp)
movq    %r10, 640(%rsp)
movq    %r11, 648(%rsp)
movq    %r12, 656(%rsp)

movq    512(%rsp), %rdx
movq    16(%rdx), %rcx

// X2
movq    0(%rcx),  %r8  
movq    8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15
movq    64(%rcx), %rdi

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi

movq    24(%rdx),  %rcx

// T3 <- X3 + Z3
addq    0(%rcx),  %r8
adcq    8(%rcx),  %r9
adcq    16(%rcx), %r10
adcq    24(%rcx), %r11
adcq    32(%rcx), %r12
adcq    40(%rcx), %r13
adcq    48(%rcx), %r14
adcq    56(%rcx), %r15
adcq    64(%rcx), %rdi

movq    %r8,  664(%rsp)
movq    %r9,  672(%rsp)
movq    %r10, 680(%rsp)
movq    %r11, 688(%rsp)
movq    %r12, 696(%rsp)
movq    %r13, 704(%rsp)
movq    %r14, 712(%rsp)
movq    %r15, 720(%rsp)
movq    %rdi, 728(%rsp)

movq    16(%rdx), %rcx
movq    32(%rcx), %r8
movq    40(%rcx), %r9
movq    48(%rcx), %r10
movq    56(%rcx), %r11
movq    64(%rcx), %r12

// T4 <- X3 - Z3
addq    _4p0,   %rax
adcq    _4p1_7, %rbx
adcq    _4p1_7, %rbp
adcq    _4p1_7, %rsi
adcq    _4p1_7, %r8
adcq    _4p1_7, %r9
adcq    _4p1_7, %r10
adcq    _4p1_7, %r11
adcq    _4p8,   %r12

movq    24(%rdx), %rcx
subq    0(%rcx),  %rax
sbbq    8(%rcx),  %rbx
sbbq    16(%rcx), %rbp
sbbq    24(%rcx), %rsi
sbbq    32(%rcx), %r8
sbbq    40(%rcx), %r9
sbbq    48(%rcx), %r10
sbbq    56(%rcx), %r11
sbbq    64(%rcx), %r12

movq    %rax, 736(%rsp)
movq    %rbx, 744(%rsp)
movq    %rbp, 752(%rsp)
movq    %rsi, 760(%rsp)
movq    %r8,  768(%rsp)
movq    %r9,  776(%rsp)
movq    %r10, 784(%rsp)
movq    %r11, 792(%rsp)
movq    %r12, 800(%rsp)

// T5 <- T1^2
xorq    %rdx, %rdx
movq    520(%rsp), %rdx
    
mulx    528(%rsp), %r9, %r10

mulx    536(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    544(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    552(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    560(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    568(%rsp), %rcx, %r15
adcx    %rcx, %r14

mulx    576(%rsp), %rcx, %rax
adcx    %rcx, %r15
    
mulx    584(%rsp), %rcx, %rsi
adcx    %rcx, %rax
adcq    $0, %rsi			

movq    %r9, 952(%rsp)

movq    528(%rsp), %rdx
xorq    %r8, %r8
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcq    $0, %r8

movq    %r10, 960(%rsp)

movq    536(%rsp), %rdx
xorq    %r9, %r9

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
adcq    $0, %r9

movq    %r11, 968(%rsp)

movq    544(%rsp), %rdx
xorq    %r10, %r10

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
adcq    $0, %r10

movq    %r12, 976(%rsp)

movq    552(%rsp), %rdx
xorq    %r11, %r11

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
adcq    $0, %r11

movq    %r13, 984(%rsp)

movq    560(%rsp), %rdx
xorq    %r12, %r12

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcq    $0, %r12			

movq    %r14, 992(%rsp)

movq    568(%rsp), %rdx
xorq    %r13, %r13

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
 
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcq    $0, %r13

movq    576(%rsp), %rdx

mulx    584(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

movq    976(%rsp), %rbp
movq    984(%rsp), %rcx
movq    992(%rsp), %rdx

shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shld    $1, %r8,  %r9
shld    $1, %rsi, %r8
shld    $1, %rax, %rsi
shld    $1, %r15, %rax
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shld    $1, %rbp, %rcx
movq    %rcx, 976(%rsp)
movq    %rdx, 984(%rsp)
movq    %r15, 992(%rsp)
movq    952(%rsp), %rcx
movq    960(%rsp), %rdx
movq    968(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 952(%rsp)		
movq    %rdx, 960(%rsp)		
movq    %r15, 968(%rsp)		
movq    %rbp, 1000(%rsp)
    
xorq    %rdx, %rdx
movq    520(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 1008(%rsp)
movq    952(%rsp), %rax
adcx    %rbp, %rax 

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    960(%rsp), %rcx
adcx    968(%rsp), %rbp
movq    %rcx, 960(%rsp)
movq    %rbp, 968(%rsp)

movq    536(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1000(%rsp), %rcx
adcx    976(%rsp), %rbp
movq    %rcx, 1000(%rsp)
movq    %rbp, 976(%rsp)

movq    544(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    984(%rsp), %rcx
adcx    992(%rsp), %rbp
movq    %rcx, 984(%rsp)
movq    %rbp, 992(%rsp)

movq    552(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1008(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 1008(%rsp)

movq    560(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r8
adcx    %rbp, %r9

movq    568(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r10
adcx    %rbp, %r11

movq    576(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r12
adcx    %rbp, %r13

movq    584(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r14

movq    1008(%rsp), %rcx

shld    $55, %r14, %rbp
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %r9,  %r10
shld    $55, %r8,  %r9
shld    $55, %rsi, %r8
shld    $55, %rcx, %rsi

andq    mask9, %rcx

xorq    %rdx, %rdx
adcx    %rsi, %r15
adcx    %rax, %r8
adcx    960(%rsp), %r9
adcx    968(%rsp), %r10
adcx    1000(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rcx, %rbp
adcx    %rdx, %rdx   			

movq    %rbp, %rcx
andq    mask9, %rbp
shrq    $9, %rcx

addq    %rcx, %r15
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rbp

movq    %r15, 808(%rsp)
movq    %r8,  816(%rsp)
movq    %r9,  824(%rsp)
movq    %r10, 832(%rsp)
movq    %r11, 840(%rsp)
movq    %r12, 848(%rsp)
movq    %r13, 856(%rsp)
movq    %r14, 864(%rsp)
movq    %rbp, 872(%rsp)

// T6 <- T2^2
xorq    %rdx, %rdx
movq    592(%rsp), %rdx
    
mulx    600(%rsp), %r9, %r10

mulx    608(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    616(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    624(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    632(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    640(%rsp), %rcx, %r15
adcx    %rcx, %r14

mulx    648(%rsp), %rcx, %rax
adcx    %rcx, %r15
    
mulx    656(%rsp), %rcx, %rsi
adcx    %rcx, %rax
adcq    $0, %rsi			

movq    %r9, 952(%rsp)

movq    600(%rsp), %rdx
xorq    %r8, %r8
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcq    $0, %r8

movq    %r10, 960(%rsp)

movq    608(%rsp), %rdx
xorq    %r9, %r9

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
adcq    $0, %r9

movq    %r11, 968(%rsp)

movq    616(%rsp), %rdx
xorq    %r10, %r10

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
adcq    $0, %r10

movq    %r12, 976(%rsp)

movq    624(%rsp), %rdx
xorq    %r11, %r11

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
adcq    $0, %r11

movq    %r13, 984(%rsp)

movq    632(%rsp), %rdx
xorq    %r12, %r12

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcq    $0, %r12			

movq    %r14, 992(%rsp)

movq    640(%rsp), %rdx
xorq    %r13, %r13

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
 
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcq    $0, %r13

movq    648(%rsp), %rdx

mulx    656(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

movq    976(%rsp), %rbp
movq    984(%rsp), %rcx
movq    992(%rsp), %rdx

shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shld    $1, %r8,  %r9
shld    $1, %rsi, %r8
shld    $1, %rax, %rsi
shld    $1, %r15, %rax
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shld    $1, %rbp, %rcx
movq    %rcx, 976(%rsp)
movq    %rdx, 984(%rsp)
movq    %r15, 992(%rsp)
movq    952(%rsp), %rcx
movq    960(%rsp), %rdx
movq    968(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 952(%rsp)		
movq    %rdx, 960(%rsp)		
movq    %r15, 968(%rsp)		
movq    %rbp, 1000(%rsp)
    
xorq    %rdx, %rdx
movq    592(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 1008(%rsp)
movq    952(%rsp), %rax
adcx    %rbp, %rax 

movq    600(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    960(%rsp), %rcx
adcx    968(%rsp), %rbp
movq    %rcx, 960(%rsp)
movq    %rbp, 968(%rsp)

movq    608(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1000(%rsp), %rcx
adcx    976(%rsp), %rbp
movq    %rcx, 1000(%rsp)
movq    %rbp, 976(%rsp)

movq    616(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    984(%rsp), %rcx
adcx    992(%rsp), %rbp
movq    %rcx, 984(%rsp)
movq    %rbp, 992(%rsp)

movq    624(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1008(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 1008(%rsp)

movq    632(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r8
adcx    %rbp, %r9

movq    640(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r10
adcx    %rbp, %r11

movq    648(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r12
adcx    %rbp, %r13

movq    656(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r14

movq    1008(%rsp), %rcx

shld    $55, %r14, %rbp
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %r9,  %r10
shld    $55, %r8,  %r9
shld    $55, %rsi, %r8
shld    $55, %rcx, %rsi

andq    mask9, %rcx

xorq    %rdx, %rdx
adcx    %rsi, %r15
adcx    %rax, %r8
adcx    960(%rsp), %r9
adcx    968(%rsp), %r10
adcx    1000(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rcx, %rbp
adcx    %rdx, %rdx   			

movq    %rbp, %rcx
andq    mask9, %rbp
shrq    $9, %rcx

addq    %rcx, %r15
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rbp

movq    %r15, 880(%rsp)
movq    %r8,  888(%rsp)
movq    %r9,  896(%rsp)
movq    %r10, 904(%rsp)
movq    %r11, 912(%rsp)
movq    %r12, 920(%rsp)
movq    %r13, 928(%rsp)
movq    %r14, 936(%rsp)
movq    %rbp, 944(%rsp)

// T2 <- T2 · T3
xorq    %rdx, %rdx
movq    664(%rsp), %rdx    

mulx    592(%rsp), %r8, %r9
mulx    600(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    608(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    616(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    624(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    632(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    640(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    648(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    656(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    672(%rsp), %rdx
   
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    680(%rsp), %rdx
    
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 952(%rsp)

xorq    %r10, %r10
movq    688(%rsp), %rdx
    
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 960(%rsp)

xorq    %r11, %r11
movq    696(%rsp), %rdx
    
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 968(%rsp)

xorq    %r12, %r12
movq    704(%rsp), %rdx
    
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 976(%rsp)

xorq    %r13, %r13
movq    712(%rsp), %rdx
    
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 984(%rsp)

xorq    %r14, %r14
movq    720(%rsp), %rdx
    
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14 	    
   
movq    %r15, 992(%rsp)

xorq    %r15, %r15
movq    728(%rsp), %rdx
    
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
  
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r14   	

shld    $55, %r14, %r15
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %rbx, %r10
shld    $55, %rsi, %rbx
shld    $55, %rdi, %rsi
shld    $55, %rax, %rdi

andq    mask9, %rax

adcx    %r8,          %rdi
adcx    %r9,          %rsi
adcx    952(%rsp),  %rbx
adcx    960(%rsp),  %r10
adcx    968(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rax,         %r15

movq    %r15, %rcx
andq    mask9, %r15
shrq    $9, %rcx

addq    %rdi, %rcx
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r15

movq    %rcx, 592(%rsp)
movq    %rsi, 600(%rsp)
movq    %rbx, 608(%rsp)
movq    %r10, 616(%rsp)
movq    %r11, 624(%rsp)
movq    %r12, 632(%rsp)
movq    %r13, 640(%rsp)
movq    %r14, 648(%rsp)
movq    %r15, 656(%rsp)


// T1 <- T1 · T4
xorq    %rdx, %rdx
movq    736(%rsp), %rdx    

mulx    520(%rsp), %r8, %r9
mulx    528(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    536(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    544(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    552(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    560(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    568(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    576(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    584(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    744(%rsp), %rdx
   
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    752(%rsp), %rdx
    
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 952(%rsp)

xorq    %r10, %r10
movq    760(%rsp), %rdx
    
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 960(%rsp)

xorq    %r11, %r11
movq    768(%rsp), %rdx
    
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 968(%rsp)

xorq    %r12, %r12
movq    776(%rsp), %rdx
    
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 976(%rsp)

xorq    %r13, %r13
movq    784(%rsp), %rdx
    
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 984(%rsp)

xorq    %r14, %r14
movq    792(%rsp), %rdx
    
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14 	    
   
movq    %r15, 992(%rsp)

xorq    %r15, %r15
movq    800(%rsp), %rdx
    
mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
  
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r14   	

shld    $55, %r14, %r15
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %rbx, %r10
shld    $55, %rsi, %rbx
shld    $55, %rdi, %rsi
shld    $55, %rax, %rdi

andq    mask9, %rax

adcx    %r8,          %rdi
adcx    %r9,          %rsi
adcx    952(%rsp),  %rbx
adcx    960(%rsp),  %r10
adcx    968(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rax,         %r15

movq    %r15, %rcx
andq    mask9, %r15
shrq    $9, %rcx

addq    %rdi, %rcx
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r15

movq    %r13, 952(%rsp)
movq    %r14, 960(%rsp)
movq    %r15, 968(%rsp)

// copy T1
movq    %rcx, %r8
movq    %rsi, %r9
movq    %rbx, %rax
movq    %r10, %rdx
movq    %r11, %rbp
movq    %r12, %rdi

// T1 <- T1 + T2
addq    592(%rsp), %rcx
adcq    600(%rsp), %rsi
adcq    608(%rsp), %rbx
adcq    616(%rsp), %r10
adcq    624(%rsp), %r11
adcq    632(%rsp), %r12
adcq    640(%rsp), %r13
adcq    648(%rsp), %r14
adcq    656(%rsp), %r15

movq    %rcx, 520(%rsp) 
movq    %rsi, 528(%rsp)
movq    %rbx, 536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)
movq    %r12, 560(%rsp)
movq    %r13, 568(%rsp)
movq    %r14, 576(%rsp)
movq    %r15, 584(%rsp)

// copy remaining limb values of T1
movq    952(%rsp),  %rcx
movq    960(%rsp),  %rbx
movq    968(%rsp), %rsi

// T2 <- T1 - T2
addq    _4p0,   %r8
adcq    _4p1_7, %r9
adcq    _4p1_7, %rax
adcq    _4p1_7, %rdx
adcq    _4p1_7, %rbp
adcq    _4p1_7, %rdi
adcq    _4p1_7, %rcx
adcq    _4p1_7, %rbx
adcq    _4p8,   %rsi

subq    592(%rsp),  %r8
sbbq    600(%rsp),  %r9
sbbq    608(%rsp), %rax
sbbq    616(%rsp), %rdx
sbbq    624(%rsp), %rbp
sbbq    632(%rsp), %rdi
sbbq    640(%rsp), %rcx
sbbq    648(%rsp), %rbx
sbbq    656(%rsp), %rsi

movq    %r8,  592(%rsp)
movq    %r9,  600(%rsp)
movq    %rax, 608(%rsp)
movq    %rdx, 616(%rsp)
movq    %rbp, 624(%rsp)
movq    %rdi, 632(%rsp)
movq    %rcx, 640(%rsp)
movq    %rbx, 648(%rsp)
movq    %rsi, 656(%rsp)

// X3 <- T1^2
xorq    %rdx, %rdx
movq    520(%rsp), %rdx
    
mulx    528(%rsp), %r9, %r10

mulx    536(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    544(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    552(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    560(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    568(%rsp), %rcx, %r15
adcx    %rcx, %r14

mulx    576(%rsp), %rcx, %rax
adcx    %rcx, %r15
    
mulx    584(%rsp), %rcx, %rsi
adcx    %rcx, %rax
adcq    $0, %rsi			

movq    %r9, 952(%rsp)

movq    528(%rsp), %rdx
xorq    %r8, %r8
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcq    $0, %r8

movq    %r10, 960(%rsp)

movq    536(%rsp), %rdx
xorq    %r9, %r9

mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
adcq    $0, %r9

movq    %r11, 968(%rsp)

movq    544(%rsp), %rdx
xorq    %r10, %r10

mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
adcq    $0, %r10

movq    %r12, 976(%rsp)

movq    552(%rsp), %rdx
xorq    %r11, %r11

mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
adcq    $0, %r11

movq    %r13, 984(%rsp)

movq    560(%rsp), %rdx
xorq    %r12, %r12

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcq    $0, %r12			

movq    %r14, 992(%rsp)

movq    568(%rsp), %rdx
xorq    %r13, %r13

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
 
mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcq    $0, %r13

movq    576(%rsp), %rdx

mulx    584(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

movq    976(%rsp), %rbp
movq    984(%rsp), %rcx
movq    992(%rsp), %rdx

shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shld    $1, %r8,  %r9
shld    $1, %rsi, %r8
shld    $1, %rax, %rsi
shld    $1, %r15, %rax
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shld    $1, %rbp, %rcx
movq    %rcx, 976(%rsp)
movq    %rdx, 984(%rsp)
movq    %r15, 992(%rsp)
movq    952(%rsp), %rcx
movq    960(%rsp), %rdx
movq    968(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 952(%rsp)		
movq    %rdx, 960(%rsp)		
movq    %r15, 968(%rsp)		
movq    %rbp, 1000(%rsp)
    
xorq    %rdx, %rdx
movq    520(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 1008(%rsp)
movq    952(%rsp), %rax
adcx    %rbp, %rax 

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    960(%rsp), %rcx
adcx    968(%rsp), %rbp
movq    %rcx, 960(%rsp)
movq    %rbp, 968(%rsp)

movq    536(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1000(%rsp), %rcx
adcx    976(%rsp), %rbp
movq    %rcx, 1000(%rsp)
movq    %rbp, 976(%rsp)

movq    544(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    984(%rsp), %rcx
adcx    992(%rsp), %rbp
movq    %rcx, 984(%rsp)
movq    %rbp, 992(%rsp)

movq    552(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1008(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 1008(%rsp)

movq    560(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r8
adcx    %rbp, %r9

movq    568(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r10
adcx    %rbp, %r11

movq    576(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r12
adcx    %rbp, %r13

movq    584(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r14

movq    1008(%rsp), %rcx

shld    $55, %r14, %rbp
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %r9,  %r10
shld    $55, %r8,  %r9
shld    $55, %rsi, %r8
shld    $55, %rcx, %rsi

andq    mask9, %rcx

xorq    %rdx, %rdx
adcx    %rsi, %r15
adcx    %rax, %r8
adcx    960(%rsp), %r9
adcx    968(%rsp), %r10
adcx    1000(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rcx, %rbp
adcx    %rdx, %rdx   			

movq    %rbp, %rcx
andq    mask9, %rbp
shrq    $9, %rcx

addq    %rcx, %r15
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rbp

movq    512(%rsp), %rdx
movq    16(%rdx), %rcx

movq    %r15,  0(%rcx) // update X3
movq    %r8,   8(%rcx)
movq    %r9,  16(%rcx)
movq    %r10, 24(%rcx)
movq    %r11, 32(%rcx)
movq    %r12, 40(%rcx)
movq    %r13, 48(%rcx)
movq    %r14, 56(%rcx)
movq    %rbp, 64(%rcx)


// T2 <- T2^2
xorq    %rdx, %rdx
movq    592(%rsp), %rdx
    
mulx    600(%rsp), %r9, %r10

mulx    608(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    616(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    624(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    632(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    640(%rsp), %rcx, %r15
adcx    %rcx, %r14

mulx    648(%rsp), %rcx, %rax
adcx    %rcx, %r15
    
mulx    656(%rsp), %rcx, %rsi
adcx    %rcx, %rax
adcq    $0, %rsi			

movq    %r9, 952(%rsp)

movq    600(%rsp), %rdx
xorq    %r8, %r8
    
mulx    608(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcq    $0, %r8

movq    %r10, 960(%rsp)

movq    608(%rsp), %rdx
xorq    %r9, %r9

mulx    616(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
adcq    $0, %r9

movq    %r11, 968(%rsp)

movq    616(%rsp), %rdx
xorq    %r10, %r10

mulx    624(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
adcq    $0, %r10

movq    %r12, 976(%rsp)

movq    624(%rsp), %rdx
xorq    %r11, %r11

mulx    632(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
adcq    $0, %r11

movq    %r13, 984(%rsp)

movq    632(%rsp), %rdx
xorq    %r12, %r12

mulx    640(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcq    $0, %r12			

movq    %r14, 992(%rsp)

movq    640(%rsp), %rdx
xorq    %r13, %r13

mulx    648(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
 
mulx    656(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcq    $0, %r13

movq    648(%rsp), %rdx

mulx    656(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

movq    976(%rsp), %rbp
movq    984(%rsp), %rcx
movq    992(%rsp), %rdx

shld    $1, %r13, %r14
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %r10, %r11
shld    $1, %r9,  %r10
shld    $1, %r8,  %r9
shld    $1, %rsi, %r8
shld    $1, %rax, %rsi
shld    $1, %r15, %rax
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shld    $1, %rbp, %rcx
movq    %rcx, 976(%rsp)
movq    %rdx, 984(%rsp)
movq    %r15, 992(%rsp)
movq    952(%rsp), %rcx
movq    960(%rsp), %rdx
movq    968(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 952(%rsp)		
movq    %rdx, 960(%rsp)		
movq    %r15, 968(%rsp)		
movq    %rbp, 1000(%rsp)
    
xorq    %rdx, %rdx
movq    592(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 1008(%rsp)
movq    952(%rsp), %rax
adcx    %rbp, %rax 

movq    600(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    960(%rsp), %rcx
adcx    968(%rsp), %rbp
movq    %rcx, 960(%rsp)
movq    %rbp, 968(%rsp)

movq    608(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1000(%rsp), %rcx
adcx    976(%rsp), %rbp
movq    %rcx, 1000(%rsp)
movq    %rbp, 976(%rsp)

movq    616(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    984(%rsp), %rcx
adcx    992(%rsp), %rbp
movq    %rcx, 984(%rsp)
movq    %rbp, 992(%rsp)

movq    624(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    1008(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 1008(%rsp)

movq    632(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r8
adcx    %rbp, %r9

movq    640(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r10
adcx    %rbp, %r11

movq    648(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r12
adcx    %rbp, %r13

movq    656(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r14

movq    1008(%rsp), %rcx

shld    $55, %r14, %rbp
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %r9,  %r10
shld    $55, %r8,  %r9
shld    $55, %rsi, %r8
shld    $55, %rcx, %rsi

andq    mask9, %rcx

xorq    %rdx, %rdx
adcx    %rsi, %r15
adcx    %rax, %r8
adcx    960(%rsp), %r9
adcx    968(%rsp), %r10
adcx    1000(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rcx, %rbp
adcx    %rdx, %rdx   			

movq    %rbp, %rcx
andq    mask9, %rbp
shrq    $9, %rcx

addq    %rcx, %r15
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %rbp

movq    %r15, 592(%rsp)
movq    %r8,  600(%rsp)
movq    %r9,  608(%rsp)
movq    %r10, 616(%rsp)
movq    %r11, 624(%rsp)
movq    %r12, 632(%rsp)
movq    %r13, 640(%rsp)
movq    %r14, 648(%rsp)
movq    %rbp, 656(%rsp)

// Z3 <- T2 · X1
xorq    %rdx, %rdx
movq    592(%rsp), %rdx    

mulx    72(%rsp), %r8, %r9
mulx    80(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    88(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    96(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    104(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    112(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    120(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    128(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    136(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    600(%rsp), %rdx
   
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    608(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 952(%rsp)

xorq    %r10, %r10
movq    616(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 960(%rsp)

xorq    %r11, %r11
movq    624(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 968(%rsp)

xorq    %r12, %r12
movq    632(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 976(%rsp)

xorq    %r13, %r13
movq    640(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 984(%rsp)

xorq    %r14, %r14
movq    648(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14 	    
   
movq    %r15, 992(%rsp)

xorq    %r15, %r15
movq    656(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    96(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    104(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    112(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
  
mulx    136(%rsp), %rcx, %rbp
adcx    %rcx, %r14   	

shld    $55, %r14, %r15
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %rbx, %r10
shld    $55, %rsi, %rbx
shld    $55, %rdi, %rsi
shld    $55, %rax, %rdi

andq    mask9, %rax

adcx    %r8, %rdi
adcx    %r9, %rsi
adcx    952(%rsp),  %rbx
adcx    960(%rsp),  %r10
adcx    968(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rax, %r15

movq    %r15, %rcx
andq    mask9, %r15
shrq    $9, %rcx

addq    %rcx, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r15

movq    512(%rsp), %rdx
movq    24(%rdx), %rcx

movq    %rdi,  0(%rcx) // update Z3
movq    %rsi,  8(%rcx)
movq    %rbx, 16(%rcx)
movq    %r10, 24(%rcx)
movq    %r11, 32(%rcx)
movq    %r12, 40(%rcx)
movq    %r13, 48(%rcx)
movq    %r14, 56(%rcx)
movq    %r15, 64(%rcx)


// X2 <- T5 · T6
xorq    %rdx, %rdx
movq    880(%rsp), %rdx    

mulx    808(%rsp), %r8, %r9
mulx    816(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    824(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    832(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    840(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    848(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    856(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    864(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    872(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    888(%rsp), %rdx
   
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    896(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 952(%rsp)

xorq    %r10, %r10
movq    904(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 960(%rsp)

xorq    %r11, %r11
movq    912(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 968(%rsp)

xorq    %r12, %r12
movq    920(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 976(%rsp)

xorq    %r13, %r13
movq    928(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 984(%rsp)

xorq    %r14, %r14
movq    936(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14 	    
   
movq    %r15, 992(%rsp)

xorq    %r15, %r15
movq    944(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
  
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r14   	

shld    $55, %r14, %r15
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %rbx, %r10
shld    $55, %rsi, %rbx
shld    $55, %rdi, %rsi
shld    $55, %rax, %rdi

andq    mask9, %rax

adcx    %r8, %rdi
adcx    %r9, %rsi
adcx    952(%rsp),  %rbx
adcx    960(%rsp),  %r10
adcx    968(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rax, %r15

movq    %r15, %rcx
andq    mask9, %r15
shrq    $9, %rcx

addq    %rcx, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r15

movq    512(%rsp), %rdx
movq    0(%rdx), %rcx

movq    %rdi,  0(%rcx) // update X2
movq    %rsi,  8(%rcx)
movq    %rbx, 16(%rcx)
movq    %r10, 24(%rcx)
movq    %r11, 32(%rcx)
movq    %r12, 40(%rcx)
movq    %r13, 48(%rcx)
movq    %r14, 56(%rcx)
movq    %r15, 64(%rcx)

// T5 <- T5 - T6
movq    808(%rsp),  %r8
movq    816(%rsp),  %r9
movq    824(%rsp), %r10
movq    832(%rsp), %r11 
movq    840(%rsp), %r12
movq    848(%rsp), %r13
movq    856(%rsp), %r14
movq    864(%rsp), %r15
movq    872(%rsp), %rax

addq    _4p0,    %r8
adcq    _4p1_7,  %r9
adcq    _4p1_7, %r10
adcq    _4p1_7, %r11
adcq    _4p1_7, %r12
adcq    _4p1_7, %r13
adcq    _4p1_7, %r14
adcq    _4p1_7, %r15
adcq    _4p8,   %rax

subq    880(%rsp),  %r8
sbbq    888(%rsp),  %r9
sbbq    896(%rsp), %r10
sbbq    904(%rsp), %r11
sbbq    912(%rsp), %r12
sbbq    920(%rsp), %r13
sbbq    928(%rsp), %r14
sbbq    936(%rsp), %r15
sbbq    944(%rsp), %rax

movq    %r8,  808(%rsp) 
movq    %r9,  816(%rsp)
movq    %r10, 824(%rsp)
movq    %r11, 832(%rsp)
movq    %r12, 840(%rsp)
movq    %r13, 848(%rsp)
movq    %r14, 856(%rsp)
movq    %r15, 864(%rsp)
movq    %rax, 872(%rsp)


// T1 <- ((A + 2)/4) · T5
xorq    %rdx, %rdx
movq    a24, %rdx

mulx    %r8, %rsi, %rdi
mulx    %r9, %rcx, %rbp
adcx    %rcx, %rdi

mulx    %r10, %rcx, %r8
adcx    %rcx, %rbp

mulx    %r11, %rcx, %r9
adcx    %rcx, %r8

mulx    %r12, %rcx, %r10
adcx    %rcx, %r9

mulx    %r13, %rcx, %r11
adcx    %rcx, %r10

mulx    %r14, %rcx, %r12
adcx    %rcx, %r11

mulx    %r15, %rcx, %r13
adcx    %rcx, %r12

mulx    %rax, %rcx, %r14
adcx    %rcx, %r13
adcq    $0,   %r14

shld    $55, %r13, %r14
andq    mask9, %r13

addq    %r14, %rsi
adcq    $0, %rdi
adcq    $0, %rbp
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

// T6 <- T6 + T1
addq    880(%rsp), %rsi
adcq    888(%rsp), %rdi
adcq    896(%rsp), %rbp
adcq    904(%rsp),  %r8
adcq    912(%rsp),  %r9
adcq    920(%rsp), %r10
adcq    928(%rsp), %r11
adcq    936(%rsp), %r12
adcq    944(%rsp), %r13

movq    %rsi, 880(%rsp) 
movq    %rdi, 888(%rsp)
movq    %rbp, 896(%rsp)
movq    %r8,  904(%rsp)
movq    %r9,  912(%rsp)
movq    %r10, 920(%rsp)
movq    %r11, 928(%rsp)
movq    %r12, 936(%rsp)
movq    %r13, 944(%rsp)

// Z2 <- T5 · T6
xorq    %rdx, %rdx
movq    880(%rsp), %rdx    

mulx    808(%rsp), %r8, %r9
mulx    816(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    824(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    832(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    840(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    848(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    856(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    864(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    872(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    888(%rsp), %rdx
   
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    896(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 952(%rsp)

xorq    %r10, %r10
movq    904(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 960(%rsp)

xorq    %r11, %r11
movq    912(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 968(%rsp)

xorq    %r12, %r12
movq    920(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 976(%rsp)

xorq    %r13, %r13
movq    928(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 984(%rsp)

xorq    %r14, %r14
movq    936(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14 	    
   
movq    %r15, 992(%rsp)

xorq    %r15, %r15
movq    944(%rsp), %rdx
    
mulx    808(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    816(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    824(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    832(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    840(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    848(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    856(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    864(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
  
mulx    872(%rsp), %rcx, %rbp
adcx    %rcx, %r14   	

shld    $55, %r14, %r15
shld    $55, %r13, %r14
shld    $55, %r12, %r13
shld    $55, %r11, %r12
shld    $55, %r10, %r11
shld    $55, %rbx, %r10
shld    $55, %rsi, %rbx
shld    $55, %rdi, %rsi
shld    $55, %rax, %rdi

andq    mask9, %rax

adcx    %r8, %rdi
adcx    %r9, %rsi
adcx    952(%rsp),  %rbx
adcx    960(%rsp),  %r10
adcx    968(%rsp), %r11
adcx    976(%rsp), %r12
adcx    984(%rsp), %r13
adcx    992(%rsp), %r14
adcx    %rax, %r15

movq    %r15, %rcx
andq    mask9, %r15
shrq    $9, %rcx

addq    %rcx, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13
adcq    $0, %r14
adcq    $0, %r15

movq    512(%rsp), %rdx
movq    8(%rdx), %rcx

movq    %rdi,  0(%rcx) // update Z2
movq    %rsi,  8(%rcx)
movq    %rbx, 16(%rcx)
movq    %r10, 24(%rcx)
movq    %r11, 32(%rcx)
movq    %r12, 40(%rcx)
movq    %r13, 48(%rcx)
movq    %r14, 56(%rcx)
movq    %r15, 64(%rcx)

movb    496(%rsp), %cl
subb    $1, %cl
movb    %cl, 496(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 496(%rsp)
movq    64(%rsp), %rax
movq    504(%rsp), %r15
subq    $1, %r15
movq    %r15, 504(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    512(%rsp), %rdx
movq    0(%rdx), %rcx

movq     0(%rcx),  %r8 
movq     8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15
movq    64(%rcx), %rax

movq    %r8,   0(%rdi) // final value of X2
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)
movq    %r15, 56(%rdi)
movq    %rax, 64(%rdi)

movq    8(%rdx), %rcx

movq     0(%rcx),  %r8 
movq     8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15
movq    64(%rcx), %rax

movq    %r8,  72(%rdi) // final value of Z2
movq    %r9,  80(%rdi)
movq    %r10, 88(%rdi)
movq    %r11, 96(%rdi)
movq    %r12, 104(%rdi)
movq    %r13, 112(%rdi)
movq    %r14, 120(%rdi)
movq    %r15, 128(%rdi)
movq    %rax, 136(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
