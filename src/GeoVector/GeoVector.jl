using LibGEOS
using GeoInterface
using RecipesBase
using LibSpatialIndex

include("Convenience.jl")

struct GeoVector <: AbstractVector{AbstractGeometry}
    geometry::Vector{AbstractGeometry}
    projected::Bool
end

Base.size(gvec::GeoVector)= size(gvec.geometry)

Base.getindex(gvec::GeoVector, i::Int) = gvec.geometry[i]

Base.getindex(gvec::GeoVector, I::Vararg{Int, N}) where {N} = gvec.geometry[I...]

Base.getindex(gvec::GeoVector, I::Vararg{N}) where {N} = GeoVector(gvec.geometry[I...], gvec.projected)

Base.setindex!(gvec::GeoVector, value::AbstractGeometry, i::Int) = (gvec.geometry[i] = value)

Base.IndexStyle(::Type{<:GeoVector}) = IndexLinear()

Base.similar(gvec::GeoVector, (N,)::Dims) = GeoVector(Vector{AbstractGeometry}(undef,N), gvec.projected)

"""
Methods returning GeoVectors
"""

envelope(gvec::GeoVector) = GeoVector(LibGEOS.envelope.(gvec.geometry), gvec.projected)

boundary(gvec::GeoVector) = GeoVector(LibGEOS.boundary.(gvec.geometry), gvec.projected)

centroid(gvec::GeoVector) = GeoVector(LibGEOS.centroid.(gvec.geometry), gvec.projected)

"""
Methods returning truth series
"""

LibGEOS.within(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.within.(gvec, Ref(toGEOS(other)))

contains(gvec::GeoVector, other::AbstractGeometry) = LibGEOS.within.(Ref(toGEOS(other)), gvec)

hasz(gvec::GeoVector) = hasz.(gvec.geometry)

is_empty(gvec::GeoVector)= LibGEOS.isEmpty.(gvec.geometry)

is_simple(gvec::GeoVector)= LibGEOS.isSimple.(gvec.geometry)

is_valid(gvec::GeoVector)= LibGEOS.isValid.(gvec.geometry)

is_ring(gvec::GeoVector)= LibGEOS.isRing.(gvec.geometry)

union(gvec::GeoVector) = reduce(LibGEOS.union, gvec.geometry)

area(gvec::GeoVector) = LibGEOS.area.(gvec.geometry)

function ratio(gvec::GeoVector)
    _,minY,_,maxY = bounds(gvec)
    df_y = (minY + maxY)/2
    return 1/cos(df_y * pi/180)
end

function sindex(gvec::GeoVector)
    sindex = LibSpatialIndex.RTree(2)
    for geom in gvec
        LibSpatialIndex.insert!(sindex, )
    end

end

function bounds(gvec::GeoVector) 
    Xs = reduce(vcat, xcoords.(gvec.geometry))
    Ys = reduce(vcat, ycoords.(gvec.geometry))
    return (minimum(Xs), minimum(Ys), maximum(Xs), maximum(Ys))
end


RecipesBase.@recipe function f(gvec::GeoVector)
    aspect_ratio --> (v.projected ? 1 : ratio(v))
    gvec.geometry
end
