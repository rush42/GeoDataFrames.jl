# GeoDataFrames.jl
An extension to the DataFrames.jl library for handling geospatial data.
This Package aims to provide a geopandas equivalent for Julia.

# State

This package is at an early development stage.
GeoVector.jl provides a minimal type(GeoVector) that can be used to handle series of AbstractGeometries.
GeoDataFrame is a DataFrame containing at least on GeoVector and currently provides plotting based on an other column(numeric).
The underliying framework is LibGEOS.jl.

# Working

GeoDataFrame (partialy) implements the AbstractDataFrame interface (GeoDataFrame <: AbstractDataFrame).
Currently there is only plotting based on numerical columns and w/o a legend.

```Julia
germany_covid = GeoJSON.read(read("./corona_germany.geojson"))
gdf = GeoDataFrame(germany_covid)

plot(gdf, column=:cases_per_100k, colors=cgrad(:thermal, rev=true))
```
![plot](./examples/corona_cases_per_100k.png)

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
centroid(gvec::GeoVector)

simplify(gvec::GeoVector, tol::Real)

envelope(gvec::GeoVector)

boundary(gvec::GeoVector)

buffer(gvec::GeoVector, dist::Real)

convexhull(gvec::GeoVector)


"""
Unary Predicates
"""

hasz(gvec::GeoVector)

issimple(gvec::GeoVector)

isvalid(gvec::GeoVector)

isring(gvec::GeoVector)


"""
Binary Predicates
"""
within(gvec::GeoVector, other::GeoVector)
within(gvec::GeoVector, other::AbstractGeometry)

touches(gvec::GeoVector, other::GeoVector)
touches(gvec::GeoVector, other::AbstractGeometry)

equals(gvec::GeoVector, other::GeoVector)
equals(gvec::GeoVector, other::AbstractGeometry)

equalsexact(gvec::GeoVector, other::GeoVector)
equalsexact(gvec::GeoVector, other::AbstractGeometry)

disjoint(gvec::GeoVector, other::GeoVector)
disjoint(gvec::GeoVector, other::AbstractGeometry)

intersects(gvec::GeoVector, other::GeoVector)
intersects(gvec::GeoVector, other::AbstractGeometry)

contains(gvec::GeoVector, other::GeoVector)
contains(gvec::GeoVector, other::AbstractGeometry)

covers(gvec::GeoVector, other::GeoVector)
covers(gvec::GeoVector, other::AbstractGeometry)

coveredby(gvec::GeoVector, other::GeoVector)
coveredby(gvec::GeoVector, other::AbstractGeometry)

"""
Set-theoretic Methods
"""

intersection(gvec::GeoVector, other::AbstractGeometry)
intersection(gvec::GeoVector, other::GeoVector)

difference(gvec::GeoVector, other::AbstractGeometry)
difference(gvec::GeoVector, other::GeoVector)

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

A recipe is provided for plotting GeoVectors, which sets the right aspect ratio when plotting unprojected(spherical geometries).

# Examples
Check out examples/berlin.jl for a qucik overview of the existing functionality.
