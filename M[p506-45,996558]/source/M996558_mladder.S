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
.globl M996558_mladder
M996558_mladder:

movq 	%rsp, %r11
subq 	$904, %rsp

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
movq	%r8, 264(%rsp)
movq	8(%rsi), %r8
movq	%r8, 80(%rsp)
movq	%r8, 272(%rsp)
movq	16(%rsi), %r8
movq	%r8, 88(%rsp)
movq	%r8, 280(%rsp)
movq	24(%rsi), %r8
movq	%r8, 96(%rsp)
movq	%r8, 288(%rsp)
movq	32(%rsi), %r8
movq	%r8, 104(%rsp)
movq	%r8, 296(%rsp)
movq	40(%rsi), %r8
movq	%r8, 112(%rsp)
movq	%r8, 304(%rsp)
movq	48(%rsi), %r8
movq	%r8, 120(%rsp)
movq	%r8, 312(%rsp)
movq	56(%rsi), %r8
movq	%r8, 128(%rsp)
movq	%r8, 320(%rsp) // X1 = XP, X3 = XP

movq	$1, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)  // X2 = 1

movq	$0, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)
movq	$0, 240(%rsp)
movq	$0, 248(%rsp)
movq	$0, 256(%rsp)  // Z2 = 0

movq	$1, 328(%rsp)
movq	$0, 336(%rsp)
movq	$0, 344(%rsp)
movq	$0, 352(%rsp)
movq	$0, 360(%rsp)
movq	$0, 368(%rsp)
movq	$0, 376(%rsp)
movq	$0, 384(%rsp) // Z3 = 1

// X1: rsp(72)-rsp(128),  
// X2: rsp(136)-rsp(192), Z2: rsp(200)-rsp(256),  
// X3: rsp(264)-rsp(320), Z3: rsp(328)-rsp(384).

leaq	136(%rsp), %r11  // &X2
leaq	200(%rsp), %r12  // &Z2
leaq	264(%rsp), %r13  // &X3
leaq	328(%rsp), %r14  // &Z3

movq	%r11, 392(%rsp)  // &X2
movq	%r12, 400(%rsp)  // &Z2
movq	%r13, 408(%rsp)  // &X3
movq	%r14, 416(%rsp)  // &Z3

movq	%r13, 424(%rsp)  // &X3
movq	%r14, 432(%rsp)  // &Z3
movq	%r11, 440(%rsp)  // &X2
movq	%r12, 448(%rsp)  // &Z2

// r15 = i, rcx = j
movq    $63, 464(%rsp) // r15
movb	$1, 456(%rsp)  // cl
movq    %rdx, 64(%rsp)

movq    %rdx,%rax  	// rax = &n[0]

// Montgomery ladder loop

.L1:
addq    464(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 458(%rsp)

.L2:
movb	456(%rsp), %cl
movb	458(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl    	// %bl = bit

leaq    392(%rsp), %rdx
leaq    424(%rsp), %rax
cmpb    $1, %bl
cmove   %rax, %rdx
movq    %rdx, 472(%rsp)

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

// X2
movq    0(%rdx), %rcx

movq    0(%rcx),   %r8
movq    8(%rcx),   %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi

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

movq    %r8,  480(%rsp)
movq    %r9,  488(%rsp)
movq    %r10, 496(%rsp)
movq    %r11, 504(%rsp)
movq    %r12, 512(%rsp)
movq    %r13, 520(%rsp)
movq    %r14, 528(%rsp)
movq    %r15, 536(%rsp)

movq    0(%rdx),  %rcx
movq    40(%rcx), %r8
movq    48(%rcx), %r9
movq    56(%rcx), %r10

// T2 <- X2 - Z2
addq    _4p0,   %rax
adcq    _4p1_6, %rbx
adcq    _4p1_6, %rbp
adcq    _4p1_6, %rsi
adcq    _4p1_6, %rdi
adcq    _4p1_6, %r8
adcq    _4p1_6, %r9
adcq    _4p7,   %r10

movq    8(%rdx),  %rcx
subq    0(%rcx),  %rax
sbbq    8(%rcx),  %rbx
sbbq    16(%rcx), %rbp
sbbq    24(%rcx), %rsi
sbbq    32(%rcx), %rdi
sbbq    40(%rcx), %r8
sbbq    48(%rcx), %r9
sbbq    56(%rcx), %r10

movq    %rax, 544(%rsp)
movq    %rbx, 552(%rsp)
movq    %rbp, 560(%rsp)
movq    %rsi, 568(%rsp)
movq    %rdi, 576(%rsp)
movq    %r8,  584(%rsp)
movq    %r9,  592(%rsp)
movq    %r10, 600(%rsp)

movq    472(%rsp), %rdx
movq    16(%rdx), %rcx

// X3
movq    0(%rcx),   %r8
movq    8(%rcx),   %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi

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

movq    %r8,  608(%rsp)
movq    %r9,  616(%rsp)
movq    %r10, 624(%rsp)
movq    %r11, 632(%rsp)
movq    %r12, 640(%rsp)
movq    %r13, 648(%rsp)
movq    %r14, 656(%rsp)
movq    %r15, 664(%rsp)

movq    16(%rdx), %rcx
movq    40(%rcx), %r8
movq    48(%rcx), %r9
movq    56(%rcx), %r10

// T4 <- X3 - Z3
addq    _4p0,   %rax
adcq    _4p1_6, %rbx
adcq    _4p1_6, %rbp
adcq    _4p1_6, %rsi
adcq    _4p1_6, %rdi
adcq    _4p1_6, %r8
adcq    _4p1_6, %r9
adcq    _4p7,   %r10

movq    24(%rdx), %rcx
subq    0(%rcx),  %rax
sbbq    8(%rcx),  %rbx
sbbq    16(%rcx), %rbp
sbbq    24(%rcx), %rsi
sbbq    32(%rcx), %rdi
sbbq    40(%rcx), %r8
sbbq    48(%rcx), %r9
sbbq    56(%rcx), %r10

movq    %rax, 672(%rsp)
movq    %rbx, 680(%rsp)
movq    %rbp, 688(%rsp)
movq    %rsi, 696(%rsp)
movq    %rdi, 704(%rsp)
movq    %r8,  712(%rsp)
movq    %r9,  720(%rsp)
movq    %r10, 728(%rsp)

// T5 <- T1^2
movq    480(%rsp), %rdx
xorq    %r8, %r8
    
mulx    488(%rsp), %r9, %r10

mulx    496(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    504(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    512(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    520(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    528(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    536(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    488(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    496(%rsp), %rdx
xorq    %rbx, %rbx

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 864(%rsp)

movq    504(%rsp), %rdx
xorq    %r11, %r11

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 872(%rsp)

movq    512(%rsp), %rdx
xorq    %r12, %r12

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 880(%rsp)

movq    520(%rsp), %rdx
xorq    %r13, %r13

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    528(%rsp), %rdx
 
mulx    536(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    864(%rsp), %rax
movq    872(%rsp), %rcx
movq    880(%rsp), %rdx

movq    $0, %rbp
shld    $1, %r13, %rbp
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %rsi, %r8
shld    $1, %r15, %rsi
shld    $1, %r14, %r15
shld    $1, %rdx, %r14
shld    $1, %rcx, %rdx
shld    $1, %rax, %rcx
shld    $1, %r10, %rax
shld    $1, %r9, %r10
shlq    $1, %r9

movq    %rdx, 864(%rsp)
movq    %rcx, 872(%rsp)
movq    %rax, 880(%rsp)
movq    %r10, 888(%rsp)
    
xorq    %rdx, %rdx
movq    480(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    488(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    888(%rsp), %rcx
adcx    880(%rsp), %rax
movq    %rcx, 888(%rsp)
movq    %rax, 880(%rsp)

movq    496(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    872(%rsp), %rcx
adcx    864(%rsp), %rax
movq    %rcx, 872(%rsp)
movq    %rax, 864(%rsp)

movq    504(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    512(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    520(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    536(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rsi, %rax, %rsi 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %rsi     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %rbp, %rcx, %rbp
adcx    %rcx, %r13
adcq    $0, %rbp

xorq    %rcx, %rcx
adcx    %rax, %r10
adcx    %rsi, %r9
adcx    888(%rsp), %r8
adcx    880(%rsp), %rdi
adcx    872(%rsp), %rbx
adcx    864(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $6, %r13, %rbp
andq    mask58, %r13

imul    $45, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %r10, 736(%rsp)
movq    %r9,  744(%rsp)
movq    %r8,  752(%rsp)
movq    %rdi, 760(%rsp)
movq    %rbx, 768(%rsp)
movq    %r11, 776(%rsp)
movq    %r12, 784(%rsp)
movq    %r13, 792(%rsp)

// T6 <- T2^2
movq    544(%rsp), %rdx
xorq    %r8, %r8
    
mulx    552(%rsp), %r9, %r10

mulx    560(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    568(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    576(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    584(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    592(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    600(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    552(%rsp), %rdx
xorq    %rdi, %rdi
    
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
adox    %rbp, %r15

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    560(%rsp), %rdx
xorq    %rbx, %rbx

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 864(%rsp)

movq    568(%rsp), %rdx
xorq    %r11, %r11

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 872(%rsp)

movq    576(%rsp), %rdx
xorq    %r12, %r12

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 880(%rsp)

movq    584(%rsp), %rdx
xorq    %r13, %r13

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    592(%rsp), %rdx
 
mulx    600(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    864(%rsp), %rax
movq    872(%rsp), %rcx
movq    880(%rsp), %rdx

movq    $0, %rbp
shld    $1, %r13, %rbp
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %rsi, %r8
shld    $1, %r15, %rsi
shld    $1, %r14, %r15
shld    $1, %rdx, %r14
shld    $1, %rcx, %rdx
shld    $1, %rax, %rcx
shld    $1, %r10, %rax
shld    $1, %r9, %r10
shlq    $1, %r9

movq    %rdx, 864(%rsp)
movq    %rcx, 872(%rsp)
movq    %rax, 880(%rsp)
movq    %r10, 888(%rsp)
    
xorq    %rdx, %rdx
movq    544(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    552(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    888(%rsp), %rcx
adcx    880(%rsp), %rax
movq    %rcx, 888(%rsp)
movq    %rax, 880(%rsp)

movq    560(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    872(%rsp), %rcx
adcx    864(%rsp), %rax
movq    %rcx, 872(%rsp)
movq    %rax, 864(%rsp)

movq    568(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    576(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    584(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    592(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    600(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rsi, %rax, %rsi 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %rsi     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %rbp, %rcx, %rbp
adcx    %rcx, %r13
adcq    $0, %rbp

xorq    %rcx, %rcx
adcx    %rax, %r10
adcx    %rsi, %r9
adcx    888(%rsp), %r8
adcx    880(%rsp), %rdi
adcx    872(%rsp), %rbx
adcx    864(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $6, %r13, %rbp
andq    mask58, %r13

imul    $45, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %r10, 800(%rsp)
movq    %r9,  808(%rsp)
movq    %r8,  816(%rsp)
movq    %rdi, 824(%rsp)
movq    %rbx, 832(%rsp)
movq    %r11, 840(%rsp)
movq    %r12, 848(%rsp)
movq    %r13, 856(%rsp)

// T2 <- T2 · T3
movq    608(%rsp), %rdx    
xorq    %r8, %r8

mulx    544(%rsp), %r8, %r9
mulx    552(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    560(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    568(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    576(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    584(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    592(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    600(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    616(%rsp), %rdx
   
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r9
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
adox    %rbp, %r15

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    624(%rsp), %rdx
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 864(%rsp)

xorq    %r10, %r10
movq    632(%rsp), %rdx
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 872(%rsp)

xorq    %r11, %r11
movq    640(%rsp), %rdx
    
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
adox    %rbp, %rdi

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 880(%rsp)

xorq    %r12, %r12
movq    648(%rsp), %rdx
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    560(%rsp), %rcx, %rbp
adcx    %rcx, %r15
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

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 888(%rsp)

xorq    %r13, %r13
movq    656(%rsp), %rdx
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    552(%rsp), %rcx, %rbp
adcx    %rcx, %r15
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

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 896(%rsp)

xorq    %r14, %r14
movq    664(%rsp), %rdx
    
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %r15
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

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rdi, %rax, %rdi

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %rdi     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %r14, %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

addq    %r8, %rax
adcq    %r9, %rdi
adcq    864(%rsp), %rsi
adcq    872(%rsp), %rbx
adcq    880(%rsp), %r10
adcq    888(%rsp), %r11
adcq    896(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $6, %r13, %r14
andq    mask58, %r13

imul    $45, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %rax, 544(%rsp)
movq    %rdi, 552(%rsp)
movq    %rsi, 560(%rsp)
movq    %rbx, 568(%rsp)
movq    %r10, 576(%rsp)
movq    %r11, 584(%rsp)
movq    %r12, 592(%rsp)
movq    %r13, 600(%rsp)

// T1 <- T1 · T4
movq    672(%rsp), %rdx    
xorq    %r8, %r8

mulx    480(%rsp), %r8, %r9
mulx    488(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    496(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    504(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    512(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    520(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    528(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    536(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    680(%rsp), %rdx
   
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    688(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 864(%rsp)

xorq    %r10, %r10
movq    696(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 872(%rsp)

xorq    %r11, %r11
movq    704(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 880(%rsp)

xorq    %r12, %r12
movq    712(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 888(%rsp)

xorq    %r13, %r13
movq    720(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 896(%rsp)

xorq    %r14, %r14
movq    728(%rsp), %rdx
    
mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rdi, %rax, %rdi

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %rdi     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %r14, %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

addq    %r8, %rax
adcq    %r9, %rdi
adcq    864(%rsp), %rsi
adcq    872(%rsp), %rbx
adcq    880(%rsp), %r10
adcq    888(%rsp), %r11
adcq    896(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $6, %r13, %r14
andq    mask58, %r13

imul    $45, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %r13, 864(%rsp)

// copy T1
movq    %rax, %r8
movq    %rdi, %r9
movq    %rsi, %r14
movq    %rbx, %r15
movq    %r10, %rdx
movq    %r11, %rcx
movq    %r12, %rbp

// T1 <- T1 + T2
addq    544(%rsp), %rax
adcq    552(%rsp), %rdi
adcq    560(%rsp), %rsi
adcq    568(%rsp), %rbx
adcq    576(%rsp), %r10
adcq    584(%rsp), %r11
adcq    592(%rsp), %r12
adcq    600(%rsp), %r13

movq    %rax, 480(%rsp)
movq    %rdi, 488(%rsp)
movq    %rsi, 496(%rsp)
movq    %rbx, 504(%rsp)
movq    %r10, 512(%rsp)
movq    %r11, 520(%rsp)
movq    %r12, 528(%rsp)
movq    %r13, 536(%rsp)

// copy the last limb value of T1
movq    864(%rsp), %rax

// T2 <- T1 - T2
addq    _4p0,   %r8
adcq    _4p1_6, %r9
adcq    _4p1_6, %r14
adcq    _4p1_6, %r15
adcq    _4p1_6, %rdx
adcq    _4p1_6, %rcx
adcq    _4p1_6, %rbp
adcq    _4p7,   %rax

subq    544(%rsp),  %r8
sbbq    552(%rsp),  %r9
sbbq    560(%rsp), %r14
sbbq    568(%rsp), %r15
sbbq    576(%rsp), %rdx
sbbq    584(%rsp), %rcx
sbbq    592(%rsp), %rbp
sbbq    600(%rsp), %rax

movq    %r8,  544(%rsp) 
movq    %r9,  552(%rsp)
movq    %r14, 560(%rsp)
movq    %r15, 568(%rsp)
movq    %rdx, 576(%rsp)
movq    %rcx, 584(%rsp)
movq    %rbp, 592(%rsp)
movq    %rax, 600(%rsp)

// X3 <- T1^2
movq    480(%rsp), %rdx
xorq    %r8, %r8
    
mulx    488(%rsp), %r9, %r10

mulx    496(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    504(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    512(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    520(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    528(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    536(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    488(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    496(%rsp), %rdx
xorq    %rbx, %rbx

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 864(%rsp)

movq    504(%rsp), %rdx
xorq    %r11, %r11

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 872(%rsp)

movq    512(%rsp), %rdx
xorq    %r12, %r12

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 880(%rsp)

movq    520(%rsp), %rdx
xorq    %r13, %r13

mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    528(%rsp), %rdx
 
mulx    536(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    864(%rsp), %rax
movq    872(%rsp), %rcx
movq    880(%rsp), %rdx

movq    $0, %rbp
shld    $1, %r13, %rbp
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %rsi, %r8
shld    $1, %r15, %rsi
shld    $1, %r14, %r15
shld    $1, %rdx, %r14
shld    $1, %rcx, %rdx
shld    $1, %rax, %rcx
shld    $1, %r10, %rax
shld    $1, %r9, %r10
shlq    $1, %r9

movq    %rdx, 864(%rsp)
movq    %rcx, 872(%rsp)
movq    %rax, 880(%rsp)
movq    %r10, 888(%rsp)
    
xorq    %rdx, %rdx
movq    480(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    488(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    888(%rsp), %rcx
adcx    880(%rsp), %rax
movq    %rcx, 888(%rsp)
movq    %rax, 880(%rsp)

movq    496(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    872(%rsp), %rcx
adcx    864(%rsp), %rax
movq    %rcx, 872(%rsp)
movq    %rax, 864(%rsp)

movq    504(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    512(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    520(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    536(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rsi, %rax, %rsi 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %rsi     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %rbp, %rcx, %rbp
adcx    %rcx, %r13
adcq    $0, %rbp

xorq    %rcx, %rcx
adcx    %rax, %r10
adcx    %rsi, %r9
adcx    888(%rsp), %r8
adcx    880(%rsp), %rdi
adcx    872(%rsp), %rbx
adcx    864(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $6, %r13, %rbp
andq    mask58, %r13

imul    $45, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    472(%rsp), %rdx
movq    16(%rdx), %rcx

movq    %r10,  0(%rcx) // update X3
movq    %r9,   8(%rcx)
movq    %r8,  16(%rcx)
movq    %rdi, 24(%rcx)
movq    %rbx, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r12, 48(%rcx)
movq    %r13, 56(%rcx)


// T2 <- T2^2
movq    544(%rsp), %rdx
xorq    %r8, %r8
    
mulx    552(%rsp), %r9, %r10

mulx    560(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    568(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    576(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    584(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    592(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    600(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    552(%rsp), %rdx
xorq    %rdi, %rdi
    
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
adox    %rbp, %r15

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    560(%rsp), %rdx
xorq    %rbx, %rbx

mulx    568(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 864(%rsp)

movq    568(%rsp), %rdx
xorq    %r11, %r11

mulx    576(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 872(%rsp)

movq    576(%rsp), %rdx
xorq    %r12, %r12

mulx    584(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 880(%rsp)

movq    584(%rsp), %rdx
xorq    %r13, %r13

mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    592(%rsp), %rdx
 
mulx    600(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    864(%rsp), %rax
movq    872(%rsp), %rcx
movq    880(%rsp), %rdx

movq    $0, %rbp
shld    $1, %r13, %rbp
shld    $1, %r12, %r13
shld    $1, %r11, %r12
shld    $1, %rbx, %r11
shld    $1, %rdi, %rbx
shld    $1, %r8,  %rdi
shld    $1, %rsi, %r8
shld    $1, %r15, %rsi
shld    $1, %r14, %r15
shld    $1, %rdx, %r14
shld    $1, %rcx, %rdx
shld    $1, %rax, %rcx
shld    $1, %r10, %rax
shld    $1, %r9, %r10
shlq    $1, %r9

movq    %rdx, 864(%rsp)
movq    %rcx, 872(%rsp)
movq    %rax, 880(%rsp)
movq    %r10, 888(%rsp)
    
xorq    %rdx, %rdx
movq    544(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    552(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    888(%rsp), %rcx
adcx    880(%rsp), %rax
movq    %rcx, 888(%rsp)
movq    %rax, 880(%rsp)

movq    560(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    872(%rsp), %rcx
adcx    864(%rsp), %rax
movq    %rcx, 872(%rsp)
movq    %rax, 864(%rsp)

movq    568(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    576(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    584(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    592(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    600(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rsi, %rax, %rsi 

mulx    %r8,  %rcx, %r8
adcx    %rcx, %rsi     

mulx    %rdi, %rcx, %rdi
adcx    %rcx, %r8

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rdi

mulx    %r11, %rcx, %r11
adcx    %rcx, %rbx

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %rbp, %rcx, %rbp
adcx    %rcx, %r13
adcq    $0, %rbp

xorq    %rcx, %rcx
adcx    %rax, %r10
adcx    %rsi, %r9
adcx    888(%rsp), %r8
adcx    880(%rsp), %rdi
adcx    872(%rsp), %rbx
adcx    864(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $6, %r13, %rbp
andq    mask58, %r13

imul    $45, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %r10, 544(%rsp)
movq    %r9,  552(%rsp)
movq    %r8,  560(%rsp)
movq    %rdi, 568(%rsp)
movq    %rbx, 576(%rsp)
movq    %r11, 584(%rsp)
movq    %r12, 592(%rsp)
movq    %r13, 600(%rsp)

// Z3 <- T2 · X1
movq    544(%rsp), %rdx    
xorq    %r8, %r8

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

mulx    128(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    552(%rsp), %rdx
   
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
adox    %rbp, %rdi
    
mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    560(%rsp), %rdx
    
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
adox    %rbp, %rdi

mulx    120(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    128(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 864(%rsp)

xorq    %r10, %r10
movq    568(%rsp), %rdx
    
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
adcq    $0, %r10			

movq    %r11, 872(%rsp)

xorq    %r11, %r11
movq    576(%rsp), %rdx
    
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
adcq    $0, %r11			

movq    %r12, 880(%rsp)

xorq    %r12, %r12
movq    584(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    88(%rsp), %rcx, %rbp
adcx    %rcx, %r15
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
adcq    $0, %r12			

movq    %r13, 888(%rsp)

xorq    %r13, %r13
movq    592(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    80(%rsp), %rcx, %rbp
adcx    %rcx, %r15
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
adcq    $0, %r13			

movq    %r14, 896(%rsp)

xorq    %r14, %r14
movq    600(%rsp), %rdx
    
mulx    72(%rsp), %rcx, %rbp
adcx    %rcx, %r15
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
adcq    $0, %r14

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rdi, %rax, %rdi

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %rdi     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %r14, %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

addq    %r8, %rax
adcq    %r9, %rdi
adcq    864(%rsp), %rsi
adcq    872(%rsp), %rbx
adcq    880(%rsp), %r10
adcq    888(%rsp), %r11
adcq    896(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $6, %r13, %r14
andq    mask58, %r13

imul    $45, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    472(%rsp), %rdx
movq    24(%rdx), %rcx

movq    %rax,  0(%rcx) // update Z3
movq    %rdi,  8(%rcx)
movq    %rsi, 16(%rcx)
movq    %rbx, 24(%rcx)
movq    %r10, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r12, 48(%rcx)
movq    %r13, 56(%rcx)


// X2 <- T5 · T6
movq    800(%rsp), %rdx    
xorq    %r8, %r8

mulx    736(%rsp), %r8, %r9
mulx    744(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    752(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    760(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    768(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    776(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    784(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    792(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    808(%rsp), %rdx
   
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    816(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 864(%rsp)

xorq    %r10, %r10
movq    824(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 872(%rsp)

xorq    %r11, %r11
movq    832(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 880(%rsp)

xorq    %r12, %r12
movq    840(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 888(%rsp)

xorq    %r13, %r13
movq    848(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 896(%rsp)

xorq    %r14, %r14
movq    856(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rdi, %rax, %rdi

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %rdi     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %r14, %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

addq    %r8, %rax
adcq    %r9, %rdi
adcq    864(%rsp), %rsi
adcq    872(%rsp), %rbx
adcq    880(%rsp), %r10
adcq    888(%rsp), %r11
adcq    896(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $6, %r13, %r14
andq    mask58, %r13

imul    $45, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    472(%rsp), %rdx
movq    0(%rdx), %rcx

movq    %rax,  0(%rcx) // update X2
movq    %rdi,  8(%rcx)
movq    %rsi, 16(%rcx)
movq    %rbx, 24(%rcx)
movq    %r10, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r12, 48(%rcx)
movq    %r13, 56(%rcx)

// T5 <- T5 - T6
movq    736(%rsp),  %r8
movq    744(%rsp),  %r9
movq    752(%rsp), %r10
movq    760(%rsp), %r11 
movq    768(%rsp), %r12
movq    776(%rsp), %r13
movq    784(%rsp), %r14
movq    792(%rsp), %r15

addq    _4p0,    %r8
adcq    _4p1_6,  %r9
adcq    _4p1_6, %r10
adcq    _4p1_6, %r11
adcq    _4p1_6, %r12
adcq    _4p1_6, %r13
adcq    _4p1_6, %r14
adcq    _4p7,   %r15

subq    800(%rsp),  %r8
sbbq    808(%rsp),  %r9
sbbq    816(%rsp), %r10
sbbq    824(%rsp), %r11
sbbq    832(%rsp), %r12
sbbq    840(%rsp), %r13
sbbq    848(%rsp), %r14
sbbq    856(%rsp), %r15

movq    %r8,  736(%rsp) 
movq    %r9,  744(%rsp)
movq    %r10, 752(%rsp)
movq    %r11, 760(%rsp)
movq    %r12, 768(%rsp)
movq    %r13, 776(%rsp)
movq    %r14, 784(%rsp)
movq    %r15, 792(%rsp)


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
adcq    $0,   %r13

shld    $6, %r12, %r13
andq    mask58, %r12

imul    $45, %r13, %r13
addq    %r13, %rsi
adcq    $0, %rdi
adcq    $0, %rbp
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12

// T6 <- T6 + T1
addq    800(%rsp), %rsi
adcq    808(%rsp), %rdi
adcq    816(%rsp), %rbp
adcq    824(%rsp),  %r8
adcq    832(%rsp),  %r9
adcq    840(%rsp), %r10
adcq    848(%rsp), %r11
adcq    856(%rsp), %r12

movq    %rsi, 800(%rsp)
movq    %rdi, 808(%rsp)
movq    %rbp, 816(%rsp)
movq    %r8,  824(%rsp)
movq    %r9,  832(%rsp)
movq    %r10, 840(%rsp)
movq    %r11, 848(%rsp)
movq    %r12, 856(%rsp)

// Z2 <- T5 · T6
movq    800(%rsp), %rdx    
xorq    %r8, %r8

mulx    736(%rsp), %r8, %r9
mulx    744(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    752(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    760(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    768(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    776(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    784(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    792(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    808(%rsp), %rdx
   
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    816(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 864(%rsp)

xorq    %r10, %r10
movq    824(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 872(%rsp)

xorq    %r11, %r11
movq    832(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 880(%rsp)

xorq    %r12, %r12
movq    840(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 888(%rsp)

xorq    %r13, %r13
movq    848(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 896(%rsp)

xorq    %r14, %r14
movq    856(%rsp), %rdx
    
mulx    736(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    744(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    752(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    760(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    768(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    776(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    784(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    792(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $2880, %rdx    		

xorq    %rax, %rax
mulx    %rdi, %rax, %rdi

mulx    %rsi,  %rcx, %rsi
adcx    %rcx, %rdi     

mulx    %rbx, %rcx, %rbx
adcx    %rcx, %rsi

mulx    %r10, %rcx, %r10
adcx    %rcx, %rbx

mulx    %r11, %rcx, %r11
adcx    %rcx, %r10

mulx    %r12, %rcx, %r12
adcx    %rcx, %r11

mulx    %r13, %rcx, %r13
adcx    %rcx, %r12

mulx    %r14, %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

addq    %r8, %rax
adcq    %r9, %rdi
adcq    864(%rsp), %rsi
adcq    872(%rsp), %rbx
adcq    880(%rsp), %r10
adcq    888(%rsp), %r11
adcq    896(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $6, %r13, %r14
andq    mask58, %r13

imul    $45, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    472(%rsp), %rdx
movq    8(%rdx), %rcx

movq    %rax,  0(%rcx) // update Z2
movq    %rdi,  8(%rcx)
movq    %rsi, 16(%rcx)
movq    %rbx, 24(%rcx)
movq    %r10, 32(%rcx)
movq    %r11, 40(%rcx)
movq    %r12, 48(%rcx)
movq    %r13, 56(%rcx)

movb    456(%rsp), %cl
subb    $1, %cl
movb    %cl, 456(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 456(%rsp)
movq    64(%rsp), %rax
movq    464(%rsp), %r15
subq    $1, %r15
movq    %r15, 464(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    472(%rsp), %rdx
movq    0(%rdx), %rcx

movq     0(%rcx),  %r8 
movq     8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15

movq    %r8,   0(%rdi) // final value of X2
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)
movq    %r15, 56(%rdi)

movq    8(%rdx), %rcx

movq     0(%rcx),  %r8 
movq     8(%rcx),  %r9
movq    16(%rcx), %r10
movq    24(%rcx), %r11
movq    32(%rcx), %r12
movq    40(%rcx), %r13
movq    48(%rcx), %r14
movq    56(%rcx), %r15

movq    %r8,  64(%rdi) // final value of Z2
movq    %r9,  72(%rdi)
movq    %r10, 80(%rdi)
movq    %r11, 88(%rdi)
movq    %r12, 96(%rdi)
movq    %r13, 104(%rdi)
movq    %r14, 112(%rdi)
movq    %r15, 120(%rdi)

movq 	 0(%rsp), %r11
movq 	 8(%rsp), %r12
movq 	16(%rsp), %r13
movq 	24(%rsp), %r14
movq 	32(%rsp), %r15
movq 	40(%rsp), %rbx
movq 	48(%rsp), %rbp

movq 	%r11, %rsp

ret
