% Uno de los parámetros ATM de interés es: pérdidas de separación entre
% despegues consecutivos según Radar

function Radar(flightplan, asterix)

% Departure time components
departuretimeinHours = [flightplan.HoraDespegue.Hour];
departuretimeinMinutes = [flightplan.HoraDespegue.Minute];
departuretimeinSeconds = [flightplan.HoraDespegue.Second];

[~, idx_flightplan, idx_asterix] = intersect([flightplan.id, departuretimeinHours, departuretimeinMinutes, departuretimeinSeconds], ...
                                             [asterix.TI, asterix.Hours, asterix.Minutes, asterix.Seconds], 'rows');

% Calculating distance for matching messages
x1 = asterix.X(idx_asterix);
y1 = asterix.Y(idx_asterix);
x2 = flightplan.X(idx_flightplan);
y2 = flightplan.Y(idx_flightplan);
distance = sqrt((x2 - x1).^2 + (y2 - y1).^2);

flightplan.Distance(idx_flightplan) = distance;

end
