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
                 (90276238156286715146283000457739621573202401727047291659648075983706224516485, [0xc7, 0x96, 0x8a, 0x42, 0x4d, 0x5d, 0xbd, 0x94, 0x2b, 0xae, 0x69, 0x89, 0xe8, 0x41, 0x8a, 0x67, 0xfa, 0x38, 0x53, 0x81, 0xa7, 0xc7, 0x59, 0x0e, 0xe0, 0x19, 0x8d, 0x35, 0x60, 0x3a, 0xdd, 0x85]))
        @testset "int2bytes" begin
            for t in tests
                @test int2bytes(t[1]) == t[2]
            end
        end
        @testset "bytes2int" begin
            for t in tests
                @test bytes2int(t[2]) == t[1]
            end
        end
end
