#include <cassert>

#include "VDualPortMem.h"


void step(VDualPortMem& model) {
  model.clk = 1;
  model.eval();
  model.clk = 0;
  model.eval();
}

int main(void) {
  VDualPortMem model;

  model.clk = 0;
  model.w_enable = 0;
  model.w_addr = 0;
  model.w_data = 0;
  model.r_addr = 0;
  model.r_data = 0;
  model.eval();

  model.w_enable = 1;
  model.w_data = 0x80808080;
  step(model);

  model.w_addr = 1;
  model.w_data = 0x40404040;
  step(model);

  assert(model.r_data == 0x80808080);

  model.r_addr = 1;
  model.w_enable = 0;
  step(model);

  assert(model.r_data == 0x40404040);
}
