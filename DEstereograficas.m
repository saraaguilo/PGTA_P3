function distances = DEstereograficas(distances)
    % Translib15 
    % define semimajor and semiminor axis

    a = 6378137.0;
    b = 6356752.3142;

    % define eccentricity of the ellipsoid squared

    e2 = 0.00669437999013;

    % define center of projection

    height = 0;
    latitude = (56.560/3600) + (6/60) + 41;
    longitude = (33.010/3600) + (41/60) + 1;

    % define "radio esfera conforme"

    radius = 6368942.808; % in meters 

    %% Let's start the calculations
    format long;
    % Convertir latitud y longitud de cadenas de texto a números
    % distances.Latitude = distances.Latitude;
    % distances.Longitude = distances.Longitude;
    radius = 6368942.808;
    % Cartesian coordinates
    x = (radius + distances.Height) .* cosd(distances.Latitude) .* cosd(distances.Longitude);
    y = (radius + distances.Height) .* cosd(distances.Latitude) .* sind(distances.Longitude);
    z = (radius + distances.Height) .* sind(distances.Latitude);

    % Square distance from the projected point to the projection center in the xy-plane
    distXYSquared = x .* x + y .* y;

    % Radius of curvature in Prime Vertical
    radius_vertical = (a * (1 - e2)) / (1 - e2 * sin(latitude)^2)^1.5;

    % Radial distance from the projection center to the projected point
    % Letra H en página 41 del documento
    radial_distance = sqrt(distXYSquared + (z + height + radius_vertical) .* (z + height + radius_vertical)) - radius_vertical;
      
    % Scale factor
   for i=1:length(z)
        k(i) =  (2*radius_vertical)/(2 * radius_vertical + height + z(i) + radial_distance(i)); 
   end
   k_columna = k(:);
    % Asignar coordenadas estereográficas a la estructura distances
    distances.X = k_columna .* x;
    distances.Y = k_columna .* y;
    distances.Z = radial_distance;
end




 

