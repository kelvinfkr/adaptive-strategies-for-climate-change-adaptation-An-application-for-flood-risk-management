load('sliider_output.mat')
temp_lat = data_vars.seg_lat.data;
temp_lon = data_vars.seg_lon.data;

min_lat = 24.5; % Minimum latitude
max_lat = 45.0; % Maximum latitude
min_lon = -97.0; % Minimum longitude (extended to include Gulf Coast)
max_lon = -67.0; % Maximum longitude

% Find the points within the bounding box
in_bounding_box = (temp_lat >= min_lat) & (temp_lat <= max_lat) & ...
                  (temp_lon >= min_lon) & (temp_lon <= max_lon);

% Exclude points that are both east of 80°W and south of 30°N
exclude_region = (temp_lon > -80.0) & (temp_lat < 30.0);

% Combine the bounding box and exclusion conditions
in_east_coast = in_bounding_box & ~exclude_region;

% Extract the latitude and longitude points within the coastal region
east_coast_lat = temp_lat(in_east_coast);
east_coast_lon = temp_lon(in_east_coast);

% Create a new figure and load the USA map
figure;
worldmap('USA');
hold on
% Plot the selected points on the map
geoshow(east_coast_lat, east_coast_lon, 'DisplayType', 'Point', 'Color', 'red', 'Marker', '.', 'MarkerSize', 10);
grid on

% Customize the map appearance (optional)
faceColors = makesymbolspec('Polygon', {'INDEX', [1 numel(states)], 'FaceColor', polcmap(numel(states))});
geoshow(states, 'DisplayType', 'polygon', 'SymbolSpec', faceColors);