# GeoDataFrames.jl
An extension to the DataFrames.jl library for handling geospatial data.
This Package aims to provide a geopandas equivalent for Julia.

# State

This package is at an early development stage.
The GeoVector.jl provides a minimal type(GeoVector) that can be used to handle series of AbstractGeometries.
The underliying framework is LibGEOS.jl.

# Working
GeoVector implements the AbstractArray interface (GeoVector <: AbstractVector).
Currently there is only the default constructor:
```Julia 
GeoVector(Vector{AbstractGeometry}, Bool)
```

The following methods are implemented and work like their geopandas equivalent.

```Julia
"""
Constructive Methods
"""
LibGEOS.centroid(gvec::GeoVector)

LibGEOS.simplify(gvec::GeoVector, tol::Real)

LibGEOS.envelope(gvec::GeoVector)

LibGEOS.boundary(gvec::GeoVector)

LibGEOS.buffer(gvec::GeoVector, dist::Real)

LibGEOS.convexhull(gvec::GeoVector)


"""
Unary Predicates
"""

hasz(gvec::GeoVector)

#isempty(gvec::GeoVector)

issimple(gvec::GeoVector)

isvalid(gvec::GeoVector)

isring(gvec::GeoVector)


"""
Binary Predicates
"""
LibGEOS.within(gvec::GeoVector, other::GeoVector)
LibGEOS.within(gvec::GeoVector, other::AbstractGeometry)

touches(gvec::GeoVector, other::GeoVector)
touches(gvec::GeoVector, other::AbstractGeometry)

LibGEOS.equals(gvec::GeoVector, other::GeoVector)
LibGEOS.equals(gvec::GeoVector, other::AbstractGeometry)

equalsexact(gvec::GeoVector, other::GeoVector)
equalsexact(gvec::GeoVector, other::AbstractGeometry)

disjoint(gvec::GeoVector, other::GeoVector)
disjoint(gvec::GeoVector, other::AbstractGeometry)

intersects(gvec::GeoVector, other::GeoVector)
intersects(gvec::GeoVector, other::AbstractGeometry)

contains(gvec::GeoVector, other::GeoVector)
contains(gvec::GeoVector, other::AbstractGeometry)

#contains(gvec::GeoVector, other::GeoVector)
#contains(gvec::GeoVector, other::AbstractGeometry)

covers(gvec::GeoVector, other::GeoVector)
covers(gvec::GeoVector, other::AbstractGeometry)

coveredby(gvec::GeoVector, other::GeoVector)
coveredby(gvec::GeoVector, other::AbstractGeometry)

"""
Set-theoretic Methods
"""

LibGEOS.intersection(gvec::GeoVector, other::AbstractGeometry)
LibGEOS.intersection(gvec::GeoVector, other::GeoVector)

LibGEOS.difference(gvec::GeoVector, other::AbstractGeometry)
LibGEOS.difference(gvec::GeoVector, other::GeoVector)

symmetricdifference(gvec::GeoVector, other::AbstractGeometry)
symmetricdifference(gvec::GeoVector, other::GeoVector)

union(gvec::GeoVector, other::AbstractGeometry)
union(gvec::GeoVector, other::GeoVector)

unaryunion(gvec::GeoVector)

"""
Misc
"""


area(gvec::GeoVector)

ratio(gvec::GeoVector)

totalbounds(gvec::GeoVector) 
```

Additionally a recipe is provided for plotting GeoVectors.
This takes care to set the right aspect ratio when plotting unprojected(spherical geometries).

# Examples
Check out examples/berlin.jl for a qucik overview of the existing functionality.
