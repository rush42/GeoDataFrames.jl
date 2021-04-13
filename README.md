# GeoDataFrames.jl-
An extension to the DataFrames.jl library for handling geospatial data


# State

This package is at an early development stage, currently there are no function or type exports.
But the GeoVector.jl provides a minimal type(GeoVector) that can be used to handle series of AbstractGeometries.

The underliying framework is LibGEOS.jl.

This Package aims to provide a geopandas equivalent for Julia.

A recipe is provided for plotting GeoVectors.
This takes care to set the right aspect ratio when plotting unprojected(spherical geometries).

Check out examples/berlin.jl for a qucik overview of the existing functionality.
