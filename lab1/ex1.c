#include <stdio.h>
#include "ex1.h"

#define N std

int main(int argc, char *argv[]){
  ulint n = 10;
  printf("factorial of %ld is %ld\n",n,fact(n));
  return 0;
}


