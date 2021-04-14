using Plots, GeoJSON

include("../src/GeoVector/GeoVector.jl")

berlin = GeoJSON.read(read("GeoDataFrames.jl/examples/berlin.geojson"))

districts = Vector{AbstractGeometry}()
for f in features(berlin)
    push!(districts,toGEOS(geometry(f)))
end

v = GeoVector(districts, false)


plot(v)
plot(envelope(v), palette=palette([:blue,:green, :yellow,:red, :white], length(v)))
plot!(boundary(v), linewidth=3, palette=palette([:blue,:green, :yellow,:red, :white], length(v), reverse=true))
plot(centroid(v))
plot(union(v))
plot(v, palette=palette([:blue,:green,:red], length(v)))
plot(v[area(v) .> 0.01], color = :red)
plot(union(v))