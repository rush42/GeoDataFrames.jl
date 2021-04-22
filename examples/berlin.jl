using Plots, GeoJSON, Random

include("../src/GeoVector/GeoVector.jl")

berlin = GeoJSON.read(read("GeoDataFrames.jl/examples/berlin.geojson"))

districts = Vector{AbstractGeometry}()
for f in features(berlin)
    push!(districts,toGEOS(geometry(f)))
end

v = GeoVector(districts, false)
v = v[randperm(length(v))]


plot(v, palette=palette(:darktest,length(v)))
plot(envelope(v), palette=palette(:darktest,length(v)))
plot(centroid(v))
plot(unaryunion(v), aspect_ratio = ratio(v))
plot(v, palette=palette([:blue,:green,:red], length(v)))
plot(v[area(v) .> 0.01], color = :red)
plot(convexhull(v), palette=palette(:darktest, length(v), rev=true))

anim = @animate for i ∈ 0:0.04:π
    r = (1 - sin(i)) * 0.2
    plot(buffer(v, r), palette=palette(:darktest,length(v)),framestyle=:none, save=true)
end

gif(anim, "/home/laurenz/Documents/berlin.gif", fps=15)