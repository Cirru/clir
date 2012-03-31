#include <stdio.h>
int main (void ){
  struct struct_complex {
    double x, y;
  };
  double x = 3.0;
  struct struct_complex z;
  z.x = x;
  z.y = 4.0;
  if (z.y < 0){
    printf ("%f%fi\n", z.x, z.y);
  }
  else {
    printf ("%f+%fi\n", z.x, z.y);
  }
  return 0;
}