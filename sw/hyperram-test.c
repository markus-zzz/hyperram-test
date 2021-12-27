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

int main(void) {
  *R_PORT_0 = 0x12345678;
  *R_PORT_1 = 0x11112222;
  return 0;
}
