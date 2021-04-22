using LibGEOS
using GeoInterface
using RecipesBase

include("Convenience.jl")

struct GeoVector <: AbstractVector{AbstractGeometry}
    geometries::Vector{AbstractGeometry}
    projected::Bool
end


"""
Array Methods
"""

Base.size(gvec::GeoVector)= size(gvec.geometries)

Base.getindex(gvec::GeoVector, i::Int) = gvec.geometries[i]

Base.getindex(gvec::GeoVector, I::Vararg{Int, N}) where {N} = gvec.geometries[I...]

Base.setindex!(gvec::GeoVector, value::AbstractGeometry, i::Int) = (gvec.geometries[i] = value)

Base.IndexStyle(::Type{<:GeoVector}) = IndexLinear()

Base.getindex(gvec::GeoVector, I::Vararg{N}) where {N} = GeoVector(gvec.geometries[I...], gvec.projected)

Base.similar(gvec::GeoVector, (N,)::Dims) = GeoVector(Vector{AbstractGeometry}(undef,N), gvec.projected)


"""
Constructive Methods
"""
centroid(gvec::GeoVector) = GeoVector(LibGEOS.centroid.(gvec.geometries), gvec.projected)

simplify(gvec::GeoVector, tol::Real) = GeoVector(LibGEOS.simplify.(gvec.geometries, Ref(tol)), gvec.projected)

envelope(gvec::GeoVector) = GeoVector(LibGEOS.envelope.(gvec.geometries), gvec.projected)

boundary(gvec::GeoVector) = GeoVector(LibGEOS.boundary.(gvec.geometries), gvec.projected)

buffer(gvec::GeoVector, dist::Real) = GeoVector(LibGEOS.bufferWithStyle.(gvec.geometries, Ref(dist)), gvec.projected)

LibGEOS.convexhull(gvec::GeoVector) = GeoVector(LibGEOS.convexhull.(gvec.geometries), gvec.projected)


"""
Unary Predicates
"""

hasz(gvec::GeoVector) = hasz.(gvec.geometries)

#isempty(gvec::GeoVector)= LibGEOS.isEmpty.(gvec.geometries)

issimple(gvec::GeoVector)= LibGEOS.isSimple.(gvec.geometries)

isvalid(gvec::GeoVector)= LibGEOS.isValid.(gvec.geometries)

isring(gvec::GeoVector)= LibGEOS.isRing.(gvec.geometries)


"""
Binary Predicates
"""
LibGEOS.within(gvec::GeoVector, other::GeoVector) = LibGEOS.within.(gvec, other)
LibGEOS.within(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.within.(gvec, Ref(toGEOS(other)))

contains(gvec::GeoVector, other::GeoVector) = LibGEOS.within.(other, gvec)
contains(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.within.(Ref(toGEOS(other)), gvec)

touches(gvec::GeoVector, other::GeoVector) = LibGEOS.touches.(gvec, other)
touches(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.touches.(gvec, Ref(toGEOS(other)))

LibGEOS.equals(gvec::GeoVector, other::GeoVector) = LibGEOS.equals.(gvec,other)
LibGEOS.equals(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.equals.(gvec, Ref(toGEOS(other)))

equalsexact(gvec::GeoVector, other::GeoVector) = LibGEOS.equalsexact.(gvec,other)
equalsexact(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.equalsexact.(gvec, Ref(toGEOS(other)))

disjoint(gvec::GeoVector, other::GeoVector) = LibGEOS.disjoint.(gvec,other)
disjoint(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.disjoint.(gvec, Ref(toGEOS(other)))

intersects(gvec::GeoVector, other::GeoVector) = LibGEOS.intersects.(gvec,other)
intersects(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.intersects.(gvec, Ref(toGEOS(other)))

contains(gvec::GeoVector, other::GeoVector) = LibGEOS.containsproperly.(gvec, other)
contains(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.containsproperly.(gvec, Ref(toGEOS(other)))

covers(gvec::GeoVector, other::GeoVector) = LibGEOS.covers.(gvec, other)
covers(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.covers.(gvec, Ref(toGEOS(other)))

coveredby(gvec::GeoVector, other::GeoVector) = LibGEOS.coveredby.(gvec, other)
coveredby(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.coveredby.(gvec, Ref(toGEOS(other)))

"""
Set-theoretic Methods
"""

LibGEOS.intersection(gvec::GeoVector, other::AbstractGeometry) = GeoVector(LibGEOS.intersection.(gvec, Ref(toGEOS(other))), gvec.projected)
LibGEOS.intersection(gvec::GeoVector, other::GeoVector) = GeoVector(LibGEOS.intersection.(gvec, other), gvec.projected)

LibGEOS.difference(gvec::GeoVector, other::AbstractGeometry) = GeoVector(LibGEOS.difference.(gvec, Ref(toGEOS(other))), gvec.projected)
LibGEOS.difference(gvec::GeoVector, other::GeoVector) = GeoVector(LibGEOS.difference.(gvec, other), gvec.projected)

symmetricdifference(gvec::GeoVector, other::AbstractGeometry) = GeoVector(LibGEOS.symmetricDifference.(gvec, Ref(toGEOS(other))), gvec.projected)
symmetricdifference(gvec::GeoVector, other::GeoVector) = GeoVector(LibGEOS.symmetricDifference.(gvec, other), gvec.projected)

union(gvec::GeoVector, other::AbstractGeometry) = GeoVector(LibGEOS.union.(gvec, Ref(toGEOS(other))), gvec.projected)
union(gvec::GeoVector, other::GeoVector) = GeoVector(LibGEOS.union.(gvec, other), gvec.projected)

unaryunion(gvec::GeoVector) = reduce(LibGEOS.union, gvec.geometries) 

area(gvec::GeoVector) = LibGEOS.area.(gvec.geometries)


function ratio(gvec::GeoVector)
    _,minY,_,maxY = totalbounds(gvec)
    df_y = (minY + maxY)/2
    return v.projected ? 1 : 1/cos(df_y * pi/180)
end


function totalbounds(gvec::GeoVector) 
    Xs = reduce(vcat, xcoords.(gvec.geometries))
    Ys = reduce(vcat, ycoords.(gvec.geometries))
    return (minimum(Xs), minimum(Ys), maximum(Xs), maximum(Ys))
end


RecipesBase.@recipe function f(gvec::GeoVector)
    aspect_ratio --> ratio(v)
    gvec.geometries
end

savefig("./berlin.gif")