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

@testset "ECC Tests" begin

    @testset "DER Signature Parsing and Serialization" begin
        @testset "der2sig" begin
            der = hex2bytes("304402201f62993ee03fca342fcb45929993fa6ee885e00ddad8de154f268d98f083991402201e1ca12ad140c04e0e022c38f7ce31da426b8009d02832f0b44f39a6b178b7a1")
            sig = Signature(parse(UInt256, "1f62993ee03fca342fcb45929993fa6ee885e00ddad8de154f268d98f0839914", base=16),
                            parse(UInt256, "1e1ca12ad140c04e0e022c38f7ce31da426b8009d02832f0b44f39a6b178b7a1", base=16))
            @test der2sig(der) == sig
        end
        @testset "sig2der" begin
            testcases = (
                (1, 2),
                (rand(UInt256), rand(UInt256)),
                (rand(UInt256), rand(UInt256)))
            for x in testcases
                sig = Signature(x[1], x[2])
                der = sig2der(sig)
                sig2 = der2sig(der)
                @test sig2 == sig
            end
        end
    end

    @testset "Signature Verification" begin
        pk = PrivateKey(rand(UInt))
        𝑧 = rand(UInt)
        𝑠 = pksign(pk, 𝑧)
        @test verify(pk.𝑃, 𝑧, 𝑠)
    end

    @testset "scep256k1" begin

        @testset "Addition" begin
            @testset "Base Case" begin
                a = S256Point(∞, ∞)
                b = S256Point(
                parse(UInt256,"112216064876340398180146521122766000050584611839777348350558800107938270743455",base=10),
                parse(UInt256,"74188084687534272867990361229595814394304651805662302908517496343232309904867", base=10))
                c = S256Point(
                parse(UInt256,"112216064876340398180146521122766000050584611839777348350558800107938270743455",base=10),
                parse(UInt256,"51208541148042477289517287834798636290313764048871106768165044359564585025374", base=10))
                @test a + b == b
                @test b + a == b
                @test b + c == a
            end
            @testset "Case 1" begin
                a = S256Point(
                parse(UInt256,"f8180abc73ddeebd8a4d26ba4905f74bdd5d9d183d50d79d92d6af0441510b9f",base=16),
                parse(UInt256,"a404f7c84ea5988aa75c73e0237de0732b0980467c01cc32506a8e0a0af445e3", base=16))
                b = S256Point(
                parse(UInt256,"4e1b9ff433214a9d4375fb9fd5f2658087b409b036fd6bdd7242849030fe49f7",base=16),
                parse(UInt256,"713701d5f0c3fe89458b1d265bb20322ddd9300738f0d5e50e16cb22beef3f5e", base=16))
                @test a + b == S256Point(
                parse(UInt256,"2edc8146f85bebc53a0e99e0185d455954eccb118ecf1dcada6b3ca5a8be44dd",base=16),
                parse(UInt256,"38491cfd1d8e3ecb0ea8ca9b4c13d8d34500713609e932ae8b3b0cc50db46fd6",base=16))
            end

            @testset "Case 2" begin
                @test ECC.G + ECC.G == S256Point(
                parse(UInt256,"c6047f9441ed7d6d3045406e95c07cd85c778e4b8cef3ca7abac09b95c709ee5",base=16),
                parse(UInt256,"1ae168fea63dc339a3c58419466ceaeef7f632653266d0e1236431a950cfe52a",base=16))
            end
        end

        @testset "Order" begin
            point = ECC.N * ECC.G
            @test typeof(point) == S256Point{ECC.Infinity}
        end

        @testset "Public Point" begin
            points = (
                # secret, x, y
                (7, parse(UInt256, "5cbdf0646e5db4eaa398f365f2ea7a0e3d419b7e0330e39ce92bddedcac4f9bc", base=16),
                    parse(UInt256, "6aebca40ba255960a3178d6d861a54dba813d0b813fde7b5a5082628087264da", base=16)),
                (1485, parse(UInt256, "c982196a7466fbbbb0e27a940b6af926c1a74d5ad07128c82824a11b5398afda", base=16),
                       parse(UInt256, "7a91f9eae64438afb9ce6448a1c133db2d8fb9254e4546b6f001637d50901f55", base=16)),
                (UInt256(2)^128, parse(UInt256, "8f68b9d2f63b5f339239c1ad981f162ee88c5678723ea3351b7b444c9ec4c0da", base=16),
                                 parse(UInt256, "662a9f2dba063986de1d90c2b6be215dbbea2cfe95510bfdf23cbf79501fff82", base=16)),
                (UInt256(2)^240 + 2^31, parse(UInt256, "9577ff57c8234558f293df502ca4f09cbc65a6572c842b39b366f21717945116", base=16),
                                        parse(UInt256, "10b49c67fa9365ad7b90dab070be339a1daf9052373ec30ffae4f72d5e66d053", base=16)),
            )

            for n ∈ points
                point = S256Point(n[2], n[3])
                @test n[1] * ECC.G == point
            end
        end

        @testset "point2sec" begin
            coefficient = 999^3
            uncompressed = "049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9"
            compressed = "039d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d5"
            point = coefficient * ECC.G
            @test point2sec(point,false) == hex2bytes(uncompressed)
            @test point2sec(point,true) == hex2bytes(compressed)
            coefficient = 123
            uncompressed = "04a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5204b5d6f84822c307e4b4a7140737aec23fc63b65b35f86a10026dbd2d864e6b"
            compressed = "03a598a8030da6d86c6bc7f2f5144ea549d28211ea58faa70ebf4c1e665c1fe9b5"
            point = coefficient * ECC.G
            @test point2sec(point,false) == hex2bytes(uncompressed)
            @test point2sec(point,true) == hex2bytes(compressed)
            coefficient = 42424242
            uncompressed = "04aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e21ec53f40efac47ac1c5211b2123527e0e9b57ede790c4da1e72c91fb7da54a3"
            compressed = "03aee2e7d843f7430097859e2bc603abcc3274ff8169c1a469fee0f20614066f8e"
            point = coefficient * ECC.G
            @test point2sec(point,false) == hex2bytes(uncompressed)
            @test point2sec(point,true) == hex2bytes(compressed)
        end

        @testset "sec2point" begin
            sec_bin = hex2bytes("0349fc4e631e3624a545de3f89f5d8684c7b8138bd94bdd531d2e213bf016b278a")
            point = sec2point(sec_bin)
            want = parse(UInt256, "a56c896489c71dfc65701ce25050f542f336893fb8cd15f4e8e5c124dbf58e47", base=16)
            @test point.𝑦.𝑛 == want
            sec_bin = hex2bytes("049d5ca49670cbe4c3bfa84c96a8c87df086c6ea6a24ba6b809c9de234496808d56fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9")
            point = sec2point(sec_bin)
            want = parse(UInt256, "6fa15cc7f3d38cda98dee2419f415b7513dde1301f8643cd9245aea7f3f911f9", base=16)
            @test point.𝑦.𝑛 == want
        end

        @testset "Signature Verification" begin
            point = S256Point(
                parse(UInt256, "887387e452b8eacc4acfde10d9aaf7f6d9a0f975aabb10d006e4da568744d06c", base=16),
                parse(UInt256, "61de6d95231cd89026e286df3b6ae4a894a3378e393e93a0f45b666329a0ae34", base=16))
            z = parse(UInt256, "ec208baa0fc1c19f708a9ca96fdeff3ac3f230bb4a7ba4aede4942ad003c0f60", base=16)
            r = parse(UInt256, "ac8d1c87e51d0d441be8b3dd5b05c8795b48875dffe00b7ffcfac23010d3a395", base=16)
            s = parse(UInt256, "68342ceff8935ededd102dd876ffd6ba72d6a427a3edb13d26eb0781cb423c4", base=16)
            @test verify(point, z, Signature(r, s))
            z = parse(UInt256, "7c076ff316692a3d7eb3c3bb0f8b1488cf72e1afcd929e29307032997a838a3d", base=16)
            r = parse(UInt256, "eff69ef2b1bd93a66ed5219add4fb51e11a840f404876325a1e8ffe0529a2c", base=16)
            s = parse(UInt256, "c7207fee197d27c618aea621406f6bf5ef6fca38681d82b2f06fddbdce6feab6", base=16)
            @test verify(point, z, Signature(r, s))
        end
    end

end
