#include <cassert>

#include "VSinglePortMem.h"


void step(VSinglePortMem& model) {
  model.clk = 1;
  model.eval();
  model.clk = 0;
  model.eval();
}

int main(void) {
  VSinglePortMem model;

  model.clk = 0;
  model.select = 1;
  model.o_enable = 0;
  model.w_enable = 0;
  model.addr = 0;
  model.data = 0;
  step(model);

  model.w_enable = 1;
  model.data = 0xDEADBEEF;
  step(model);

  model.addr = 1;
  model.data = 0xCAFEBABE;
  step(model);

  model.w_enable = 0;
  model.o_enable = 1;
  model.addr = 0;
  step(model);

  assert(model.data == 0xDEADBEEF);

  model.o_enable = 0;
  model.addr = 1;
  step(model);

  model.o_enable = 1;
  model.eval();

  assert(model.data == 0xCAFEBABE);

  Verilated::threadContextp()->coveragep()->write();
}
