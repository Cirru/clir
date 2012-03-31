#include <stdio.h>
int fractical (int  n){
  int result = 1;
  int i;
  for (i=1; i<=n; i+=1){
    result *= i;
  }
  return result;
}
int main (void ){
  int result = fractical (4);
  printf ("%d", result);
  return 0;
}