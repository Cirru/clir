
A small piece of code converting syntax sugar code to C code.  
`# include` syntax would be simplified:  

    #include stdio.h math
for:

    #include <stdio.h>
    #include "math.h"

`main` function be more clear  
  
    void: main $
      printf "x"
for:
  
    void main(){
      printff("x");
    }
