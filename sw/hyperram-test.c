/*
 * Copyright (C) 2019-2021 Markus Lavin (https://www.zzzconsulting.se/)
 *
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */

#include <stdint.h>

#define R_PORT_0 ((volatile uint32_t*)0x30000000)
#define R_PORT_1 ((volatile uint32_t*)0x30000004)
#define R_PORT_2 ((volatile uint32_t*)0x30000008)

#define M_HYPERRAM ((volatile uint32_t*)0x50000000)

int main(void) {
  *R_PORT_0 = 0x11112222;

  // Wait 150us for HyperRAM to power-up.
  for (volatile int i = 0; i < 64; i++);

  *R_PORT_0 = 0x33334444;

  volatile uint32_t *p = M_HYPERRAM;
#if 0
  p[7] = 0x45;

 *R_PORT_0 = p[7];

  return 0;
#endif
  uint32_t fib0 = 0;
  uint32_t fib1 = 1;
  for (int i = 0; i < 1024*128; i++) {
    int fib2 = fib0 + fib1;
    fib0 = fib1;
    fib1 = fib2;
    p[i] = fib2;
  }

  uint32_t pass = 1;
  volatile uint32_t *q = M_HYPERRAM;
  fib0 = 0;
  fib1 = 1;
  for (int i = 0; i < 1024*128; i++) {
    int fib2 = fib0 + fib1;
    fib0 = fib1;
    fib1 = fib2;
    if (q[i] != fib2)
      pass = 0;
  }

  *R_PORT_0 = pass ? 0x12 : 0x0f;

  return 0;
}
