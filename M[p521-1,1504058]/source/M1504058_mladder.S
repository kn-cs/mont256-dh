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
subq 	$800, %rsp

movq 	%r11,  0(%rsp)
movq 	%r12,  8(%rsp)
movq 	%r13, 16(%rsp)
movq 	%r14, 24(%rsp)
movq 	%r15, 32(%rsp)
movq 	%rbx, 40(%rsp)
movq 	%rbp, 48(%rsp)
movq 	%rdi, 56(%rsp)

// X1 ← XP, X3 ← XP
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
movq	%r8, 352(%rsp)

// X2 ← 1
movq	$1, 144(%rsp)
movq	$0, 152(%rsp)
movq	$0, 160(%rsp)
movq	$0, 168(%rsp)
movq	$0, 176(%rsp)
movq	$0, 184(%rsp)
movq	$0, 192(%rsp)
movq	$0, 200(%rsp)
movq	$0, 208(%rsp)

// Z2 ← 0
movq	$0, 216(%rsp)
movq	$0, 224(%rsp)
movq	$0, 232(%rsp)
movq	$0, 240(%rsp)
movq	$0, 248(%rsp)
movq	$0, 256(%rsp)
movq	$0, 264(%rsp)
movq	$0, 272(%rsp)
movq	$0, 280(%rsp)

// Z3 ← 1
movq	$1, 360(%rsp)
movq	$0, 368(%rsp)
movq	$0, 376(%rsp)
movq	$0, 384(%rsp)
movq	$0, 392(%rsp)
movq	$0, 400(%rsp)
movq	$0, 408(%rsp)
movq	$0, 416(%rsp)
movq	$0, 424(%rsp)

movq    $65, 440(%rsp)
movb	$0, 432(%rsp)
movb	$0, 434(%rsp)
movq    %rdx, 64(%rsp)

movq    %rdx, %rax

// Montgomery ladder loop.

.L1:

addq    440(%rsp), %rax
movb    0(%rax), %r14b
movb    %r14b, 436(%rsp)

.L2:

/* 
 * Montgomery ladder step.
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
movq    144(%rsp), %r8
movq    152(%rsp), %r9
movq    160(%rsp), %r10
movq    168(%rsp), %r11
movq    176(%rsp), %r12
movq    184(%rsp), %r13
movq    192(%rsp), %r14
movq    200(%rsp), %r15
movq    208(%rsp), %rdi

// copy X2
movq    %r8,  %rax	
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rcx
movq    %r13, %rdx

// T1 ← X2 + Z2
addq    216(%rsp), %r8
adcq    224(%rsp), %r9
adcq    232(%rsp), %r10
adcq    240(%rsp), %r11
adcq    248(%rsp), %r12
adcq    256(%rsp), %r13
adcq    264(%rsp), %r14
adcq    272(%rsp), %r15
adcq    280(%rsp), %rdi

movq    %r8,  448(%rsp)
movq    %r9,  456(%rsp)
movq    %r10, 464(%rsp)
movq    %r11, 472(%rsp)
movq    %r12, 480(%rsp)
movq    %r13, 488(%rsp)
movq    %r14, 496(%rsp)
movq    %r15, 504(%rsp)
movq    %rdi, 512(%rsp)

// T2 ← X2 - Z2
movq    192(%rsp), %r10
movq    200(%rsp), %r11
movq    208(%rsp), %r12

addq    _4p0,   %rax
adcq    _4p1_7, %rbx
adcq    _4p1_7, %rbp
adcq    _4p1_7, %rsi
adcq    _4p1_7, %rcx
adcq    _4p1_7, %rdx
adcq    _4p1_7, %r10
adcq    _4p1_7, %r11
adcq    _4p8,   %r12

subq    216(%rsp), %rax
sbbq    224(%rsp), %rbx
sbbq    232(%rsp), %rbp
sbbq    240(%rsp), %rsi
sbbq    248(%rsp), %rcx
sbbq    256(%rsp), %rdx
sbbq    264(%rsp), %r10
sbbq    272(%rsp), %r11
sbbq    280(%rsp), %r12

movq    %rax, 520(%rsp)
movq    %rbx, 528(%rsp)
movq    %rbp, 536(%rsp)
movq    %rsi, 544(%rsp)
movq    %rcx, 552(%rsp)
movq    %rdx, 560(%rsp)
movq    %r10, 568(%rsp)
movq    %r11, 576(%rsp)
movq    %r12, 584(%rsp)

// X3
movq    288(%rsp), %r8  
movq    296(%rsp), %r9
movq    304(%rsp), %r10
movq    312(%rsp), %r11
movq    320(%rsp), %r12
movq    328(%rsp), %r13
movq    336(%rsp), %r14
movq    344(%rsp), %r15
movq    352(%rsp), %rdi

// copy X3
movq    %r8,  %rax
movq    %r9,  %rbx
movq    %r10, %rbp
movq    %r11, %rsi
movq    %r12, %rcx
movq    %r13, %rdx

// T3 ← X3 + Z3
addq    360(%rsp), %r8
adcq    368(%rsp), %r9
adcq    376(%rsp), %r10
adcq    384(%rsp), %r11
adcq    392(%rsp), %r12
adcq    400(%rsp), %r13
adcq    408(%rsp), %r14
adcq    416(%rsp), %r15
adcq    424(%rsp), %rdi

movq    %r8,  592(%rsp)
movq    %r9,  600(%rsp)
movq    %r10, 608(%rsp)
movq    %r11, 616(%rsp)
movq    %r12, 624(%rsp)
movq    %r13, 632(%rsp)
movq    %r14, 640(%rsp)
movq    %r15, 648(%rsp)
movq    %rdi, 656(%rsp)

// T4 ← X3 - Z3
movq    336(%rsp), %r10
movq    344(%rsp), %r11
movq    352(%rsp), %r12

addq    _4p0,   %rax
adcq    _4p1_7, %rbx
adcq    _4p1_7, %rbp
adcq    _4p1_7, %rsi
adcq    _4p1_7, %rcx
adcq    _4p1_7, %rdx
adcq    _4p1_7, %r10
adcq    _4p1_7, %r11
adcq    _4p8,   %r12

subq    360(%rsp), %rax
sbbq    368(%rsp), %rbx
sbbq    376(%rsp), %rbp
sbbq    384(%rsp), %rsi
sbbq    392(%rsp), %rcx
sbbq    400(%rsp), %rdx
sbbq    408(%rsp), %r10
sbbq    416(%rsp), %r11
sbbq    424(%rsp), %r12

movq    %rax, 664(%rsp)
movq    %rbx, 672(%rsp)
movq    %rbp, 680(%rsp)
movq    %rsi, 688(%rsp)
movq    %rcx, 696(%rsp)
movq    %rdx, 704(%rsp)
movq    %r10, 712(%rsp)
movq    %r11, 720(%rsp)
movq    %r12, 728(%rsp)

// Z2 ← T2 · T3
xorq    %rdx, %rdx
movq    520(%rsp), %rdx    

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
movq    528(%rsp), %rdx
   
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
movq    536(%rsp), %rdx
    
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

movq    %r10, 736(%rsp)

xorq    %r10, %r10
movq    544(%rsp), %rdx
    
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

movq    %r11, 744(%rsp)

xorq    %r11, %r11
movq    552(%rsp), %rdx
    
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

movq    %r12, 752(%rsp)

xorq    %r12, %r12
movq    560(%rsp), %rdx
    
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

movq    %r13, 760(%rsp)

xorq    %r13, %r13
movq    568(%rsp), %rdx
    
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

movq    %r14, 768(%rsp)

xorq    %r14, %r14
movq    576(%rsp), %rdx
    
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
   
movq    %r15, 776(%rsp)

xorq    %r15, %r15
movq    584(%rsp), %rdx
    
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

adcx    %r8, %rdi
adcx    %r9, %rsi
adcx    736(%rsp), %rbx
adcx    744(%rsp), %r10
adcx    752(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
adcx    %rax, %r15

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

movq    %rcx, 216(%rsp)
movq    %rsi, 224(%rsp)
movq    %rbx, 232(%rsp)
movq    %r10, 240(%rsp)
movq    %r11, 248(%rsp)
movq    %r12, 256(%rsp)
movq    %r13, 264(%rsp)
movq    %r14, 272(%rsp)
movq    %r15, 280(%rsp)

// T5 ← T1 · T4
xorq    %rdx, %rdx
movq    664(%rsp), %rdx    

mulx    448(%rsp), %r8, %r9
mulx    456(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    464(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    472(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    480(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    488(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    496(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    504(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    512(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    672(%rsp), %rdx
   
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    680(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 736(%rsp)

xorq    %r10, %r10
movq    688(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rax
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
adcq    $0, %r10			

movq    %r11, 744(%rsp)

xorq    %r11, %r11
movq    696(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rax
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
adcq    $0, %r11			

movq    %r12, 752(%rsp)

xorq    %r12, %r12
movq    704(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 760(%rsp)

xorq    %r13, %r13
movq    712(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 768(%rsp)

xorq    %r14, %r14
movq    720(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
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
adcq    $0, %r14 	    
   
movq    %r15, 776(%rsp)

xorq    %r15, %r15
movq    728(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

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
adcx    736(%rsp), %rbx
adcx    744(%rsp), %r10
adcx    752(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
adcx    %rax, %r15

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

// T6 ← T5
movq    %rcx, %r8
movq    %rsi, %r9
movq    %rbx, %rax
movq    %r10, %rdx
movq    %r11, %rbp
movq    %r12, %rdi
movq    %r13, 736(%rsp)
movq    %r14, 744(%rsp)
movq    %r15, 752(%rsp)

// X2 ← T5 + Z2
addq    216(%rsp), %rcx
adcq    224(%rsp), %rsi
adcq    232(%rsp), %rbx
adcq    240(%rsp), %r10
adcq    248(%rsp), %r11
adcq    256(%rsp), %r12
adcq    264(%rsp), %r13
adcq    272(%rsp), %r14
adcq    280(%rsp), %r15

movq    %rcx, 144(%rsp) 
movq    %rsi, 152(%rsp)
movq    %rbx, 160(%rsp)
movq    %r10, 168(%rsp)
movq    %r11, 176(%rsp)
movq    %r12, 184(%rsp)
movq    %r13, 192(%rsp)
movq    %r14, 200(%rsp)
movq    %r15, 208(%rsp)

movq    736(%rsp), %rcx
movq    744(%rsp), %rbx
movq    752(%rsp), %rsi

// Z2 ← T6 - Z2
addq    _4p0,   %r8
adcq    _4p1_7, %r9
adcq    _4p1_7, %rax
adcq    _4p1_7, %rdx
adcq    _4p1_7, %rbp
adcq    _4p1_7, %rdi
adcq    _4p1_7, %rcx
adcq    _4p1_7, %rbx
adcq    _4p8,   %rsi

subq    216(%rsp), %r8
sbbq    224(%rsp), %r9
sbbq    232(%rsp), %rax
sbbq    240(%rsp), %rdx
sbbq    248(%rsp), %rbp
sbbq    256(%rsp), %rdi
sbbq    264(%rsp), %rcx
sbbq    272(%rsp), %rbx
sbbq    280(%rsp), %rsi

movq    %r8,  216(%rsp)
movq    %r9,  224(%rsp)
movq    %rax, 232(%rsp)
movq    %rdx, 240(%rsp)
movq    %rbp, 248(%rsp)
movq    %rdi, 256(%rsp)
movq    %rcx, 264(%rsp)
movq    %rbx, 272(%rsp)
movq    %rsi, 280(%rsp)

// X3 ← X2^2
xorq    %rdx, %rdx
movq    144(%rsp), %rdx
    
mulx    152(%rsp), %r9, %r10

mulx    160(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    168(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    176(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    184(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    192(%rsp), %rcx, %r15
adcx    %rcx, %r14

mulx    200(%rsp), %rcx, %rax
adcx    %rcx, %r15
    
mulx    208(%rsp), %rcx, %rsi
adcx    %rcx, %rax
adcq    $0, %rsi			

movq    %r9, 736(%rsp)

movq    152(%rsp), %rdx
xorq    %r8, %r8
    
mulx    160(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    200(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi
    
mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcq    $0, %r8

movq    %r10, 744(%rsp)

movq    160(%rsp), %rdx
xorq    %r9, %r9

mulx    168(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    200(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
adcq    $0, %r9

movq    %r11, 752(%rsp)

movq    168(%rsp), %rdx
xorq    %r10, %r10

mulx    176(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    200(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
    
mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
adcq    $0, %r10

movq    %r12, 760(%rsp)

movq    176(%rsp), %rdx
xorq    %r11, %r11

mulx    184(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9

mulx    200(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
adcq    $0, %r11

movq    %r13, 768(%rsp)

movq    184(%rsp), %rdx
xorq    %r12, %r12

mulx    192(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10

mulx    200(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcq    $0, %r12			

movq    %r14, 776(%rsp)

movq    192(%rsp), %rdx
xorq    %r13, %r13

mulx    200(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
 
mulx    208(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcq    $0, %r13

movq    200(%rsp), %rdx

mulx    208(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

movq    760(%rsp), %rbp
movq    768(%rsp), %rcx
movq    776(%rsp), %rdx

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
movq    %rcx, 760(%rsp)
movq    %rdx, 768(%rsp)
movq    %r15, 776(%rsp)
movq    736(%rsp), %rcx
movq    744(%rsp), %rdx
movq    752(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 736(%rsp)		
movq    %rdx, 744(%rsp)		
movq    %r15, 752(%rsp)		
movq    %rbp, 784(%rsp)
    
xorq    %rdx, %rdx
movq    144(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 792(%rsp)
movq    736(%rsp), %rax
adcx    %rbp, %rax 

movq    152(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    744(%rsp), %rcx
adcx    752(%rsp), %rbp
movq    %rcx, 744(%rsp)
movq    %rbp, 752(%rsp)

movq    160(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    784(%rsp), %rcx
adcx    760(%rsp), %rbp
movq    %rcx, 784(%rsp)
movq    %rbp, 760(%rsp)

movq    168(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    768(%rsp), %rcx
adcx    776(%rsp), %rbp
movq    %rcx, 768(%rsp)
movq    %rbp, 776(%rsp)

movq    176(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    792(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 792(%rsp)

movq    184(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r8
adcx    %rbp, %r9

movq    192(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r10
adcx    %rbp, %r11

movq    200(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r12
adcx    %rbp, %r13

movq    208(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r14

movq    792(%rsp), %rcx

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
adcx    744(%rsp), %r9
adcx    752(%rsp), %r10
adcx    784(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
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

// update X3
movq    %r15, 288(%rsp) 
movq    %r8,  296(%rsp)
movq    %r9,  304(%rsp)
movq    %r10, 312(%rsp)
movq    %r11, 320(%rsp)
movq    %r12, 328(%rsp)
movq    %r13, 336(%rsp)
movq    %r14, 344(%rsp)
movq    %rbp, 352(%rsp)

// Z2 ← Z2^2
xorq    %rdx, %rdx
movq    216(%rsp), %rdx
    
mulx    224(%rsp), %r9, %r10

mulx    232(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    240(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    248(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    256(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    264(%rsp), %rcx, %r15
adcx    %rcx, %r14

mulx    272(%rsp), %rcx, %rax
adcx    %rcx, %r15
    
mulx    280(%rsp), %rcx, %rsi
adcx    %rcx, %rax
adcq    $0, %rsi			

movq    %r9, 736(%rsp)

movq    224(%rsp), %rdx
xorq    %r8, %r8
    
mulx    232(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    240(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    264(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi
    
mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcq    $0, %r8

movq    %r10, 744(%rsp)

movq    232(%rsp), %rdx
xorq    %r9, %r9

mulx    240(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    264(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
adcq    $0, %r9

movq    %r11, 752(%rsp)

movq    240(%rsp), %rdx
xorq    %r10, %r10

mulx    248(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    264(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
    
mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
adcq    $0, %r10

movq    %r12, 760(%rsp)

movq    248(%rsp), %rdx
xorq    %r11, %r11

mulx    256(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    264(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
adcq    $0, %r11

movq    %r13, 768(%rsp)

movq    256(%rsp), %rdx
xorq    %r12, %r12

mulx    264(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcq    $0, %r12			

movq    %r14, 776(%rsp)

movq    264(%rsp), %rdx
xorq    %r13, %r13

mulx    272(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
 
mulx    280(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcq    $0, %r13

movq    272(%rsp), %rdx

mulx    280(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

movq    760(%rsp), %rbp
movq    768(%rsp), %rcx
movq    776(%rsp), %rdx

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
movq    %rcx, 760(%rsp)
movq    %rdx, 768(%rsp)
movq    %r15, 776(%rsp)
movq    736(%rsp), %rcx
movq    744(%rsp), %rdx
movq    752(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 736(%rsp)		
movq    %rdx, 744(%rsp)		
movq    %r15, 752(%rsp)		
movq    %rbp, 784(%rsp)
    
xorq    %rdx, %rdx
movq    216(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 792(%rsp)
movq    736(%rsp), %rax
adcx    %rbp, %rax 

movq    224(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    744(%rsp), %rcx
adcx    752(%rsp), %rbp
movq    %rcx, 744(%rsp)
movq    %rbp, 752(%rsp)

movq    232(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    784(%rsp), %rcx
adcx    760(%rsp), %rbp
movq    %rcx, 784(%rsp)
movq    %rbp, 760(%rsp)

movq    240(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    768(%rsp), %rcx
adcx    776(%rsp), %rbp
movq    %rcx, 768(%rsp)
movq    %rbp, 776(%rsp)

movq    248(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    792(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 792(%rsp)

movq    256(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r8
adcx    %rbp, %r9

movq    264(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r10
adcx    %rbp, %r11

movq    272(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r12
adcx    %rbp, %r13

movq    280(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r14

movq    792(%rsp), %rcx

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
adcx    744(%rsp), %r9
adcx    752(%rsp), %r10
adcx    784(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
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

movq    %r15, 216(%rsp)
movq    %r8,  224(%rsp)
movq    %r9,  232(%rsp)
movq    %r10, 240(%rsp)
movq    %r11, 248(%rsp)
movq    %r12, 256(%rsp)
movq    %r13, 264(%rsp)
movq    %r14, 272(%rsp)
movq    %rbp, 280(%rsp)

// Z3 ← Z2 · X1
xorq    %rdx, %rdx
movq    216(%rsp), %rdx    

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
movq    224(%rsp), %rdx
   
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
movq    232(%rsp), %rdx
    
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

movq    %r10, 736(%rsp)

xorq    %r10, %r10
movq    240(%rsp), %rdx
    
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

movq    %r11, 744(%rsp)

xorq    %r11, %r11
movq    248(%rsp), %rdx
    
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

movq    %r12, 752(%rsp)

xorq    %r12, %r12
movq    256(%rsp), %rdx
    
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

movq    %r13, 760(%rsp)

xorq    %r13, %r13
movq    264(%rsp), %rdx
    
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

movq    %r14, 768(%rsp)

xorq    %r14, %r14
movq    272(%rsp), %rdx
    
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
   
movq    %r15, 776(%rsp)

xorq    %r15, %r15
movq    280(%rsp), %rdx
    
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
adcx    736(%rsp),  %rbx
adcx    744(%rsp),  %r10
adcx    752(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
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

// update Z3
movq    %rdi, 360(%rsp) 
movq    %rsi, 368(%rsp)
movq    %rbx, 376(%rsp)
movq    %r10, 384(%rsp)
movq    %r11, 392(%rsp)
movq    %r12, 400(%rsp)
movq    %r13, 408(%rsp)
movq    %r14, 416(%rsp)
movq    %r15, 424(%rsp)

movb	432(%rsp), %cl
movb	436(%rsp), %bl
shrb    %cl, %bl
andb    $1, %bl
movb    %bl, %cl
xorb    434(%rsp), %bl
movb    %cl, 434(%rsp)

cmpb    $1, %bl

// CSelect(T1,T2,T3,T4,swap)
movq    448(%rsp), %r8
movq    456(%rsp), %r9
movq    464(%rsp), %r10
movq    472(%rsp), %r11
movq    480(%rsp), %r12
movq    488(%rsp), %r13
movq    496(%rsp), %r14

movq    592(%rsp), %r15
movq    600(%rsp), %rax
movq    608(%rsp), %rbx
movq    616(%rsp), %rcx
movq    624(%rsp), %rdx
movq    632(%rsp), %rbp
movq    640(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  448(%rsp)
movq    %r9,  456(%rsp)
movq    %r10, 464(%rsp)
movq    %r11, 472(%rsp)
movq    %r12, 480(%rsp)
movq    %r13, 488(%rsp)
movq    %r14, 496(%rsp)

movq    504(%rsp), %r13
movq    512(%rsp), %r14
movq    648(%rsp), %rbp
movq    656(%rsp), %rsi
cmove   %rbp, %r13
cmove   %rsi, %r14
movq    %r13, 504(%rsp)
movq    %r14, 512(%rsp)

movq    520(%rsp), %r8
movq    528(%rsp), %r9
movq    536(%rsp), %r10
movq    544(%rsp), %r11
movq    552(%rsp), %r12
movq    560(%rsp), %r13
movq    568(%rsp), %r14

movq    664(%rsp), %r15
movq    672(%rsp), %rax
movq    680(%rsp), %rbx
movq    688(%rsp), %rcx
movq    696(%rsp), %rdx
movq    704(%rsp), %rbp
movq    712(%rsp), %rsi

cmove   %r15, %r8
cmove   %rax, %r9
cmove   %rbx, %r10
cmove   %rcx, %r11
cmove   %rdx, %r12
cmove   %rbp, %r13
cmove   %rsi, %r14

movq    %r8,  520(%rsp)
movq    %r9,  528(%rsp)
movq    %r10, 536(%rsp)
movq    %r11, 544(%rsp)
movq    %r12, 552(%rsp)
movq    %r13, 560(%rsp)
movq    %r14, 568(%rsp)

movq    576(%rsp), %r13
movq    584(%rsp), %r14
movq    720(%rsp), %rbp
movq    728(%rsp), %rsi
cmove   %rbp, %r13
cmove   %rsi, %r14
movq    %r13, 576(%rsp)
movq    %r14, 584(%rsp)

// T2 ← T2^2
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

movq    %r9, 736(%rsp)

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

movq    %r10, 744(%rsp)

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

movq    %r11, 752(%rsp)

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

movq    %r12, 760(%rsp)

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

movq    %r13, 768(%rsp)

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

movq    %r14, 776(%rsp)

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

movq    760(%rsp), %rbp
movq    768(%rsp), %rcx
movq    776(%rsp), %rdx

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
movq    %rcx, 760(%rsp)
movq    %rdx, 768(%rsp)
movq    %r15, 776(%rsp)
movq    736(%rsp), %rcx
movq    744(%rsp), %rdx
movq    752(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 736(%rsp)		
movq    %rdx, 744(%rsp)		
movq    %r15, 752(%rsp)		
movq    %rbp, 784(%rsp)
    
xorq    %rdx, %rdx
movq    520(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 792(%rsp)
movq    736(%rsp), %rax
adcx    %rbp, %rax 

movq    528(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    744(%rsp), %rcx
adcx    752(%rsp), %rbp
movq    %rcx, 744(%rsp)
movq    %rbp, 752(%rsp)

movq    536(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    784(%rsp), %rcx
adcx    760(%rsp), %rbp
movq    %rcx, 784(%rsp)
movq    %rbp, 760(%rsp)

movq    544(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    768(%rsp), %rcx
adcx    776(%rsp), %rbp
movq    %rcx, 768(%rsp)
movq    %rbp, 776(%rsp)

movq    552(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    792(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 792(%rsp)

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

movq    792(%rsp), %rcx

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
adcx    744(%rsp), %r9
adcx    752(%rsp), %r10
adcx    784(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
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

movq    %r15, 520(%rsp)
movq    %r8,  528(%rsp)
movq    %r9,  536(%rsp)
movq    %r10, 544(%rsp)
movq    %r11, 552(%rsp)
movq    %r12, 560(%rsp)
movq    %r13, 568(%rsp)
movq    %r14, 576(%rsp)
movq    %rbp, 584(%rsp)

// T1 ← T1^2
xorq    %rdx, %rdx
movq    448(%rsp), %rdx
    
mulx    456(%rsp), %r9, %r10

mulx    464(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    472(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    480(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    488(%rsp), %rcx, %r14
adcx    %rcx, %r13

mulx    496(%rsp), %rcx, %r15
adcx    %rcx, %r14

mulx    504(%rsp), %rcx, %rax
adcx    %rcx, %r15
    
mulx    512(%rsp), %rcx, %rsi
adcx    %rcx, %rax
adcq    $0, %rsi			

movq    %r9, 736(%rsp)

movq    456(%rsp), %rdx
xorq    %r8, %r8
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
adcq    $0, %r8

movq    %r10, 744(%rsp)

movq    464(%rsp), %rdx
xorq    %r9, %r9

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
adcq    $0, %r9

movq    %r11, 752(%rsp)

movq    472(%rsp), %rdx
xorq    %r10, %r10

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rsi

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
adcq    $0, %r10

movq    %r12, 760(%rsp)

movq    480(%rsp), %rdx
xorq    %r11, %r11

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %r8

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r8
adox    %rbp, %r9

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
adcq    $0, %r11

movq    %r13, 768(%rsp)

movq    488(%rsp), %rdx
xorq    %r12, %r12

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
adcq    $0, %r12			

movq    %r14, 776(%rsp)

movq    496(%rsp), %rdx
xorq    %r13, %r13

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
 
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
adcq    $0, %r13

movq    504(%rsp), %rdx

mulx    512(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

movq    760(%rsp), %rbp
movq    768(%rsp), %rcx
movq    776(%rsp), %rdx

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
movq    %rcx, 760(%rsp)
movq    %rdx, 768(%rsp)
movq    %r15, 776(%rsp)
movq    736(%rsp), %rcx
movq    744(%rsp), %rdx
movq    752(%rsp), %r15
shld    $1, %r15, %rbp
shld    $1, %rdx, %r15
shld    $1, %rcx, %rdx
shlq    $1, %rcx

movq    %rcx, 736(%rsp)		
movq    %rdx, 744(%rsp)		
movq    %r15, 752(%rsp)		
movq    %rbp, 784(%rsp)
    
xorq    %rdx, %rdx
movq    448(%rsp), %rdx
mulx    %rdx, %r15, %rbp
movq    %rax, 792(%rsp)
movq    736(%rsp), %rax
adcx    %rbp, %rax 

movq    456(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    744(%rsp), %rcx
adcx    752(%rsp), %rbp
movq    %rcx, 744(%rsp)
movq    %rbp, 752(%rsp)

movq    464(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    784(%rsp), %rcx
adcx    760(%rsp), %rbp
movq    %rcx, 784(%rsp)
movq    %rbp, 760(%rsp)

movq    472(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    768(%rsp), %rcx
adcx    776(%rsp), %rbp
movq    %rcx, 768(%rsp)
movq    %rbp, 776(%rsp)

movq    480(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    792(%rsp), %rcx
adcx    %rbp, %rsi
movq    %rcx, 792(%rsp)

movq    488(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r8
adcx    %rbp, %r9

movq    496(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r10
adcx    %rbp, %r11

movq    504(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r12
adcx    %rbp, %r13

movq    512(%rsp), %rdx
mulx    %rdx, %rcx, %rbp
adcx    %rcx, %r14

movq    792(%rsp), %rcx

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
adcx    744(%rsp), %r9
adcx    752(%rsp), %r10
adcx    784(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
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

movq    %r15, 448(%rsp)
movq    %r8,  456(%rsp)
movq    %r9,  464(%rsp)
movq    %r10, 472(%rsp)
movq    %r11, 480(%rsp)
movq    %r12, 488(%rsp)
movq    %r13, 496(%rsp)
movq    %r14, 504(%rsp)
movq    %rbp, 512(%rsp)

// T3 ← T1 - T2
addq    _4p0,   %r15
adcq    _4p1_7, %r8
adcq    _4p1_7, %r9
adcq    _4p1_7, %r10
adcq    _4p1_7, %r11
adcq    _4p1_7, %r12
adcq    _4p1_7, %r13
adcq    _4p1_7, %r14
adcq    _4p8,   %rbp

subq    520(%rsp), %r15
sbbq    528(%rsp), %r8
sbbq    536(%rsp), %r9
sbbq    544(%rsp), %r10
sbbq    552(%rsp), %r11
sbbq    560(%rsp), %r12
sbbq    568(%rsp), %r13
sbbq    576(%rsp), %r14
sbbq    584(%rsp), %rbp

movq    %r15, 592(%rsp) 
movq    %r8,  600(%rsp)
movq    %r9,  608(%rsp)
movq    %r10, 616(%rsp)
movq    %r11, 624(%rsp)
movq    %r12, 632(%rsp)
movq    %r13, 640(%rsp)
movq    %r14, 648(%rsp)
movq    %rbp, 656(%rsp)

// T3 ← T1 · T2
xorq    %rdx, %rdx
movq    520(%rsp), %rdx    

mulx    448(%rsp), %r8, %r9
mulx    456(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    464(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    472(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    480(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    488(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    496(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    504(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    512(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    528(%rsp), %rdx
   
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    536(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 736(%rsp)

xorq    %r10, %r10
movq    544(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rax
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
adcq    $0, %r10			

movq    %r11, 744(%rsp)

xorq    %r11, %r11
movq    552(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rax
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
adcq    $0, %r11			

movq    %r12, 752(%rsp)

xorq    %r12, %r12
movq    560(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 760(%rsp)

xorq    %r13, %r13
movq    568(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 768(%rsp)

xorq    %r14, %r14
movq    576(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
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
adcq    $0, %r14 	    
   
movq    %r15, 776(%rsp)

xorq    %r15, %r15
movq    584(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

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
adcx    736(%rsp), %rbx
adcx    744(%rsp), %r10
adcx    752(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
adcx    %rax, %r15

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

// update X2
movq    %rcx, 144(%rsp) 
movq    %rsi, 152(%rsp)
movq    %rbx, 160(%rsp)
movq    %r10, 168(%rsp)
movq    %r11, 176(%rsp)
movq    %r12, 184(%rsp)
movq    %r13, 192(%rsp)
movq    %r14, 200(%rsp)
movq    %r15, 208(%rsp)

// T1 ← ((A + 2)/4) · T3
xorq    %rdx, %rdx
movq    a24, %rdx

mulx    592(%rsp), %rsi, %rdi
mulx    600(%rsp), %rcx, %rbp
adcx    %rcx, %rdi

mulx    608(%rsp), %rcx, %r8
adcx    %rcx, %rbp

mulx    616(%rsp), %rcx, %r9
adcx    %rcx, %r8

mulx    624(%rsp), %rcx, %r10
adcx    %rcx, %r9

mulx    632(%rsp), %rcx, %r11
adcx    %rcx, %r10

mulx    640(%rsp), %rcx, %r12
adcx    %rcx, %r11

mulx    648(%rsp), %rcx, %r13
adcx    %rcx, %r12

mulx    656(%rsp), %rcx, %r14
adcx    %rcx, %r13
adcq    $0, %r14

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

// T1 ← T1 + T2
addq    520(%rsp), %rsi
adcq    528(%rsp), %rdi
adcq    536(%rsp), %rbp
adcq    544(%rsp), %r8
adcq    552(%rsp), %r9
adcq    560(%rsp), %r10
adcq    568(%rsp), %r11
adcq    576(%rsp), %r12
adcq    584(%rsp), %r13

movq    %rsi, 448(%rsp) 
movq    %rdi, 456(%rsp)
movq    %rbp, 464(%rsp)
movq    %r8,  472(%rsp)
movq    %r9,  480(%rsp)
movq    %r10, 488(%rsp)
movq    %r11, 496(%rsp)
movq    %r12, 504(%rsp)
movq    %r13, 512(%rsp)

// Z2 ← T1 · T3
xorq    %rdx, %rdx
movq    592(%rsp), %rdx    

mulx    448(%rsp), %r8, %r9
mulx    456(%rsp), %rcx, %r10		
adcx    %rcx, %r9

mulx    464(%rsp), %rcx, %r11	
adcx    %rcx, %r10

mulx    472(%rsp), %rcx, %r12	
adcx    %rcx, %r11

mulx    480(%rsp), %rcx, %r13	
adcx    %rcx, %r12

mulx    488(%rsp), %rcx, %r14	
adcx    %rcx, %r13

mulx    496(%rsp), %rcx, %r15	
adcx    %rcx, %r14

mulx    504(%rsp), %rcx, %rax
adcx    %rcx, %r15

mulx    512(%rsp), %rcx, %rdi
adcx    %rcx, %rax
adcq    $0, %rdi    		    		

xorq    %rsi, %rsi
movq    600(%rsp), %rdx
   
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r9
adox    %rbp, %r10
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
adcq    $0, %rsi			

xorq    %rbx, %rbx
movq    608(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx
adcq    $0, %rbx		

movq    %r10, 736(%rsp)

xorq    %r10, %r10
movq    616(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rax
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
adcq    $0, %r10			

movq    %r11, 744(%rsp)

xorq    %r11, %r11
movq    624(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rax
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
adcq    $0, %r11			

movq    %r12, 752(%rsp)

xorq    %r12, %r12
movq    632(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r13
adox    %rbp, %r14
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12			
adcq    $0, %r12			

movq    %r13, 760(%rsp)

xorq    %r13, %r13
movq    640(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r14
adox    %rbp, %r15
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    488(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

mulx    496(%rsp), %rcx, %rbp
adcx    %rcx, %r10
adox    %rbp, %r11

mulx    504(%rsp), %rcx, %rbp
adcx    %rcx, %r11
adox    %rbp, %r12
    
mulx    512(%rsp), %rcx, %rbp
adcx    %rcx, %r12
adox    %rbp, %r13			
adcq    $0, %r13			

movq    %r14, 768(%rsp)

xorq    %r14, %r14
movq    648(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %r15
adox    %rbp, %rax
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    480(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
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
adcq    $0, %r14 	    
   
movq    %r15, 776(%rsp)

xorq    %r15, %r15
movq    656(%rsp), %rdx
    
mulx    448(%rsp), %rcx, %rbp
adcx    %rcx, %rax
adox    %rbp, %rdi
    
mulx    456(%rsp), %rcx, %rbp
adcx    %rcx, %rdi
adox    %rbp, %rsi
    
mulx    464(%rsp), %rcx, %rbp
adcx    %rcx, %rsi
adox    %rbp, %rbx

mulx    472(%rsp), %rcx, %rbp
adcx    %rcx, %rbx
adox    %rbp, %r10

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
adcx    736(%rsp), %rbx
adcx    744(%rsp), %r10
adcx    752(%rsp), %r11
adcx    760(%rsp), %r12
adcx    768(%rsp), %r13
adcx    776(%rsp), %r14
adcx    %rax, %r15

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

// update Z2
movq    %rcx, 216(%rsp)
movq    %rsi, 224(%rsp)
movq    %rbx, 232(%rsp)
movq    %r10, 240(%rsp)
movq    %r11, 248(%rsp)
movq    %r12, 256(%rsp)
movq    %r13, 264(%rsp)
movq    %r14, 272(%rsp)
movq    %r15, 280(%rsp)

movb    432(%rsp), %cl
subb    $1, %cl
movb    %cl, 432(%rsp)
cmpb	$0, %cl
jge     .L2

movb    $7, 432(%rsp)
movq    64(%rsp), %rax
movq    440(%rsp), %r15
subq    $1, %r15
movq    %r15, 440(%rsp)
cmpq	$0, %r15
jge     .L1

movq    56(%rsp), %rdi

movq    144(%rsp),  %r8 
movq    152(%rsp),  %r9
movq    160(%rsp), %r10
movq    168(%rsp), %r11
movq    176(%rsp), %r12
movq    184(%rsp), %r13
movq    192(%rsp), %r14
movq    200(%rsp), %r15
movq    208(%rsp), %rax

// store final value of X2
movq    %r8,   0(%rdi) 
movq    %r9,   8(%rdi)
movq    %r10, 16(%rdi)
movq    %r11, 24(%rdi)
movq    %r12, 32(%rdi)
movq    %r13, 40(%rdi)
movq    %r14, 48(%rdi)
movq    %r15, 56(%rdi)
movq    %rax, 64(%rdi)

movq    216(%rsp),  %r8 
movq    224(%rsp),  %r9
movq    232(%rsp), %r10
movq    240(%rsp), %r11
movq    248(%rsp), %r12
movq    256(%rsp), %r13
movq    264(%rsp), %r14
movq    272(%rsp), %r15
movq    280(%rsp), %rax

// store final value of Z2
movq    %r8,  72(%rdi) 
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
