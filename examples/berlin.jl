using Plots, GeoJSON

include("../src/GeoVector/GeoVector.jl")

berlin = GeoJSON.read(read("GeoDataFrames/examples/berlin.JSON"))

districts = Vector{AbstractGeometry}()
for f in features(berlin)
    push!(districts,toGEOS(geometry(f)))
end

v = GeoVector(districts, false)

plot(v)
plot(envelope(v))
plot(boundary(v))
plot(centroid(v))
plot(union(v))
plot(v[5:end])
plot(v[area(v) .> 0.01], color = :red)