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
        missing_zeros = div(Sys.WORD_SIZE, 8) -  length(x)
        if missing_zeros > 0
            for i in 1:missing_zeros
                pushfirst!(x,0x00)
            end
        end
        if ENDIAN_BOM == 0x04030201
            reverse!(x)
        end
        return reinterpret(Int, x)[1]
    end
end

function bytes2big(x::Array{UInt8,1})
    hex = bytes2hex(x)
    return parse(BigInt, hex, base=16)
end

# Alternative implementation

# function bytes2int2(x::Array{UInt8,1})
#     if isempty(x)
#         return 0
#     end
#     if length(x) > div(Sys.WORD_SIZE, 8)
#         T = BigInt
#     else
#         T = Int
#     end
#     result = zero(T)
#     if ENDIAN_BOM == 0x01020304
#         reverse!(x)
#     end
#     for c in x
#         result <<= 8
#         result += c
#     end
#     return result
# end
#
# function faster_bytes2big(x::Array{UInt8,1})
#     xsize = cld(length(x), Base.GMP.BITS_PER_LIMB / 8)
#     if ENDIAN_BOM == 0x04030201
#         reverse!(x)
#     end
#     result = Base.GMP.MPZ.realloc2(xsize * Base.GMP.BITS_PER_LIMB)
#     result.size = xsize
#     unsafe_copyto!(result.d, convert(Ptr{Base.GMP.Limb}, pointer(x)), xsize)
#     return result
# end
