#include <stdio.h>
int main (void ){
  int x = 3;
  switch (x){
    case 1:{
      printf ("1");
      break;
    }
    case 2:{
      printf ("2");
      break;
    }
    default:{
      printf ("else");
    }
  }
  return 0;
}