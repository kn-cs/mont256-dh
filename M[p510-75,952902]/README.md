# Implementation of shared secret computation for the curve M[2^(510)-75,952902]

Implementation name		: 	intel64-64-maax

Reference instructions	: 	mulx/adcx/adox

Scalarmult cpu-cycles	: 	Skylake - 566088, Kaby Lake - 546849

This implementation corresponds to the paper "Efficient Elliptic Curve Diffie-Hellman Computation at the 256-bit Security Level" authored by

    Kaushik Nath,  Indian Statistical Institute, Kolkata, India, and   
    Palash Sarkar, Indian Statistical Institute, Kolkata, India.

There are three directories, namely "include", "source", and "test" in the package. 
The description of the files in each directory are listed below:

include/basic_types.h  		    :  Defines basic datatypes.

include/measure.h   		    :  Defines timing function for measuring median cpu-cycles.

include/gf_p51075_type.h    	:  Defines type of a field element in GF[2^(510)-75].

include/gf_p51075_arith.h    	:  Declares prototypes of field arithmetic functions in GF[2^(510)-75].

include/gf_p51075_pack.h    	:  Declares prototypes of functions for byte to 64-bit integer conversion of field elements and vice versa.

include/M952902.h    		    :  Declares prototypes of functions for Montgomery ladder and shared secret computation.

source/M952902_shared_secret.c	:  Defines the function for shared secret computation.

source/M952902_mladder.S		:  Defines the assembly source of the Montgomery ladder.

source/gf_p51075_mul.S		    :  Defines the assembly source of field multiplication.

source/gf_p51075_nsqr.S		    :  Defines the assembly source of n-times feedback field squaring.

source/gf_p51075_consts.S	    :  Defines the assembly constants.

source/gf_p51075_inv.c		    :  Defines the function for field inversion using FLT.

source/gf_p51075_pack.c		    :  Defines functions for byte to 64-bit integer conversion of field elements and vice versa.

source/gf_p51075_makeunique.c	:  Defines the function to get unique representation of field-elements in GF[2^(510)-75].

test/M952902_test.c		        :  Defines the test function.

test/M952902.mak		        :  Defines the make file.
    
For compilation, one needs to use the command "make -f M952902.mak", and execute the generated executable file named "M952902_test".
