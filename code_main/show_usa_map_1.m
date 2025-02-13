% Define the bounding box for the continental United States
min_lat = 24.5;   % Minimum latitude
max_lat = 49.0;   % Maximum latitude
min_lon = -125.0; % Minimum longitude
max_lon = -66.0;  % Maximum longitude

% Find the points within the bounding box
in_bounding_box = (temp_lat >= min_lat) & (temp_lat <= max_lat) & ...
                  (temp_lon >= min_lon) & (temp_lon <= max_lon);

% Define a maximum distance from the coast (in degrees)
max_distance = 1.0;

% Calculate the distance from each point to the coast
coast_lat = [min_lat, max_lat, max_lat, min_lat];
coast_lon = [min_lon, min_lon, max_lon, max_lon];
distances = zeros(size(temp_lat(in_bounding_box)));
for i = 1:length(coast_lat)
    distances = min(distances, sqrt((temp_lat(in_bounding_box) - coast_lat(i)).^2 + ...
                                     (temp_lon(in_bounding_box) - coast_lon(i)).^2));
end

% Find the points within the maximum distance from the coast
in_coast_proximity = distances <= max_distance;

% Combine the bounding box and coast proximity conditions
in_east_coast = in_bounding_box;
in_east_coast(in_bounding_box) = in_coast_proximity;

% Extract the latitude and longitude points within the coastal region
east_coast_lat = temp_lat(in_east_coast);
east_coast_lon = temp_lon(in_east_coast);

% Create a new figure and load the USA map
figure;
worldmap('USA');

% Plot the selected points on the map
geoshow(east_coast_lat, east_coast_lon, 'DisplayType', 'Point', 'Color', 'red', 'Marker', '.', 'MarkerSize', 10);