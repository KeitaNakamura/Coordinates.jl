# Coordinates

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://KeitaNakamura.github.io/Coordinates.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://KeitaNakamura.github.io/Coordinates.jl/dev)
[![Build Status](https://github.com/KeitaNakamura/Coordinates.jl/workflows/CI/badge.svg)](https://github.com/KeitaNakamura/Coordinates.jl/actions)
[![codecov](https://codecov.io/gh/KeitaNakamura/Coordinates.jl/branch/main/graph/badge.svg?token=XHB3XP61IP)](https://codecov.io/gh/KeitaNakamura/Coordinates.jl)

## Installation

```julia
pkg> add https://github.com/KeitaNakamura/Coordinates.jl.git
```

## Usage

```julia
Coordinate(axes::AbstractVector...)
Coordinate{N}(axis::AbstractVector)
```

Construct `Coordinate` from `axes`.
If only single `axis` is given with specified number of dimensions `N`,
the `axis` is used for all dimensions.

### Examples

```julia
julia> Coordinate(1:3, 2:4)
3×3 Coordinate{2,Int64,UnitRange{Int64}}:
 (1, 2)  (1, 3)  (1, 4)
 (2, 2)  (2, 3)  (2, 4)
 (3, 2)  (3, 3)  (3, 4)

julia> Coordinate{2}(0.0:3.0)
4×4 Coordinate{2,Float64,StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}}:
 (0.0, 0.0)  (0.0, 1.0)  (0.0, 2.0)  (0.0, 3.0)
 (1.0, 0.0)  (1.0, 1.0)  (1.0, 2.0)  (1.0, 3.0)
 (2.0, 0.0)  (2.0, 1.0)  (2.0, 2.0)  (2.0, 3.0)
 (3.0, 0.0)  (3.0, 1.0)  (3.0, 2.0)  (3.0, 3.0)
```
