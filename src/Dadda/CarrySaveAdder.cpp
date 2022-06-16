#include <cassert>

#include "VCarrySaveAdder.h"

int main(void) {
  VCarrySaveAdder model;

  model.a = 0;
  model.b = 0;
  model.c = 0;
  do {
    do {
      do {
        model.eval();
        for(int i {1}; i < (1 << 8); i <<= 1) {
          int sum {!!(model.a & i) + !!(model.b & i) + !!(model.c & i)};
          int count {2 * !!(model.carry & i) + !!(model.sum & i)};
          assert(sum == count);
        }
      } while(++model.c > 0 && model.a < (1 << 8));
    } while(++model.b > 0 && model.b < (1 << 8));
  } while(++model.a > 0 && model.c < (1 << 8));

  Verilated::threadContextp()->coveragep()->write("carrysaveadder.dat");
}
