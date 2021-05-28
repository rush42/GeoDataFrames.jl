# GeoDataFrames.jl
An extension to the DataFrames.jl library for handling geospatial data.
This Package aims to provide a geopandas equivalent for Julia.

# State

This package is at an early development stage, currently there are no function or type exports.
But the GeoVector.jl provides a minimal type(GeoVector) that can be used to handle series of AbstractGeometries.
The underliying framework is LibGEOS.jl.

# Working
GeoVector implements the AbstractArray interface (GeoVector <: AbstractVector).

The following methods are implemented and work like their geopandas equivalent.
```Julia
envelope( gvec::GeoVector )

boundary(gvec::GeoVector)

centroid(gvec::GeoVector) 

within(gvec::GeoVector, other::AbstractGeometry)

contains(gvec::GeoVector, other::AbstractGeometry)

hasz(gvec::GeoVector)

is_empty(gvec::GeoVector)

is_simple(gvec::GeoVector)

is_valid(gvec::GeoVector)

is_ring(gvec::GeoVector)

union(gvec::GeoVector)

area(gvec::GeoVector)

bounds(gvec::GeoVector)
```

Additionally a recipe is provided for plotting GeoVectors.
This takes care to set the right aspect ratio when plotting unprojected(spherical geometries).

# Examples
Check out examples/berlin.jl for a qucik overview of the existing functionality.
