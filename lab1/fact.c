#include "ex1.h"

ulint fact(ulint n){
  if (n==0)return 1;
  if (n==1)return 1;
  return n*fact(n-1);
}