# Implementation of shared secret computation for the curve M[2^(506)-45,996558]

Implementation name		: 	intel64-64-maax

Reference instructions	: 	mulx/adcx/adox

Scalarmult cpu-cycles		: 	Skylake - 558757, Kaby Lake - 538971

This implementation corresponds to the paper "Efficient Elliptic Curve Diffie-Hellman Computation at the 256-bit Security Level" authored by

    Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and   
    Palash Sarkar, Indian Statistical Institute, Kolkata, India.

There are three directories, namely "include", "source", and "test" in the package. 
The description of the files in each directory are listed below:

include/basic_types.h  		:  Defines basic datatypes.

include/measure.h   		:  Defines timing function for measuring median cpu-cycles.

include/gf_p50645_type.h    :  Defines type of a field element in GF[2^(506)-45].

include/gf_p50645_arith.h   :  Declares prototypes of field arithmetic functions in GF[2^(506)-45].

include/gf_p50645_pack.h    :  Declares prototypes of functions for byte to 64-bit integer conversion of field elements and vice versa.

include/M996558.h    		:  Declares prototypes of functions for Montgomery ladder and variable base scalar multiplication.

source/M996558_smult.c		:  Defines the functions of Montgomery ladder and variable base scalar multiplication.

source/M996558_ladder.S		:  Defines the assembly source of Montgomery ladder.

source/gf_p50645_mul.S		:  Defines the assembly source of field multiplication.

source/gf_p50645_nsqr.S		:  Defines the assembly source of n-times feedback field squaring.

source/gf_p50645_consts.S	:  Defines the assembly constants.

source/gf_p50645_inv.c		:  Defines the function for field inversion using FLT.

source/gf_p50645_pack.c		:  Defines functions for byte to 64-bit integer conversion of field elements and vice versa.

source/gf_p50645_makeunique.c	:  Defines the function to get unique representation of field-elements in GF[2^(506)-45].

test/M996558_test.c		    :  Defines the test function.

test/M996558.mak		    :  Defines the make file.
    
For compilation, one needs to use the command "make -f M996558.mak", and execute the generated executable file named "M996558_test".
