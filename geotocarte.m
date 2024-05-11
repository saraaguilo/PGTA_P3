function distances =geotocarte (distances)

% Convertir latitud y longitud de cadenas de texto a números
distances.Latitude = deg2rad(distances.LAT);
distances.Longitude = deg2rad(distances.LON);
distances.Height = distances.H;
radius = 6368942.808; % in meters % 6370 mejor?
%ellipsoid parameters
a = 6378137;
flattening = 1/298.257223563;

b = a * (1 - flattening);
ecc = 1 - (b^2 / a^2);

N = a ./ sqrt(1 - ecc * sin(distances.Latitude).^2);

% Cartesian coordinates
distances.X = (N + distances.Height) .* cos(distances.Latitude) .* cos(distances.Longitude);
distances.Y = (N + distances.Height) .* cos(distances.Latitude) .* sin(distances.Longitude);
distances.Z = (N * (1 - ecc) + distances.Height) .* sin(distances.Latitude);

end

   
  