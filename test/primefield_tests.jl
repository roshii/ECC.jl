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

@testset "Field Element Operations" begin
    @testset "Addition" begin
        a = ECC.FieldElement(2, 31)
        b = ECC.FieldElement(15, 31)
        @test a+b == ECC.FieldElement(17, 31)
        a = ECC.FieldElement(17, 31)
        b = ECC.FieldElement(21, 31)
        @test a+b == ECC.FieldElement(7, 31)
    end
    @testset "Subtraction" begin
        a = ECC.FieldElement(29, 31)
        b = ECC.FieldElement(4, 31)
        @test a-b == ECC.FieldElement(25, 31)
        a = ECC.FieldElement(15, 31)
        b = ECC.FieldElement(30, 31)
        @test a-b == ECC.FieldElement(16, 31)
        a = ECC.FieldElement(2, 31)
        b = ECC.FieldElement(29, 31)
        @test a-b == ECC.FieldElement(4, 31)
    end
    @testset "Multiplication" begin
        a = ECC.FieldElement(24, 31)
        b = ECC.FieldElement(19, 31)
        @test a*b == ECC.FieldElement(22, 31)
    end
    @testset "Power" begin
        a = ECC.FieldElement(17, 31)
        @test a^3 == ECC.FieldElement(15, 31)
        a = ECC.FieldElement(5, 31)
        b = ECC.FieldElement(18, 31)
        @test a^5 * b == ECC.FieldElement(16, 31)
    end
    @testset "Division" begin
        a = ECC.FieldElement(3, 31)
        b = ECC.FieldElement(24, 31)
        @test a/b == ECC.FieldElement(4, 31)
        a = ECC.FieldElement(17, 31)
        @test a^-3 == ECC.FieldElement(29, 31)
        a = ECC.FieldElement(4, 31)
        b = ECC.FieldElement(11, 31)
        @test a^-4*b == ECC.FieldElement(13, 31)
    end
end
