"""
    Copyright (C) 2018-2019 Simon Castano

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
Convert Integer to Array{UInt8}

int2bytes(x::Integer) -> Array{UInt8,1}
"""
function int2bytes(x::Integer)
    result = reinterpret(UInt8, [hton(x)])
    i = findfirst(x -> x != 0x00, result)
    result[i:end]
end

function int2bytes(x::BigInt)
    n_bytes_with_zeros = x.size * sizeof(Sys.WORD_SIZE)
    uint8_ptr = convert(Ptr{UInt8}, x.d)
    n_bytes_without_zeros = 1

    if ENDIAN_BOM == 0x04030201
        # the minimum should be 1, else the result array will be of
        # length 0
        for i in n_bytes_with_zeros:-1:1
            if unsafe_load(uint8_ptr, i) != 0x00
                n_bytes_without_zeros = i
                break
            end
        end

        result = Array{UInt8}(undef, n_bytes_without_zeros)

        for i in 1:n_bytes_without_zeros
            @inbounds result[n_bytes_without_zeros + 1 - i] = unsafe_load(uint8_ptr, i)
        end
    else
        for i in 1:n_bytes_with_zeros
            if unsafe_load(uint8_ptr, i) != 0x00
                n_bytes_without_zeros = i
                break
            end
        end

        result = Array{UInt8}(undef, n_bytes_without_zeros)

        for i in 1:n_bytes_without_zeros
            @inbounds result[i] = unsafe_load(uint8_ptr, i)
        end
    end
    return result
end

"""
Convert UInt8 Array to Integers

bytes2big(x::Array{UInt8,1}) -> BigInt
"""
function bytes2int(x::Array{UInt8,1})
    if length(x) > 8
        bytes2big(x)
    else
        if Sys.WORD_SIZE == 64
            T = Int64
        elseif Sys.WORD_SIZE == 32
            T = Int32
        else
            error("not implemented")
        end
        missing_zeros = div(Sys.WORD_SIZE, 8) -  length(x)
        if missing_zeros > 0
            for i in 1:missing_zeros
                pushfirst!(x,0x00)
            end
        end
        if ENDIAN_BOM == 0x04030201
            reverse!(x)
        end
        return reinterpret(T, x)[1]
    end
end

function bytes2big(x::Array{UInt8,1})
    hex = bytes2hex(x)
    return parse(BigInt, hex, base=16)
end

# TODO
# Correct function errors
function faster_bytes2big(x::Array{UInt8,1})
    xsize = cld(length(x), Base.GMP.BITS_PER_LIMB / 8)
    if ENDIAN_BOM == 0x04030201
        reverse!(x)
    end
    result = Base.GMP.MPZ.realloc2(xsize * Base.GMP.BITS_PER_LIMB)
    result.size = xsize
    unsafe_copyto!(result.d, convert(Ptr{Base.GMP.Limb}, pointer(x)), xsize)
    return result
end
