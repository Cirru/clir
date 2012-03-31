#include <stdio.h>
#include <stdlib.h>
#define N 10000
int a[N];
void gen_random (int  uppper_bound){
  int i;
  for (i=0; i<=N-1; i+=1){
    a[i] = rand() % uppper_bound;
  }
}
int howmany (int  value){
  int count = 0;
  int i;
  for (i=0; i<=N-1; i+=1){
    if (a[i] == value){
      count += 1;
    }
  }
  return count;
}
int main (void ){
  gen_random (10);
  printf ("value \t how many\n");
  int i;
  for (i=0; i<=9; i+=1){
    printf ("%d \t %d \n", i, howmany(i));
  }
  return 0;
}