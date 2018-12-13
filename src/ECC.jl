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

__precompile__()

module ECC

using BitIntegers

import Base: +, -, *, ^, /, ==, inv, sqrt, show, div
export S256Point, Signature, PrivateKey,
       point2sec, sec2point, verify, pksign, sig2der, der2sig,
       ∞, int2bytes, bytes2int

include("helper.jl")
include("primefield.jl")
include("infinity.jl")
include("point.jl")
include("signature.jl")
include("privatekey.jl")
include("scep256k1.jl")

end # module
