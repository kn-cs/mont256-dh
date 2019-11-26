#/*
#+-----------------------------------------------------------------------------+
#| This code corresponds to the the paper "Efficient Elliptic Curve            |
#| Diffie-Hellman Computation at the 256-bit Security Level" authored by       |
#| Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and            |
#| Palash Sarkar, Indian Statistical Institute, Kolkata, India.	               |
#+-----------------------------------------------------------------------------+
#| Copyright (c) 2019, Kaushik Nath and Palash Sarkar.                         |
#|                                                                             |
#| Permission to use this code is granted.                          	       |
#|                                                                             |
#| Redistribution and use in source and binary forms, with or without          |
#| modification, are permitted provided that the following conditions are      |
#| met:                                                                        |
#|                                                                             |
#| * Redistributions of source code must retain the above copyright notice,    |
#|   this list of conditions and the following disclaimer.                     |
#|                                                                             |
#| * Redistributions in binary form must reproduce the above copyright         |
#|   notice, this list of conditions and the following disclaimer in the       |
#|   documentation and/or other materials provided with the distribution.      |
#|                                                                             |
#| * The names of the contributors may not be used to endorse or promote       |
#|   products derived from this software without specific prior written        |
#|   permission.                                                               |
#+-----------------------------------------------------------------------------+
#| THIS SOFTWARE IS PROVIDED BY THE AUTHORS ""AS IS"" AND ANY EXPRESS OR       |
#| IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   |
#| OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.     |
#| IN NO EVENT SHALL THE CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,      |
#| INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT    |
#| NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   |
#| DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY       |
#| THEORY LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING |
#| NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,| 
#| EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                          |
#+-----------------------------------------------------------------------------+
#*/

INCDRS = -I../include/

SRCFLS = ../source/M1504058_const.S 		\
	 ../source/M1504058_mladder.S		\
	 ../source/gf_p5211_mul.S 		\
	 ../source/gf_p5211_nsqr.S 		\
	 ../source/gf_p5211_inv.c 		\
	 ../source/gf_p5211_makeunique.c 	\
	 ../source/M1504058_shared_secret.c	\
	 ../source/gf_p5211_pack.c		\
	  ./M1504058_test.c
         
OBJFLS = ../source/M1504058_const.o 		\
	 ../source/M1504058_mladder.o		\
	 ../source/gf_p5211_mul.o 		\
	 ../source/gf_p5211_nsqr.o 		\
	 ../source/gf_p5211_inv.o 		\
	 ../source/gf_p5211_makeunique.o 	\
	 ../source/M1504058_shared_secret.o	\
	 ../source/gf_p5211_pack.o		\
	  ./M1504058_test.o

EXE    = M1504058_test

CFLAGS = -march=skylake -mtune=skylake -m64 -O3 -funroll-loops -fomit-frame-pointer

CC     = gcc
LL     = gcc

$(EXE): $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) -lm -no-pie

.c.o:
	$(CC) $(INCDRS) $(CFLAGS) -o $@ -c $<

clean:
	-rm $(EXE)
	-rm $(OBJFLS)
