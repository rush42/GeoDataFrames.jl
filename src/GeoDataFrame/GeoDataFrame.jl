using PlotUtils, ColorSchemes

using DataFrames
using DataFrames: DataFrameRow, SubDataFrame
using DataFrames: delete!, first, index, last, ncol, nonunique, nrow,
    rename, rename!, select, select!, unique!

struct GeoDataFrame <: AbstractDataFrame
    df::DataFrame
    geo_col::Symbol
    function GeoDataFrame(df::DataFrame, geo_col::Union{Symbol,String}=:geometry)
        @assert df[!,geo_col] isa GeoVector "Geometry column is not of type 'GeoVector'"
        new(df, Symbol(geo_col))
    end
end

function GeoDataFrame(df::DataFrame, geometry::GeoVector; copycols::Bool=true)
    @assert !("geometry" ∈ names(df)) "'DataFrame' already has a geometry column!"
    if copycols
        df = Base.copy(df)
        geometry = Base.copy(geometry)
    end
    GeoDataFrame(insertcols!(df, (:geometry=>geometry), copycols=false), :geometry)
end

function GeoDataFrame(fcollection::FeatureCollection)
    feature_list = features(fcollection)
    props = copy(properties(first(feature_list)))
    for col_name in keys(props)
        props[col_name] = getindex.(properties.(feature_list),col_name)
    end
    GeoDataFrame(DataFrame(props...), GeoVector(geometry.(feature_list), false); copycols=false)
end

function rename_geometry!(gdf::GeoDataFrame, new::Union{Symbol,String}) 
    new = Symbol(new)
    rename!(_frame(gdf), (geo_column(gdf) => new))
    setfield!(gdf,:geo_col, new)
end

geo_column(gdf::GeoDataFrame) = getfield(gdf,:geo_col)

_frame(gdf::GeoDataFrame) = getfield(gdf,:df)

GeoDataFrames.geometry(gdf::GeoDataFrame) = gdf[!,geo_column(gdf)]


## getindex()

# Returns a scalar or column
Base.getindex(gdf::GeoDataFrame, row, col::Union{Real, Symbol, AbstractString}) = _frame(gdf)[row, col]

# Returns a 'GeoDataFrame'
Base.getindex(gdf::GeoDataFrame, I...) = GeoDataFrame(_frame(gdf)[I...], geo_column(gdf))

Base.getproperty(gdf::GeoDataFrame, column::Symbol) = gdf[!,column]


## setindex()

function Base.setproperty!(gdf::GeoDataFrame, col_ind::Symbol, v::AbstractVector)
     if col_ind == geo_column(gdf)
        throw(ArgumentError("It is only allowed to pass a 'GeoVector' as geometry column of a GeoDataFrame. " ))
    end
    _frame(gdf)[!, col_ind] = v
end

Base.setproperty!(gdf::GeoDataFrame, col_ind::Symbol, v::GeoVector) = (_frame(gdf)[!, col_ind] = v)


## copy + similar

Base.similar(gdf::GeoDataFrame) = GeoDataFrame(similar(_frame(gdf)), geo_column(gdf)) 

Base.copy(gdf::GeoDataFrame) = gdf[:,:]


##### EQUALITY #####

Base.isequal(gdf::GeoDataFrame, other::GeoDataFrame) = isequal(_frame(gdf), _frame(other)) && isequal(geo_column(gdf), geo_column(other))
Base.isequal(::GeoDataFrame, ::AbstractDataFrame) = false
Base.isequal(::AbstractDataFrame, ::GeoDataFrame) = false

Base.hash(gdf::GeoDataFrame, h::UInt) = hash(geo_column(gdf), hash(_frame(gdf), h))


##### SIZE #####

DataFrames.nrow(gdf::GeoDataFrame) = nrow(_frame(gdf))

DataFrames.ncol(gdf::GeoDataFrame) = ncol(_frame(gdf))


##### ACCESSORS #####

DataFrames.index(gdf::GeoDataFrame) =  DataFrames.index(_frame(gdf))

DataFrames.propertynames(gdf::GeoDataFrame) = DataFrames.propertynames(_frame(gdf))

Base.names(gdf::GeoDataFrame) = names(_frame(gdf))

DataFrames.DataFrame(gdf::GeoDataFrame) = _frame(gdf)

DataFrames.parent(gdf::GeoDataFrame) = parent(_frame(gdf))

##### PUSH/APPEND/DELETE #####

function Base.push!(gdf::GeoDataFrame, data)
    push!(frame(gdf), data)
    return gdf
end

function Base.append!(gdf::GeoDataFrame, data)
    append!(frame(gdf), data)
    return gdf
end

function DataFrames.delete!(gdf::GeoDataFrame, inds)
    delete!(frame(gdf), inds)
    return gdf
end


@recipe function f(gdf::GeoDataFrame; column::Union{Symbol, String}, colors=:thermal)
    values = gdf[:,column]
    offset = -minimum(values)
    total = maximum(values) + offset
    normalized = (values .+ offset) / total

    color_palette := getindex.(Ref(cgrad(colors)), normalized)
    framestyle --> :box
    #colorbar --> :right
    #clims --> [offset,total - offset]
    geometry(gdf)
end


@recipe function f(gdf::GeoDataFrame)
    geometry(gdf)
end

