#include "CompressorTest.hpp"
#include "VComp73.h"

int main(void) {
  vg::comp_test<VComp73, 7>();
  Verilated::threadContextp()->coveragep()->write("comp73.dat");
}
