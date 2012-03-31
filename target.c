#include <stdio.h>
struct complex {
  double x, y;
};
struct complex create_complex ( double x, double y){
  struct complex z;
  z.x = x;
  z.y = y;
  return z;
};
int main (void ){
  double x = 2.0;
  double y = 3.0;
  struct complex a = create_complex (x, y);
  printf ("%f,%f\n", a.x, a.y);
  return 0;
}