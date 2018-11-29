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
    hex = string(x, base=16)
    if mod(length(hex), 2) != 0
        hex = string("0", hex)
    end
    return hex2bytes(hex)
end

"""
Convert bytes array to Integer

bytes2int(x::Array{UInt8,1}) -> BigInt
"""
function bytes2int(x::Array{UInt8,1})
    hex = bytes2hex(x)
    return parse(BigInt, hex, base=16)
end
