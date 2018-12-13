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
PrivateKey(𝑒) represents an S256Point determined by 𝑃 = 𝑒G,
where 𝑒 is an integer and G the scep256k1 generator point.
"""
struct PrivateKey
    𝑒::Integer
    𝑃::AbstractPoint
    PrivateKey(𝑒) = new(𝑒, 𝑒 * G)
end

"Formats Private Key showing 𝑒, 𝑒 * G"
function show(io::IO, z::PrivateKey)
    print(io, "Secret : ", string(z.𝑒, base = 16))
end

"""
Returns a Signature for a given PrivateKey and data 𝑧
pksign(pk::PrivateKey, 𝑧::Integer) -> Signature
"""
function pksign(pk::PrivateKey, 𝑧::Integer)
    𝑘 = rand(0:N)
    𝑟 = (𝑘 * G).𝑥.𝑛
    𝑘⁻¹ = powermod(𝑘, N - 0x02, N)
    𝑠 = mod((𝑧 + 𝑟 * pk.𝑒) * 𝑘⁻¹, N)
    if 𝑠 > N ÷ 0x02
        𝑠 = N - 𝑠
    end
    return Signature(𝑟, 𝑠)
end
