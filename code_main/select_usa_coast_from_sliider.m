min_lat = 24.5;   % Minimum latitude
max_lat = 45.0;   % Maximum latitude
min_lon = -82.0;  % Minimum longitude
max_lon = -67.0;  % Maximum longitude

% Find the points within the bounding box
in_east_coast = (temp_lat >= min_lat) & (temp_lat <= max_lat) & ...
                (temp_lon >= min_lon) & (temp_lon <= max_lon);

% Extract the latitude and longitude points within the bounding box
east_coast_lat = temp_lat(in_east_coast);
east_coast_lon = temp_lon(in_east_coast);