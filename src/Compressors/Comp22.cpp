#include "CompressorTest.hpp"
#include "VComp22.h"

int main(void) {
  vg::comp_test<VComp22, 2>();
  Verilated::threadContextp()->coveragep()->write("comp22.dat");
}
