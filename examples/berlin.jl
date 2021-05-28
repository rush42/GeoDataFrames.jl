using GeoDataFrames, Plots, GeoJSON, GeoInterface

cd(@__DIR__)

germany_covid = GeoJSON.read(read("./corona_germany.geojson"))
gdf = GeoDataFrame(germany_covid)
plot(gdf, column=:cases_per_100k, colors=cgrad(:thermal, rev=true))
