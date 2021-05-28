module GeoDataFrames

using GeoInterface, LibGEOS, RecipesBase

include("GeoVector/GeoVector.jl")
include("GeoDataFrame/GeoDataFrame.jl")

export GeoVector,
size,
getindex,
setindex!,
IndexStyle,
similar,
centroid,
simplify,
envelope,
boundary,
buffer,
convexhull,
hasz,
issimple,
isvalid,
isring,
within,
contains,
touches,
equals,
equalsexact,
disjoint,
intersects,
contains,
covers,
coveredby,
intersection,
difference,
symmetricdifference,
union,
unaryunion,
ratio,
area,
toGEOS,
GeoDataFrame,
rename_geometry!,
geo_column,
geometry,
getproperty,
names,
copy,
index,
setproperty!

end # module
