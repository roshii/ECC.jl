# ECC.jl

Elliptic Curve Cryptography in Julia

[![pipeline status](https://gitlab.com/braneproject/ecc.jl/badges/master/pipeline.svg)](https://gitlab.com/braneproject/ecc.jl/commits/master)  [![coverage report](https://gitlab.com/braneproject/ecc.jl/badges/master/coverage.svg)](https://gitlab.com/braneproject/ecc.jl/commits/master)

## Types

S256Point(𝑥::T, 𝑦::T) where {T<:Union{S256FieldElement, Integer, Infinity}}
represents a point in an scep256k1 field.

PrivateKey(𝑒) represents an S256Point determined by 𝑃 = 𝑒G,
where 𝑒 is an integer and G the scep256k1 generator point.

Signature(𝑟, 𝑠) represents a Signature for 𝑧 in which 𝑠 = (𝑧 + 𝑟𝑒) / 𝑘,
𝑘 being a random integer.

## Functions

Serialize an S256Point() to compressed SEC format, uncompressed if false is set
as second argument.
point2sec(P::T, compressed::Bool=true) where {T<:S256Point} -> Array{UInt8,1}

Parse a SEC binary to an S256Point()
sec2point(sec_bin::AbstractArray{UInt8}) -> S256Point

Returns true if sig is a valid signature for 𝑧 given 𝑃, false if not
verify(𝑃::AbstractPoint, 𝑧::Integer, sig::Signature) -> Bool

Returns a Signature for a given PrivateKey and data 𝑧
pksign(pk::PrivateKey, 𝑧::Integer) -> Signature

Serialize a Signature to DER format
sig2der(x::Signature) -> Array{UInt8,1}

Parse a DER binary to a Signature
der2sig(signature_bin::AbstractArray{UInt8}) -> Signature

## Helpers

Convert Integer to bytes array
int2bytes(x::Integer) -> Array{UInt8,1}

Convert bytes array to Integer
bytes2int(x::Array{UInt8,1}) -> BigInt
