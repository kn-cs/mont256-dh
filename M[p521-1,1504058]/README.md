# Implementation of shared secret computation for the curve M[2^(521)-1,1504058]

Implementation name		: 	intel64-64-maax

Reference instructions	: 	mulx/adcx/adox

Scalarmult cpu-cycles	: 	Skylake - 689588, Kaby Lake - 666044

This implementation corresponds to the paper "Efficient Elliptic Curve Diffie-Hellman Computation at the 256-bit Security Level" authored by

    Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and   
    Palash Sarkar, Indian Statistical Institute, Kolkata, India.

There are three directories, namely "include", "source", and "test" in the package. 
The description of the files in each directory are listed below:

include/basic_types.h  		:  Defines basic datatypes.

include/measure.h   		:  Defines timing function for measuring median cpu-cycles.

include/gf_p5211_type.h    	:  Defines type of a field element in GF[2^(521)-1].

include/gf_p5211_arith.h    	:  Declares prototypes of field arithmetic functions in GF[2^(521)-1].

include/gf_p5211_pack.h    	:  Declares prototypes of functions for byte to 64-bit integer conversion of field elements and vice versa.

include/M1504058.h    		:  Declares prototypes of functions for Montgomery ladder and variable base scalar multiplication.

source/M1504058_smult.c		:  Defines the functions of Montgomery ladder and variable base scalar multiplication.

source/M1504058_ladder.S	:  Defines the assembly source of Montgomery ladder.

source/gf_p5211_mul.S		:  Defines the assembly source of field multiplication.

source/gf_p5211_nsqr.S		:  Defines the assembly source of n-times feedback field squaring.

source/gf_p5211_consts.S	:  Defines the assembly constants.

source/gf_p5211_inv.c		:  Defines the function for field inversion using FLT.

source/gf_p5211_pack.c		:  Defines functions for byte to 64-bit integer conversion of field elements and vice versa.

source/gf_p5211_makeunique.c	:  Defines the function to get unique representation of field-elements in GF[2^(521)-1].

test/M1504058_test.c		:  Defines the test function.

test/M1504058.mak		:  Defines the make file.
    
For compilation, one needs to use the command "make -f M1504058.mak", and execute the generated executable file named "M1504058_test".
