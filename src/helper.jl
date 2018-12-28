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

"""
Convert Integer to bytes array

int2bytes(x::Integer) -> Array{UInt8,1}
"""
function int2bytes(x::Integer)
    result = reinterpret(UInt8, [hton(x)])
    i = findfirst(x -> x != 0x00, result)
    result[i:end]
end

function int2bytes(x::BigInt)
    result = Array{UInt8}(undef, x.size * sizeof(eltype(x.d)))
    unsafe_copyto!(convert(Ptr{eltype(x.d)}, pointer(result)), x.d, x.size)
    if ENDIAN_BOM == 0x04030201
        result = result[end:-1:1]
    end
    i = findfirst(x -> x != 0x00, result)
    result[i:end]
end

"""
Convert bytes array to Integer

bytes2int(x::Array{UInt8,1}) -> BigInt
"""
function bytes2int(x::Array{UInt8,1})
    hex = bytes2hex(x)
    return parse(BigInt, hex, base=16)
end
