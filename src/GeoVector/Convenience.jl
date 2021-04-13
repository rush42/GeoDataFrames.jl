
"""
    xcoords(geom) 
    
Return all x coordinates of 'geom' as flat array
"""
xcoords(geom::AbstractPoint) = [xcoord(coordinates(geom))]

"""
    ycoords(geom) 
    
Return all y coordinates of 'geom' as flat array
"""
ycoords(geom::AbstractPoint) = [ycoord(coordinates(geom))]

"""
    zcoords(geom) 
    
Return all z coordinates of 'geom' as flat array
"""
zcoords(geom::AbstractPoint) = [zcoord(coordinates(geom))]

xcoords(geom::Union{AbstractLineString, AbstractMultiPoint}) = xcoord.(coordinates(geom))
ycoors(geom::Union{AbstractLineString, AbstractMultiPoint}) = ycoord.(coordinates(geom))
zcoors(geom::Union{AbstractLineString, AbstractMultiPoint}) = zcoord.(coordinates(geom))

xcoords(geom::Union{AbstractPolygon,AbstractMultiLineString}) = xcoord.(vcat(coordinates(geom)...))
ycoords(geom::Union{AbstractPolygon,AbstractMultiLineString}) = ycoord.(vcat(coordinates(geom)...))
zcoords(geom::Union{AbstractPolygon,AbstractMultiLineString}) = zcoord.(vcat(coordinates(geom)...))

xcoords(geom::AbstractMultiPolygon) = xcoord.(vcat(vcat(coordinates(geom)...)...))
ycoords(geom::AbstractMultiPolygon) = ycoord.(vcat(vcat(coordinates(geom)...)...))
zcoords(geom::AbstractMultiPolygon) = zcoord.(vcat(vcat(coordinates(geom)...)...))

"""
    toGeos(geom)

return the LibGEOS implementation for the AbstractGeometry 'geom'
"""
toGEOS(geom::AbstractPoint) = LibGEOS.Point(coordinates(geom))

toGEOS(geom::AbstractMultiPoint) = LibGEOS.MultiPoint(coordinates(geom))

toGEOS(geom::AbstractLineString) = LibGEOS.LineString(coordinates(geom))

toGEOS(geom::AbstractMultiLineString) = LibGEOS.MultiLineString(coordinates(geom))

toGEOS(geom::AbstractPolygon) = LibGEOS.Polygon(coordinates(geom))

toGEOS(geom::AbstractMultiPolygon) = LibGEOS.MultiPolygon(coordinates(geom))

toGEOS(geom::AbstractGeometryCollection) = LibGEOS.GeometryCollection(coordinates(geom))

toGEOS(geom::Union{LibGEOS.Point, LibGEOS.MultiPoint, LibGEOS.LineString, LibGEOS.MultiLineString, LibGEOS.Polygon, LibGEOS.MultiPolygon, LibGEOS.GeometryCollection}) = geom