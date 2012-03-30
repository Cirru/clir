
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
and more..  
But I'm not going to describe in detail before finished..  

Maybe it will be useful for some people, but so many years has passed,  
no such languaged created, probably it is just a toy to play.  
