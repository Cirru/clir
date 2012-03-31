#include <stdio.h>
int main (void ){
  int i;
  for (i=1; i<=100; i+=1){
    int j;
    for (j=2; j<=(i-1); j+=1){
      if (i % j == 0){
        break;
      }
    }
    if (j == i){
      printf ("%d\n",i);
    }
  }
  return 0;
}