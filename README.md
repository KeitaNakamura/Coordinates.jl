# Coordinates

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://KeitaNakamura.github.io/Coordinates.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://KeitaNakamura.github.io/Coordinates.jl/dev)
[![Build Status](https://github.com/KeitaNakamura/Coordinates.jl/workflows/CI/badge.svg)](https://github.com/KeitaNakamura/Coordinates.jl/actions)
[![codecov](https://codecov.io/gh/KeitaNakamura/Coordinates.jl/branch/main/graph/badge.svg?token=XHB3XP61IP)](https://codecov.io/gh/KeitaNakamura/Coordinates.jl)

## Installation

```julia
pkg> add Coordinates
```

## Usage

```julia
Coordinate(axes...)
Coordinate{N}(axis)
```

Construct `Coordinate` from `axes`.
If only single `axis` is given with number of dimensions `N`,
the `axis` is used for all dimensions.

### Examples

```julia
julia> Coordinate(1:3, 2:4)
3×3 Coordinate{2,Tuple{Int64,Int64},Tuple{UnitRange{Int64},UnitRange{Int64}}}:
 (1, 2)  (1, 3)  (1, 4)
 (2, 2)  (2, 3)  (2, 4)
 (3, 2)  (3, 3)  (3, 4)

julia> Coordinate(1:2, [3.0,4.0], "abc")
2×2×3 Coordinate{3,Tuple{Int64,Float64,Char},Tuple{UnitRange{Int64},Array{Float64,1},String}}:
[:, :, 1] =
 (1, 3.0, 'a')  (1, 4.0, 'a')
 (2, 3.0, 'a')  (2, 4.0, 'a')

[:, :, 2] =
 (1, 3.0, 'b')  (1, 4.0, 'b')
 (2, 3.0, 'b')  (2, 4.0, 'b')

[:, :, 3] =
 (1, 3.0, 'c')  (1, 4.0, 'c')
 (2, 3.0, 'c')  (2, 4.0, 'c')

julia> Coordinate{2}(0:3)
4×4 Coordinate{2,Tuple{Int64,Int64},Tuple{UnitRange{Int64},UnitRange{Int64}}}:
 (0, 0)  (0, 1)  (0, 2)  (0, 3)
 (1, 0)  (1, 1)  (1, 2)  (1, 3)
 (2, 0)  (2, 1)  (2, 2)  (2, 3)
 (3, 0)  (3, 1)  (3, 2)  (3, 3)
```
