using GeoDataFrames, Plots, GeoJSON, GeoInterface

cd(@__DIR__)
berlin = GeoJSON.read(read("./berlin.geojson"))
gdf = GeoDataFrame(berlin)

plot(gdf, column=:cartodb_id)

germany_covid = GeoJSON.read(read("./corona_germany.geojson"))
gdf = GeoDataFrame(germany_covid)
plot(gdf, column=:cases_per_100k, colorbar=true)
plot(gdf, column=:cases_per_100k, colors=cgrad(:thermal, rev=true))
similar(gdf)
copy(gdf)
size(gdf)