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

@testset "Elliptic Curve Point Operations" begin
    @testset "Integer Type" begin
        @testset "Not Equal" begin
            a = ECC.Point(3, -7, 5, 7)
            b = ECC.Point(18, 77, 5, 7)
            @test a != b
            @test !(a != a)
        end
        @testset "On Curve?" begin
            @test_throws DomainError ECC.Point(-2, 4, 5, 7)
            @test typeof(ECC.Point(3, -7, 5, 7)) <: ECC.Point
            @test typeof(ECC.Point(18, 77, 5, 7)) <: ECC.Point
        end
        @testset "Addition" begin
            @testset "Base Case" begin
                a = ECC.Point(∞, ∞, 5, 7)
                b = ECC.Point(2, 5, 5, 7)
                c = ECC.Point(2, -5, 5, 7)
                @test a + b == b
                @test b + a == b
                @test b + c == a
            end

            @testset "Case 1" begin
                a = ECC.Point(3, 7, 5, 7)
                b = ECC.Point(-1, -1, 5, 7)
                @test a + b == ECC.Point(2, -5, 5, 7)
            end

            @testset "Case 2" begin
                a = ECC.Point(-1, 1, 5, 7)
                @test a + a == ECC.Point(18, -77, 5, 7)
            end
        end
    end;

    @testset "FiniteElement Type" begin
        @testset "On curve?" begin
            𝑝 = 223
            𝑎, 𝑏 = ECC.FieldElement(0, 𝑝), ECC.FieldElement(7, 𝑝)

            valid_points = ((192, 105), (17, 56), (1, 193))
            invalid_points = ((200, 119), (42, 99))

            for 𝑃 ∈ valid_points
                𝑥 = ECC.FieldElement(𝑃[1], 𝑝)
                𝑦 = ECC.FieldElement(𝑃[2], 𝑝)
                @test typeof(ECC.Point(𝑥, 𝑦, 𝑎, 𝑏)) <: ECC.Point
            end

            for 𝑃 ∈ invalid_points
                𝑥 = ECC.FieldElement(𝑃[1], 𝑝)
                𝑦 = ECC.FieldElement(𝑃[2], 𝑝)
                @test_throws DomainError ECC.Point(𝑥, 𝑦, 𝑎, 𝑏)
            end
        end
        @testset "Addition" begin
            𝑝 = 223
            𝑎 = ECC.FieldElement(0, 𝑝)
            𝑏 = ECC.FieldElement(7, 𝑝)

            additions = (
                (192, 105, 17, 56, 170, 142),
                (47, 71, 117, 141, 60, 139),
                (143, 98, 76, 66, 47, 71),
                )

            for 𝑛 ∈ additions
                𝑃 = ECC.Point(ECC.FieldElement(𝑛[1],𝑝),ECC.FieldElement(𝑛[2],𝑝),𝑎,𝑏)
                𝑄 = ECC.Point(ECC.FieldElement(𝑛[3],𝑝),ECC.FieldElement(𝑛[4],𝑝),𝑎,𝑏)
                𝑅 = ECC.Point(ECC.FieldElement(𝑛[5],𝑝),ECC.FieldElement(𝑛[6],𝑝),𝑎,𝑏)
                @test 𝑃 + 𝑄 == 𝑅
            end
        end
        @testset "Division" begin
            a = ECC.S256Element(parse(UInt256,"cd320a0da21e65fe9e2ea946383422afb2cfafc0bcef09b2bdac3d17b3faf5aa",base=16))
            b = ECC.S256Element(parse(UInt256,"56039537bf435bdfb928d4e58cec6e34aa566c97f9ac943fdf6bd58aefad3a87",base=16))
            want = ECC.S256Element(parse(UInt256,"a788c8c5318bd5a12be62f4c20cacb71771d73e73afcba96845da8dcb8dd0045",base=16))
            @test a / b == want
        end
        @testset "Scalar Multiplication" begin
            𝑝 = 223
            𝑎 = ECC.FieldElement(0, 𝑝)
            𝑏 = ECC.FieldElement(7, 𝑝)

            multiplications = (
                (2, 192, 105, 49, 71),
                (2, 143, 98, 64, 168),
                (2, 47, 71, 36, 111),
                (4, 47, 71, 194, 51),
                (8, 47, 71, 116, 55),
                (21, 47, 71, ∞, ∞)
                )

            for 𝑛 ∈ multiplications
                λ = 𝑛[1]
                i = 2
                fieldelements = []
                while i < 6
                    if 𝑛[i] == ∞
                        push!(fieldelements, ∞)
                    else
                        push!(fieldelements, ECC.FieldElement(𝑛[i],𝑝))
                    end
                    i += 1
                end
                𝑃 = ECC.Point(fieldelements[1],fieldelements[2],𝑎,𝑏)
                𝑅 = ECC.Point(fieldelements[3],fieldelements[4],𝑎,𝑏)
                @test λ * 𝑃 == 𝑅
            end
        end
    end;
end
