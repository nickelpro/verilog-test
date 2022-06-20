#include <cassert>

#include "VPartialProduct.h"

int main(void) {
  VPartialProduct model;

  model.a = 0;
  model.b = 0;

  do {
    do {
      model.eval();
      for(int i {0}; i < 8; ++i) {
        for(int j {0}; j < 8; ++j) {
          int pp {!!(model.pp & (1ULL << ((i << 3) | j)))};
          int a {!!(model.a & (1 << i))};
          int b {!!(model.b & (1 << j))};
          assert(pp == (a & b));
        }
      }
    } while(++model.b > 0 && model.b < (1 << 8));
  } while(++model.a > 0 && model.a < (1 << 8));

  Verilated::threadContextp()->coveragep()->write("partialproduct.dat");
}
