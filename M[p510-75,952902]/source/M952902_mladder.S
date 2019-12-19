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
.globl M952902_mladder
M952902_mladder:

movq 	%rsp, %r11
subq 	$704, %rsp

movq 	%r11, 0(%rsp)
movq 	%r12, 8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

// X1 ← XP, X3 ← XP
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
movq	%r8, 320(%rsp)

// X2 ← 1
movq	$1, 136(%rsp)
movq	$0, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)

// Z2 ← 0
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)
movq	$0, 240(%rsp)
movq	$0, 248(%rsp)
movq	$0, 256(%rsp)

// Z3 ← 1
movq	$1, 328(%rsp)
movq	$0, 336(%rsp)
movq	$0, 344(%rsp)
movq	$0, 352(%rsp)
movq	$0, 360(%rsp)
movq	$0, 368(%rsp)
movq	$0, 376(%rsp)
movq	$0, 384(%rsp)

movq    $63, 400(%rsp)
movb	$5, 392(%rsp)
movb    $0, 394(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop.

.L1:

addq    400(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 396(%rsp)

.L2:

/* 
 * Montgomery ladder step.
 *
 * Implementation idea of subtraction has been taken from the 64-bit implementation "amd64-64"
 * of the work "https://link.springer.com/article/10.1007/s13389-012-0027-1".
 *
 * T1 ← X2 + Z2
 * T2 ← X2 - Z2
 * T3 ← X3 + Z3
 * T4 ← X3 - Z3
 * Z2 ← T2 · T3
 * T5 ← T1 · T4
 * T6 ← T5
 * X2 ← T5 + Z2
 * Z2 ← T6 - Z2
 * X3 ← X2^2
 * Z2 ← Z2^2
 * Z3 ← Z2 · X1
 *
 * bit ← n[i]
 * swap ← bit ⊕ prevbit
 * prevbit ← bit
 * CSelect(T1,T2,T3,T4,swap)
 *
 * T2 ← T2^2
 * T1 ← T1^2
 * T3 ← T1 - T2
 * X2 ← T1 · T2
 * T1 ← ((A + 2)/4) · T3
 * T1 ← T1 + T2
 * Z2 ← T1 · T3
 *
 */

// X2
movq    136(%rsp), %r8
movq    144(%rsp), %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11
movq    168(%rsp), %r12
movq    176(%rsp), %r13
movq    184(%rsp), %r14
movq    192(%rsp), %r15

// copy X2
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %rcx
movq    %r14, %rdx

// T1 ← X2 + Z2
addq    200(%rsp), %r8
adcq    208(%rsp), %r9
adcq    216(%rsp), %r10
adcq    224(%rsp), %r11
adcq    232(%rsp), %r12
adcq    240(%rsp), %r13
adcq    248(%rsp), %r14
adcq    256(%rsp), %r15

movq    %r8,  408(%rsp)
movq    %r9,  416(%rsp)
movq    %r10, 424(%rsp)
movq    %r11, 432(%rsp)
movq    %r12, 440(%rsp)
movq    %r13, 448(%rsp)
movq    %r14, 456(%rsp)
movq    %r15, 464(%rsp)

// T2 ← X2 - Z2
movq    192(%rsp), %r8

subq    200(%rsp), %rax
sbbq    208(%rsp), %rbx
sbbq    216(%rsp), %rbp
sbbq    224(%rsp), %rsi
sbbq    232(%rsp), %rdi
sbbq    240(%rsp), %rcx
sbbq    248(%rsp), %rdx
sbbq    256(%rsp), %r8

movq    $0,   %r11
movq    $300, %r12
cmovae  %r11, %r12

subq    %r12, %rax
sbbq    %r11, %rbx
sbbq    %r11, %rbp
sbbq    %r11, %rsi
sbbq    %r11, %rdi
sbbq    %r11, %rcx
sbbq    %r11, %rdx
sbbq    %r11, %r8

cmovc   %r12, %r11
subq    %r11, %rax

movq    %rax, 472(%rsp)
movq    %rbx, 480(%rsp)
movq    %rbp, 488(%rsp)
movq    %rsi, 496(%rsp)
movq    %rdi, 504(%rsp)
movq    %rcx, 512(%rsp)
movq    %rdx, 520(%rsp)
movq    %r8,  528(%rsp)

// X3
movq    264(%rsp), %r8
movq    272(%rsp), %r9
movq    280(%rsp), %r10
movq    288(%rsp), %r11
movq    296(%rsp), %r12
movq    304(%rsp), %r13
movq    312(%rsp), %r14
movq    320(%rsp), %r15

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rdi
movq    %r13, %rcx
movq    %r14, %rdx

// T3 ← X3 + Z3
addq    328(%rsp), %r8
adcq    336(%rsp), %r9
adcq    344(%rsp), %r10
adcq    352(%rsp), %r11
adcq    360(%rsp), %r12
adcq    368(%rsp), %r13
adcq    376(%rsp), %r14
adcq    384(%rsp), %r15

movq    %r8,  536(%rsp)
movq    %r9,  544(%rsp)
movq    %r10, 552(%rsp)
movq    %r11, 560(%rsp)
movq    %r12, 568(%rsp)
movq    %r13, 576(%rsp)
movq    %r14, 584(%rsp)
movq    %r15, 592(%rsp)

// T4 ← X3 - Z3
movq    320(%rsp), %r8

subq    328(%rsp), %rax
sbbq    336(%rsp), %rbx
sbbq    344(%rsp), %rbp
sbbq    352(%rsp), %rsi
sbbq    360(%rsp), %rdi
sbbq    368(%rsp), %rcx
sbbq    376(%rsp), %rdx
sbbq    384(%rsp), %r8

movq    $0,   %r11
movq    $300, %r12
cmovae  %r11, %r12

subq    %r12, %rax
sbbq    %r11, %rbx
sbbq    %r11, %rbp
sbbq    %r11, %rsi
sbbq    %r11, %rdi
sbbq    %r11, %rcx
sbbq    %r11, %rdx
sbbq    %r11, %r8

cmovc   %r12, %r11
subq    %r11, %rax

movq    %rax, 600(%rsp)
movq    %rbx, 608(%rsp)
movq    %rbp, 616(%rsp)
movq    %rsi, 624(%rsp)
movq    %rdi, 632(%rsp)
movq    %rcx, 640(%rsp)
movq    %rdx, 648(%rsp)
movq    %r8,  656(%rsp)

// Z2 ← T2 · T3
movq    472(%rsp), %rdx    
xorq    %r8, %r8

mulx    536(%rsp), %r8, %r9
mulx    544(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    552(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    560(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    568(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    576(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    584(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    592(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    480(%rsp), %rdx
   
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
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
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    488(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
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
adcq    $0, %rbx

movq    %r10, 664(%rsp)

xorq    %r10, %r10
movq    496(%rsp), %rdx
    
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
adcq    $0, %r10			

movq    %r11, 672(%rsp)

xorq    %r11, %r11
movq    504(%rsp), %rdx
    
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
adcq    $0, %r11			

movq    %r12, 680(%rsp)

xorq    %r12, %r12
movq    512(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
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
adcq    $0, %r12			

movq    %r13, 688(%rsp)

xorq    %r13, %r13
movq    520(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
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
adcq    $0, %r13			

movq    %r14, 696(%rsp)

xorq    %r14, %r14
movq    528(%rsp), %rdx
    
mulx    536(%rsp), %rcx, %rbp
adcx    %rcx, %r15
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
  
mulx    592(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $300, %rdx    		

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
adcq    664(%rsp), %rsi
adcq    672(%rsp), %rbx
adcq    680(%rsp), %r10
adcq    688(%rsp), %r11
adcq    696(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $2, %r13, %r14
andq    mask62, %r13

imul    $75, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %rax, 200(%rsp)
movq    %rdi, 208(%rsp)
movq    %rsi, 216(%rsp)
movq    %rbx, 224(%rsp)
movq    %r10, 232(%rsp)
movq    %r11, 240(%rsp)
movq    %r12, 248(%rsp)
movq    %r13, 256(%rsp)

// T5 ← T1 · T4
movq    600(%rsp), %rdx    
xorq    %r8, %r8

mulx    408(%rsp), %r8, %r9
mulx    416(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    424(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    432(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    440(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    448(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    456(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    464(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    608(%rsp), %rdx
   
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    616(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 664(%rsp)

xorq    %r10, %r10
movq    624(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 672(%rsp)

xorq    %r11, %r11
movq    632(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 680(%rsp)

xorq    %r12, %r12
movq    640(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 688(%rsp)

xorq    %r13, %r13
movq    648(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 696(%rsp)

xorq    %r14, %r14
movq    656(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $300, %rdx    		

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
adcq    664(%rsp), %rsi
adcq    672(%rsp), %rbx
adcq    680(%rsp), %r10
adcq    688(%rsp), %r11
adcq    696(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $2, %r13, %r14
andq    mask62, %r13

imul    $75, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

// T6 ← T5
movq    %rax, %r8
movq    %rdi, %r9
movq    %rsi, %r14
movq    %rbx, %r15
movq    %r10, %rdx
movq    %r11, %rcx
movq    %r12, %rbp
movq    %r13, 664(%rsp)

// X2 ← T5 + Z2
addq    200(%rsp), %rax
adcq    208(%rsp), %rdi
adcq    216(%rsp), %rsi
adcq    224(%rsp), %rbx
adcq    232(%rsp), %r10
adcq    240(%rsp), %r11
adcq    248(%rsp), %r12
adcq    256(%rsp), %r13

movq    %rax, 136(%rsp)
movq    %rdi, 144(%rsp)
movq    %rsi, 152(%rsp)
movq    %rbx, 160(%rsp)
movq    %r10, 168(%rsp)
movq    %r11, 176(%rsp)
movq    %r12, 184(%rsp)
movq    %r13, 192(%rsp)

// Z2 ← T6 - Z2
movq    664(%rsp), %rax

subq    200(%rsp), %r8
sbbq    208(%rsp), %r9
sbbq    216(%rsp), %r14
sbbq    224(%rsp), %r15
sbbq    232(%rsp), %rdx
sbbq    240(%rsp), %rcx
sbbq    248(%rsp), %rbp
sbbq    256(%rsp), %rax

movq    $0,   %r11
movq    $300, %r12
cmovae  %r11, %r12

subq    %r12, %r8
sbbq    %r11, %r9
sbbq    %r11, %r14
sbbq    %r11, %r15
sbbq    %r11, %rdx
sbbq    %r11, %rcx
sbbq    %r11, %rbp
sbbq    %r11, %rax

cmovc   %r12, %r11
subq    %r11, %r8

movq    %r8,  200(%rsp) 
movq    %r9,  208(%rsp)
movq    %r14, 216(%rsp)
movq    %r15, 224(%rsp)
movq    %rdx, 232(%rsp)
movq    %rcx, 240(%rsp)
movq    %rbp, 248(%rsp)
movq    %rax, 256(%rsp)

// X3 ← X2^2
movq    136(%rsp), %rdx
xorq    %r8, %r8
    
mulx    144(%rsp), %r9, %r10

mulx    152(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    160(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    168(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    176(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    184(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    192(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    144(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    152(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    160(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    152(%rsp), %rdx
xorq    %rbx, %rbx

mulx    160(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 664(%rsp)

movq    160(%rsp), %rdx
xorq    %r11, %r11

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 672(%rsp)

movq    168(%rsp), %rdx
xorq    %r12, %r12

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 680(%rsp)

movq    176(%rsp), %rdx
xorq    %r13, %r13

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    184(%rsp), %rdx
 
mulx    192(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    664(%rsp), %rax
movq    672(%rsp), %rcx
movq    680(%rsp), %rdx

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

movq    %rdx, 664(%rsp)
movq    %rcx, 672(%rsp)
movq    %rax, 680(%rsp)
movq    %r10, 688(%rsp)
    
xorq    %rdx, %rdx
movq    136(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    144(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    688(%rsp), %rcx
adcx    680(%rsp), %rax
movq    %rcx, 688(%rsp)
movq    %rax, 680(%rsp)

movq    152(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    672(%rsp), %rcx
adcx    664(%rsp), %rax
movq    %rcx, 672(%rsp)
movq    %rax, 664(%rsp)

movq    160(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    168(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    176(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    184(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    192(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $300, %rdx    		

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
adcx    688(%rsp), %r8
adcx    680(%rsp), %rdi
adcx    672(%rsp), %rbx
adcx    664(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $2, %r13, %rbp
andq    mask62, %r13

imul    $75, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

// update X3
movq    %r10, 264(%rsp) 
movq    %r9,  272(%rsp)
movq    %r8,  280(%rsp)
movq    %rdi, 288(%rsp)
movq    %rbx, 296(%rsp)
movq    %r11, 304(%rsp)
movq    %r12, 312(%rsp)
movq    %r13, 320(%rsp)

// Z2 ← Z2^2
movq    200(%rsp), %rdx
xorq    %r8, %r8
    
mulx    208(%rsp), %r9, %r10

mulx    216(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    224(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    232(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    240(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    248(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    256(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    208(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    216(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    224(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    240(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    216(%rsp), %rdx
xorq    %rbx, %rbx

mulx    224(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    240(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 664(%rsp)

movq    224(%rsp), %rdx
xorq    %r11, %r11

mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    240(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 672(%rsp)

movq    232(%rsp), %rdx
xorq    %r12, %r12

mulx    240(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 680(%rsp)

movq    240(%rsp), %rdx
xorq    %r13, %r13

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    248(%rsp), %rdx
 
mulx    256(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    664(%rsp), %rax
movq    672(%rsp), %rcx
movq    680(%rsp), %rdx

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

movq    %rdx, 664(%rsp)
movq    %rcx, 672(%rsp)
movq    %rax, 680(%rsp)
movq    %r10, 688(%rsp)
    
xorq    %rdx, %rdx
movq    200(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    208(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    688(%rsp), %rcx
adcx    680(%rsp), %rax
movq    %rcx, 688(%rsp)
movq    %rax, 680(%rsp)

movq    216(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    672(%rsp), %rcx
adcx    664(%rsp), %rax
movq    %rcx, 672(%rsp)
movq    %rax, 664(%rsp)

movq    224(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    232(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    240(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    248(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    256(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $300, %rdx    		

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
adcx    688(%rsp), %r8
adcx    680(%rsp), %rdi
adcx    672(%rsp), %rbx
adcx    664(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $2, %r13, %rbp
andq    mask62, %r13

imul    $75, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %r10, 200(%rsp)
movq    %r9,  208(%rsp)
movq    %r8,  216(%rsp)
movq    %rdi, 224(%rsp)
movq    %rbx, 232(%rsp)
movq    %r11, 240(%rsp)
movq    %r12, 248(%rsp)
movq    %r13, 256(%rsp)

// Z3 ← Z2 · X1
movq    200(%rsp), %rdx    
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
movq    208(%rsp), %rdx
   
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
movq    216(%rsp), %rdx
    
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

movq    %r10, 664(%rsp)

xorq    %r10, %r10
movq    224(%rsp), %rdx
    
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

movq    %r11, 672(%rsp)

xorq    %r11, %r11
movq    232(%rsp), %rdx
    
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

movq    %r12, 680(%rsp)

xorq    %r12, %r12
movq    240(%rsp), %rdx
    
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

movq    %r13, 688(%rsp)

xorq    %r13, %r13
movq    248(%rsp), %rdx
    
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

movq    %r14, 696(%rsp)

xorq    %r14, %r14
movq    256(%rsp), %rdx
    
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

movq    $300, %rdx    		

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
adcq    664(%rsp), %rsi
adcq    672(%rsp), %rbx
adcq    680(%rsp), %r10
adcq    688(%rsp), %r11
adcq    696(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $2, %r13, %r14
andq    mask62, %r13

imul    $75, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

// update Z3
movq    %rax, 328(%rsp) 
movq    %rdi, 336(%rsp)
movq    %rsi, 344(%rsp)
movq    %rbx, 352(%rsp)
movq    %r10, 360(%rsp)
movq    %r11, 368(%rsp)
movq    %r12, 376(%rsp)
movq    %r13, 384(%rsp)

movb	392(%rsp), %cl
movb	396(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    394(%rsp), %bl
movb    %cl, 394(%rsp)

cmpb    $1, %bl

// cselect(T1,T2,T3,T4,swap)
movq    408(%rsp), %r8
movq    416(%rsp), %r9
movq    424(%rsp), %r10
movq    432(%rsp), %r11
movq    440(%rsp), %r12
movq    448(%rsp), %r13
movq    456(%rsp), %r14

movq    536(%rsp), %r15
movq    544(%rsp), %rax
movq    552(%rsp), %rbx
movq    560(%rsp), %rcx
movq    568(%rsp), %rdx
movq    576(%rsp), %rbp
movq    584(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  408(%rsp)
movq    %r9,  416(%rsp)
movq    %r10, 424(%rsp)
movq    %r11, 432(%rsp)
movq    %r12, 440(%rsp)
movq    %r13, 448(%rsp)
movq    %r14, 456(%rsp)

movq    464(%rsp), %r14
movq    592(%rsp), %rsi
cmove   %rsi, %r14
movq    %r14, 464(%rsp)

movq    472(%rsp), %r8
movq    480(%rsp), %r9
movq    488(%rsp), %r10
movq    496(%rsp), %r11
movq    504(%rsp), %r12
movq    512(%rsp), %r13
movq    520(%rsp), %r14

movq    600(%rsp), %r15
movq    608(%rsp), %rax
movq    616(%rsp), %rbx
movq    624(%rsp), %rcx
movq    632(%rsp), %rdx
movq    640(%rsp), %rbp
movq    648(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  472(%rsp)
movq    %r9,  480(%rsp)
movq    %r10, 488(%rsp)
movq    %r11, 496(%rsp)
movq    %r12, 504(%rsp)
movq    %r13, 512(%rsp)
movq    %r14, 520(%rsp)

movq    528(%rsp), %r14
movq    656(%rsp), %rsi
cmove   %rsi, %r14
movq    %r14, 528(%rsp)

// T2 ← T2^2
movq    472(%rsp), %rdx
xorq    %r8, %r8
    
mulx    480(%rsp), %r9, %r10

mulx    488(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    496(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    504(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    512(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    520(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    528(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    480(%rsp), %rdx
xorq    %rdi, %rdi
    
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
adox    %rbp, %rsi
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    488(%rsp), %rdx
xorq    %rbx, %rbx

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 664(%rsp)

movq    496(%rsp), %rdx
xorq    %r11, %r11

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 672(%rsp)

movq    504(%rsp), %rdx
xorq    %r12, %r12

mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 680(%rsp)

movq    512(%rsp), %rdx
xorq    %r13, %r13

mulx    520(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    528(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    520(%rsp), %rdx
 
mulx    528(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    664(%rsp), %rax
movq    672(%rsp), %rcx
movq    680(%rsp), %rdx

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

movq    %rdx, 664(%rsp)
movq    %rcx, 672(%rsp)
movq    %rax, 680(%rsp)
movq    %r10, 688(%rsp)
    
xorq    %rdx, %rdx
movq    472(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    480(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    688(%rsp), %rcx
adcx    680(%rsp), %rax
movq    %rcx, 688(%rsp)
movq    %rax, 680(%rsp)

movq    488(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    672(%rsp), %rcx
adcx    664(%rsp), %rax
movq    %rcx, 672(%rsp)
movq    %rax, 664(%rsp)

movq    496(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    504(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    512(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    520(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $300, %rdx    		

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
adcx    688(%rsp), %r8
adcx    680(%rsp), %rdi
adcx    672(%rsp), %rbx
adcx    664(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $2, %r13, %rbp
andq    mask62, %r13

imul    $75, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %r10, 472(%rsp)
movq    %r9,  480(%rsp)
movq    %r8,  488(%rsp)
movq    %rdi, 496(%rsp)
movq    %rbx, 504(%rsp)
movq    %r11, 512(%rsp)
movq    %r12, 520(%rsp)
movq    %r13, 528(%rsp)

// T1 ← T1^2
movq    408(%rsp), %rdx
xorq    %r8, %r8
    
mulx    416(%rsp), %r9, %r10

mulx    424(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    432(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    440(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    448(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    456(%rsp), %rcx, %r15
adcx    %rcx, %r14
    
mulx    464(%rsp), %rcx, %rsi
adcx    %rcx, %r15
adcx    %r8, %rsi			

movq    416(%rsp), %rdx
xorq    %rdi, %rdi
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcx    %rdi, %r8

movq    424(%rsp), %rdx
xorq    %rbx, %rbx

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
adcx    %rbx, %rdi

movq    %r11, 664(%rsp)

movq    432(%rsp), %rdx
xorq    %r11, %r11

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rsi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
adcx    %r11, %rbx

movq    %r12, 672(%rsp)

movq    440(%rsp), %rdx
xorq    %r12, %r12

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %rdi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rbx
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
adcx    %r12, %r11

movq    %r13, 680(%rsp)

movq    448(%rsp), %rdx
xorq    %r13, %r13

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r11
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcx    %r13, %r12	

movq    456(%rsp), %rdx
 
mulx    464(%rsp), %rcx, %r13
addq    %rcx, %r12
adcq    $0, %r13

movq    664(%rsp), %rax
movq    672(%rsp), %rcx
movq    680(%rsp), %rdx

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

movq    %rdx, 664(%rsp)
movq    %rcx, 672(%rsp)
movq    %rax, 680(%rsp)
movq    %r10, 688(%rsp)
    
xorq    %rdx, %rdx
movq    408(%rsp), %rdx
mulx    %rdx, %r10, %rax
adcx    %rax, %r9

movq    416(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    688(%rsp), %rcx
adcx    680(%rsp), %rax
movq    %rcx, 688(%rsp)
movq    %rax, 680(%rsp)

movq    424(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    672(%rsp), %rcx
adcx    664(%rsp), %rax
movq    %rcx, 672(%rsp)
movq    %rax, 664(%rsp)

movq    432(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r14
adcx    %rax, %r15

movq    440(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rsi
adcx    %rax, %r8

movq    448(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %rdi
adcx    %rax, %rbx

movq    456(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r11
adcx    %rax, %r12

movq    464(%rsp), %rdx
mulx    %rdx, %rcx, %rax
adcx    %rcx, %r13
adcx    %rax, %rbp

movq    $300, %rdx    		

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
adcx    688(%rsp), %r8
adcx    680(%rsp), %rdi
adcx    672(%rsp), %rbx
adcx    664(%rsp), %r11
adcx    %r14, %r12
adcx    %r15, %r13
adcx    %rcx, %rbp
    
shld    $2, %r13, %rbp
andq    mask62, %r13

imul    $75, %rbp, %rbp
addq    %rbp, %r10
adcq    $0, %r9
adcq    $0, %r8
adcq    $0, %rdi
adcq    $0, %rbx
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

movq    %r10, 408(%rsp)
movq    %r9,  416(%rsp)
movq    %r8,  424(%rsp)
movq    %rdi, 432(%rsp)
movq    %rbx, 440(%rsp)
movq    %r11, 448(%rsp)
movq    %r12, 456(%rsp)
movq    %r13, 464(%rsp)

// T3 ← T1 - T2
subq    472(%rsp), %r10
sbbq    480(%rsp), %r9
sbbq    488(%rsp), %r8
sbbq    496(%rsp), %rdi
sbbq    504(%rsp), %rbx
sbbq    512(%rsp), %r11
sbbq    520(%rsp), %r12
sbbq    528(%rsp), %r13

movq    $0,   %r14
movq    $300, %r15
cmovae  %r14, %r15

subq    %r15, %r10
sbbq    %r14, %r9
sbbq    %r14, %r8
sbbq    %r14, %rdi
sbbq    %r14, %rbx
sbbq    %r14, %r11
sbbq    %r14, %r12
sbbq    %r14, %r13

cmovc   %r15, %r14
subq    %r14, %r8

movq    %r10, 536(%rsp) 
movq    %r9,  544(%rsp)
movq    %r8,  552(%rsp)
movq    %rdi, 560(%rsp)
movq    %rbx, 568(%rsp)
movq    %r11, 576(%rsp)
movq    %r12, 584(%rsp)
movq    %r13, 592(%rsp)

// X2 ← T1 · T2
movq    472(%rsp), %rdx    
xorq    %r8, %r8

mulx    408(%rsp), %r8, %r9
mulx    416(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    424(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    432(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    440(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    448(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    456(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    464(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    480(%rsp), %rdx
   
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    488(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 664(%rsp)

xorq    %r10, %r10
movq    496(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 672(%rsp)

xorq    %r11, %r11
movq    504(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 680(%rsp)

xorq    %r12, %r12
movq    512(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 688(%rsp)

xorq    %r13, %r13
movq    520(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 696(%rsp)

xorq    %r14, %r14
movq    528(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $300, %rdx    		

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
adcq    664(%rsp), %rsi
adcq    672(%rsp), %rbx
adcq    680(%rsp), %r10
adcq    688(%rsp), %r11
adcq    696(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $2, %r13, %r14
andq    mask62, %r13

imul    $75, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

// update X2
movq    %rax, 136(%rsp) 
movq    %rdi, 144(%rsp)
movq    %rsi, 152(%rsp)
movq    %rbx, 160(%rsp)
movq    %r10, 168(%rsp)
movq    %r11, 176(%rsp)
movq    %r12, 184(%rsp)
movq    %r13, 192(%rsp)

// T1 ← ((A + 2)/4) · T3
xorq    %rdx, %rdx
movq    a24, %rdx

mulx    536(%rsp), %rsi, %rdi
mulx    544(%rsp), %rcx, %rbp
adcx    %rcx, %rdi

mulx    552(%rsp), %rcx, %r8
adcx    %rcx, %rbp

mulx    560(%rsp), %rcx, %r9
adcx    %rcx, %r8

mulx    568(%rsp), %rcx, %r10
adcx    %rcx, %r9

mulx    576(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    584(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    592(%rsp), %rcx, %r13
adcx    %rcx, %r12
adcq    $0,   %r13

shld    $2, %r12, %r13
andq    mask62, %r12

imul    $75, %r13, %r13
addq    %r13, %rsi
adcq    $0, %rdi
adcq    $0, %rbp
adcq    $0, %r8
adcq    $0, %r9
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12

// T1 ← T1 + T2
addq    472(%rsp), %rsi
adcq    480(%rsp), %rdi
adcq    488(%rsp), %rbp
adcq    496(%rsp), %r8
adcq    504(%rsp), %r9
adcq    512(%rsp), %r10
adcq    520(%rsp), %r11
adcq    528(%rsp), %r12

movq    %rsi, 408(%rsp)
movq    %rdi, 416(%rsp)
movq    %rbp, 424(%rsp)
movq    %r8,  432(%rsp)
movq    %r9,  440(%rsp)
movq    %r10, 448(%rsp)
movq    %r11, 456(%rsp)
movq    %r12, 464(%rsp)

// Z2 ← T1 · T3
movq    536(%rsp), %rdx    
xorq    %r8, %r8

mulx    408(%rsp), %r8, %r9
mulx    416(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    424(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    432(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    440(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    448(%rsp), %rcx, %r14	
adcx    %rcx, %r13 

mulx    456(%rsp), %rcx, %r15	
adcx    %rcx, %r14 

mulx    464(%rsp), %rcx, %rdi	
adcx    %rcx, %r15
adcq    $0, %rdi    		

xorq    %rsi, %rsi
movq    544(%rsp), %rdx
   
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi			
adcq    $0, %rsi		

xorq    %rbx, %rbx
movq    552(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx

movq    %r10, 664(%rsp)

xorq    %r10, %r10
movq    560(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10			
adcq    $0, %r10			

movq    %r11, 672(%rsp)

xorq    %r11, %r11
movq    568(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11			
adcq    $0, %r11			

movq    %r12, 680(%rsp)

xorq    %r12, %r12
movq    576(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 688(%rsp)

xorq    %r13, %r13
movq    584(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 696(%rsp)

xorq    %r14, %r14
movq    592(%rsp), %rdx
    
mulx    408(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rdi
    
mulx    416(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    424(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    432(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    440(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
  
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14			
adcq    $0, %r14

movq    $300, %rdx    		

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
adcq    664(%rsp), %rsi
adcq    672(%rsp), %rbx
adcq    680(%rsp), %r10
adcq    688(%rsp), %r11
adcq    696(%rsp), %r12
adcq    %r15, %r13
adcq    $0, %r14   			
   
shld    $2, %r13, %r14
andq    mask62, %r13

imul    $75, %r14, %r14
addq    %r14, %rax
adcq    $0, %rdi
adcq    $0, %rsi
adcq    $0, %rbx
adcq    $0, %r10
adcq    $0, %r11
adcq    $0, %r12
adcq    $0, %r13

// update Z2
movq    %rax, 200(%rsp) 
movq    %rdi, 208(%rsp)
movq    %rsi, 216(%rsp)
movq    %rbx, 224(%rsp)
movq    %r10, 232(%rsp)
movq    %r11, 240(%rsp)
movq    %r12, 248(%rsp)
movq    %r13, 256(%rsp)

movb    392(%rsp), %cl
subb    $1, %cl
movb    %cl, 392(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 392(%rsp)
movq    64(%rsp), %rax
movq    400(%rsp), %r15
subq    $1, %r15
movq    %r15, 400(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    136(%rsp), %r8 
movq    144(%rsp), %r9
movq    152(%rsp), %r10
movq    160(%rsp), %r11
movq    168(%rsp), %r12
movq    176(%rsp), %r13
movq    184(%rsp), %r14
movq    192(%rsp), %r15

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)
movq    %r15, 56(%rdi)

movq    200(%rsp), %r8 
movq    208(%rsp), %r9
movq    216(%rsp), %r10
movq    224(%rsp), %r11
movq    232(%rsp), %r12
movq    240(%rsp), %r13
movq    248(%rsp), %r14
movq    256(%rsp), %r15

// store final value of Z2
movq    %r8,  64(%rdi) 
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
