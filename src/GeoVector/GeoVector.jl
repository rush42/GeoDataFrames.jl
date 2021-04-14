using LibGEOS
using GeoInterface
using RecipesBase

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

union(gvec::GeoVector) = foldr(LibGEOS.union, gvec.geometry)

area(gvec::GeoVector) = LibGEOS.area.(gvec.geometry)

function bounds(gvec::GeoVector) 
    Xs = vcat(xcoords.(gvec.geometry)...)
    Ys = vcat(ycoords.(gvec.geometry)...)
    return (min(Xs...), min(Ys...), max(Xs...), max(Ys...))
end


RecipesBase.@recipe function f(gvec::GeoVector)
    ratio = 1
    if !gvec.projected
        _,minY,_,maxY = bounds(gvec)
        df_y = (minY + maxY)/2
        ratio = 1/cos(df_y * pi/180)
    end

    aspect_ratio --> ratio
    gvec.geometry
end
