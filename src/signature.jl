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
Signature(𝑟, 𝑠) represents a Signature for 𝑧 in which
```𝑠 = (𝑧 + 𝑟𝑒) / 𝑘```
𝑘 being a random integer.
"""
struct Signature
    𝑟::UInt256
    𝑠::UInt256
    Signature(𝑟, 𝑠) = new(𝑟, 𝑠)
end

"Formats Signature as (r, s) in hexadecimal format"
function show(io::IO, z::Signature)
    print(io, "scep256k1 signature(𝑟, 𝑠):\n", string(z.𝑟, base = 16), ",\n", string(z.𝑠, base = 16))
end

==(x::Signature, y::Signature) = x.𝑟 == y.𝑟 && x.𝑠 == y.𝑠

"""
Serialize a Signature to DER format

sig2der(x::Signature) -> Array{UInt8,1}
"""
function sig2der(x::Signature)
    rbin = reinterpret(UInt8, [hton(x.𝑟)])
    i = findfirst(x -> x != 0x00, rbin)
    rbin = rbin[i:end]
    result = cat([0x02], UInt8[length(rbin)], rbin; dims=1)
    sbin = reinterpret(UInt8, [hton(x.𝑠)])
    i = findfirst(x -> x != 0x00, sbin)
    sbin = sbin[i:end]
    result = cat(result, [0x02], int2bytes(length(rbin)), sbin; dims=1)
    return cat([0x30], int2bytes(length(result)), result; dims=1)
end

"""
Parse a DER binary to a Signature

der2sig(signature_bin::AbstractArray{UInt8}) -> Signature
"""
function der2sig(signature_bin::AbstractArray{UInt8})
    s = IOBuffer(signature_bin)
    bytes = UInt8[]
    readbytes!(s, bytes, 1)
    if bytes[1] != 0x30
        throw(DomainError("Bad Signature"))
    end
    readbytes!(s, bytes, 1)
    if bytes[1] + 2 != length(signature_bin)
        throw(DomainError("Bad Signature Length"))
    end
    readbytes!(s, bytes, 1)
    if bytes[1] != 0x02
        throw(DomainError("Bad Signature"))
    end
    readbytes!(s, bytes, 1)
    rlength = Int(bytes[1])
    readbytes!(s, bytes, rlength)
    r = bytes2hex(bytes)
    readbytes!(s, bytes, 1)
    if bytes[1] != 0x02
        throw(DomainError("Bad Signature"))
    end
    readbytes!(s, bytes, 1)
    slength = Int(bytes[1])
    readbytes!(s, bytes, slength)
    s = bytes2hex(bytes)
    if length(signature_bin) != 6 + rlength + slength
        throw(DomainError("Signature too long"))
    end
    return Signature(parse(UInt256, r, base=16),
                     parse(UInt256, s, base=16))
end
