"""
    Copyright (C) 2018 Simon Castano

    This file is part of ECC.jl

    ECC.jl is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    ECC.jl is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with ECC.jl.  If not, see <https://www.gnu.org/licenses/>.
"""

@testset "Bytes - Integer Convertions" begin
        tests = ((11, [0x0b]),
                 (18145,[0x46, 0xe1]),
                 (big(18)^256, [0x0b, 0x51, 0xea, 0xa7, 0x75, 0x9a, 0x45, 0x93,
                  0x57, 0xc0, 0x6f, 0x65, 0x48, 0x7c, 0xe1, 0x8f, 0x23, 0xcf,
                  0x2b, 0x52, 0xbb, 0xab, 0x34, 0x98, 0x3e, 0x22, 0xb2, 0xa5,
                  0xca, 0xdd, 0xe3, 0x3f, 0xcb, 0x0f, 0x1a, 0x5a, 0xbf, 0xca,
                  0x90, 0xc4, 0xf8, 0x13, 0x28, 0x05, 0x2d, 0x31, 0x1f, 0xe7,
                  0x77, 0x93, 0x41, 0x7d, 0xd7, 0x70, 0x5c, 0x83, 0x09, 0x8e,
                  0xc0, 0xc7, 0x32, 0xe0, 0xf9, 0xc8, 0x7f, 0xe3, 0xaa, 0x65,
                  0xac,0x28, 0x94, 0x83, 0x76, 0x0f, 0xbd, 0x2a, 0x7e, 0x53,
                  0x35, 0xbd, 0x07, 0x5f, 0x4d, 0x13, 0xeb, 0xbd, 0x76, 0x79,
                  0xef, 0x1b, 0x43, 0x06, 0x89, 0x0c, 0x1d, 0x66, 0x0d, 0x12,
                  0x76, 0xf1, 0xe8, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                  0x00, 0x00, 0x00, 0x00, 0x00, 0x00]))
        @testset "int2bytes" begin
            for t in tests
                @test int2bytes(t[1]) == t[2]
            end
        end
        @testset "bytes2big" begin
            for t in tests
                @test bytes2big(t[2]) == t[1]
            end
        end
end
