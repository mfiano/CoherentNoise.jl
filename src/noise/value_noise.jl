struct Value{N} <: NoiseSampler{N}
    random_state::RandomState
end

HashTrait(::Type{<:Value}) = IsValueHashed()

### 1D

"""
    value_1d(; seed=nothing)

Construct a sampler that outputs 1-dimensonal value noise when it is sampled from.

# Arguments

  - `seed`: An unsigned integer used to seed the random number generator for this sampler, or
    `nothing` for non-deterministic results.
"""
value_1d(; seed=nothing) = Value{1}(RandomState(seed))

function sample(sampler::S, x::Real) where {S<:Value{1}}
    seed = sampler.random_state.seed
    X = floor(Int, x)
    X1 = X * PRIME_X
    X2 = X1 + PRIME_X
    x1 = curve3(x - X)
    lerp(hash_coords(S, seed, X1), hash_coords(S, seed, X2), x1) - 1
end

### 2D

"""
    value_2d(; seed=nothing)

Construct a sampler that outputs 2-dimensonal value noise when it is sampled from.

# Arguments

  - `seed`: An unsigned integer used to seed the random number generator for this sampler, or
    `nothing` for non-deterministic results.
"""
value_2d(; seed=nothing) = Value{2}(RandomState(seed))

function sample(sampler::S, x::T, y::T) where {S<:Value{2},T<:Real}
    seed = sampler.random_state.seed
    primes = (PRIME_X, PRIME_Y)
    X, Y = floor.(Int, (x, y))
    X1, Y1 = (X, Y) .* primes
    X2, Y2 = (X1, Y1) .+ primes
    x1, y1 = curve3.((x, y) .- (X, Y))
    p1 = lerp(hash_coords(S, seed, X1, Y1), hash_coords(S, seed, X2, Y1), x1)
    p2 = lerp(hash_coords(S, seed, X1, Y2), hash_coords(S, seed, X2, Y2), x1)
    lerp(p1, p2, y1) - 1
end

### 3D

"""
    value_3d(; seed=nothing)

Construct a sampler that outputs 3-dimensonal value noise when it is sampled from.

# Arguments

  - `seed`: An unsigned integer used to seed the random number generator for this sampler, or
    `nothing` for non-deterministic results.
"""
value_3d(; seed=nothing) = Value{3}(RandomState(seed))

function sample(sampler::S, x::T, y::T, z::T) where {S<:Value{3},T<:Real}
    seed = sampler.random_state.seed
    primes = (PRIME_X, PRIME_Y, PRIME_Z)
    X, Y, Z = floor.(Int, (x, y, z))
    X1, Y1, Z1 = (X, Y, Z) .* primes
    X2, Y2, Z2 = (X1, Y1, Z1) .+ primes
    x1, y1, z1 = curve3.((x, y, z) .- (X, Y, Z))
    p1 = lerp(hash_coords(S, seed, X1, Y1, Z1), hash_coords(S, seed, X2, Y1, Z1), x1)
    p2 = lerp(hash_coords(S, seed, X1, Y2, Z1), hash_coords(S, seed, X2, Y2, Z1), x1)
    p3 = lerp(hash_coords(S, seed, X1, Y1, Z2), hash_coords(S, seed, X2, Y1, Z2), x1)
    p4 = lerp(hash_coords(S, seed, X1, Y2, Z2), hash_coords(S, seed, X2, Y2, Z2), x1)
    lerp(lerp(p1, p2, y1), lerp(p3, p4, y1), z1) - 1
end

### 4D

"""
    value_4d(; seed=nothing)

Construct a sampler that outputs 4-dimensonal value noise when it is sampled from.

# Arguments

  - `seed`: An unsigned integer used to seed the random number generator for this sampler, or
    `nothing` for non-deterministic results.
"""
value_4d(; seed=nothing) = Value{4}(RandomState(seed))

function sample(sampler::S, x::T, y::T, z::T, w::T) where {S<:Value{4},T<:Real}
    seed = sampler.random_state.seed
    primes = (PRIME_X, PRIME_Y, PRIME_Z, PRIME_W)
    X, Y, Z, W = floor.(Int, (x, y, z, w))
    X1, Y1, Z1, W1 = (X, Y, Z, W) .* primes
    X2, Y2, Z2, W2 = (X1, Y1, Z1, W1) .+ primes
    x1, y1, z1, w1 = curve3.((x, y, z, w) .- (X, Y, Z, W))
    p1 = lerp(hash_coords(S, seed, X1, Y1, Z1, W1), hash_coords(S, seed, X2, Y1, Z1, W1), x1)
    p2 = lerp(hash_coords(S, seed, X1, Y2, Z1, W1), hash_coords(S, seed, X2, Y2, Z1, W1), x1)
    p3 = lerp(hash_coords(S, seed, X1, Y1, Z2, W1), hash_coords(S, seed, X2, Y1, Z2, W1), x1)
    p4 = lerp(hash_coords(S, seed, X1, Y2, Z2, W1), hash_coords(S, seed, X2, Y2, Z2, W1), x1)
    p5 = lerp(hash_coords(S, seed, X1, Y1, Z1, W2), hash_coords(S, seed, X2, Y1, Z1, W2), x1)
    p6 = lerp(hash_coords(S, seed, X1, Y2, Z1, W2), hash_coords(S, seed, X2, Y2, Z1, W2), x1)
    p7 = lerp(hash_coords(S, seed, X1, Y1, Z2, W2), hash_coords(S, seed, X2, Y1, Z2, W2), x1)
    p8 = lerp(hash_coords(S, seed, X1, Y2, Z2, W2), hash_coords(S, seed, X2, Y2, Z2, W2), x1)
    p9 = lerp(lerp(p1, p2, y1), lerp(p3, p4, y1), z1)
    p10 = lerp(lerp(p5, p6, y1), lerp(p7, p8, y1), z1)
    lerp(p9, p10, w1) - 1
end
