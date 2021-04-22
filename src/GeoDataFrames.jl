module GeoDataFrames

using GeoInterface, LibGEOS, RecipesBase

include("GeoVector/GeoVector.jl")

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
area,
toGEOS

end # module
