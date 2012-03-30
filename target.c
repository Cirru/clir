#include <stdio.h>
void  newline (void ){
  printf ("\n");
}
void  threeNewline (void ){
  newline ();
  newline ();
  newline ();
}
int main (void ){
  printf ("first line\n");
  threeNewline ();
  printf ("second line\n");
  return 0;
}