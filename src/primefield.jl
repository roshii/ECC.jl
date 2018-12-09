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

abstract type PrimeField <: Number end

infield(x::Unsigned,y::Unsigned) = x < y
infield(x::Integer,y::Integer) = x >= 0 && x < y
function -(x::UInt,y::UInt) = x > y ? x - y : y - x + 1 end

"Represents FieldElement type in which 𝑛 ∈ 𝐹𝑝 and 𝑝 ∈ ℙ"
struct FieldElement <: PrimeField
    𝑛::Integer
    𝑝::Integer
    # FieldElement(𝑛::Signed,𝑝::Signed) = new(UInt(𝑛),UInt(𝑝))
    FieldElement(𝑛,𝑝) = !infield(𝑛,𝑝) ? throw(DomainError("𝑛 is not in field range")) : new(𝑛,𝑝)
end

"Formats PrimeField as 𝑛 : 𝐹ₚ"
function show(io::IO, z::PrimeField)
    print(io, z.𝑛, " : 𝐹", z.𝑝)
end

"Returns true if both 𝑛 and 𝑝 are the same"
==(𝑋₁::PrimeField,𝑋₂::PrimeField) = 𝑋₁.𝑝 == 𝑋₂.𝑝 && 𝑋₁.𝑛 == 𝑋₂.𝑛
==(::PrimeField,::Integer) = false


"Adds two numbers of the same field"
function +(𝑋₁::PrimeField,𝑋₂::PrimeField)
    if 𝑋₁.𝑝 != 𝑋₂.𝑝
        throw(DomainError("Cannot operate on two numbers in different Fields"))
    else
        𝑛 = mod(𝑋₁.𝑛 + 𝑋₂.𝑛, 𝑋₁.𝑝)
        return typeof(𝑋₁)(𝑛, 𝑋₁.𝑝)
    end
end

"Substracts two numbers of the same field"
function -(𝑋₁::PrimeField,𝑋₂::PrimeField)
    if 𝑋₁.𝑝 != 𝑋₂.𝑝
        throw(DomainError("Cannot operate on two numbers in different Fields"))
    else
        # if 𝑋₁.𝑛 > 𝑋₂.𝑛
            𝑛 = mod(𝑋₁.𝑛 - 𝑋₂.𝑛, 𝑋₁.𝑝)
        # else
            # 𝑛 = mod(𝑋₂.𝑛 - 𝑋₁.𝑛 + 1, 𝑋₁.𝑝)
        # end
        return typeof(𝑋₁)(𝑛, 𝑋₁.𝑝)
    end
end

"Multiplies two numbers of the same field"
function *(𝑋₁::PrimeField,𝑋₂::PrimeField)
    if 𝑋₁.𝑝 != 𝑋₂.𝑝
        throw(DomainError("Cannot operate on two numbers in different Fields"))
    else
        𝑛 = mod(𝑋₁.𝑛 * 𝑋₂.𝑛, 𝑋₁.𝑝)
        return typeof(𝑋₁)(𝑛, 𝑋₁.𝑝)
    end
end

"Multiplies a PrimeField by an Integer"
function *(𝑐::Integer,𝑋::PrimeField)
    𝑛 = mod(𝑐 * 𝑋.𝑛, 𝑋.𝑝)
    return typeof(𝑋)(𝑛, 𝑋.𝑝)
end

"Returns 𝑋ᵏ using Fermat's Little Theorem"
function ^(𝑋::PrimeField,𝑘::Int)
    𝑛 = powermod(𝑋.𝑛, mod(𝑘, (𝑋.𝑝 - 1)), 𝑋.𝑝)
    return typeof(𝑋)(𝑛, 𝑋.𝑝)
end

"Returns 1/𝑋 as a special case of exponentiation where 𝑘 = -1"
function inv(𝑋::PrimeField)
    𝑛 = powermod(𝑋.𝑛, mod(-1, (𝑋.𝑝 - 1)), 𝑋.𝑝)
    return typeof(𝑋)(𝑛, 𝑋.𝑝)
end

"Returns 𝑋₁/𝑋₂ using Fermat's Little Theorem"
function /(𝑋₁::PrimeField,𝑋₂::PrimeField)
    if 𝑋₁.𝑝 != 𝑋₂.𝑝
        throw(DomainError("Cannot operate on two numbers in different Fields"))
    else
        𝑛 = mod(𝑋₁.𝑛 * powermod(𝑋₂.𝑛, 𝑋₁.𝑝 - 2, 𝑋₁.𝑝), 𝑋₁.𝑝)
        return typeof(𝑋₁)(𝑛, 𝑋₁.𝑝)
    end
end
