% Calcular de manera estadística la posición (lat,lon), (x,y)
% y altitud en el momento del inicio del viraje en las aeronaves
% despegando por la RWY 24L

function PositionandAltitude(beforeTable, afterTable)
% 'x' and 'y' columns exist?
     if ~ismember('x', afterTable.Properties.VariableNames)
         afterTable.x = zeros(height(afterTable), 1);
     end
     if ~ismember('y', afterTable.Properties.VariableNames)
         afterTable.x = zeros(height(afterTable), 1);
     end
% Miramos tabla dep_lebl
    if iscell(afterTable.HoraDespegue)
       afterTable.HoraDespegue = cellfun(@(x) datetime(x, 'InputFormat', 'HH:mm:ss'), afterTable.HoraDespegue);
    end
% beforeTable: P3_08_12h
% afterTable: 2305_02_dep_lebl
    % Find matching rows and update 'x' and 'y'
    for i = 1:height(afterTable)
         matchingRowIndex = find(beforeTable.TI == afterTable.id(i) & ...
                   beforeTable.Hours == afterTable.HoraDespegue(i).Hour & ...
                   beforeTable.Minutes == afterTable.HoraDespegue(i).Minute & ...
                   beforeTable.Seconds == afterTable.HoraDespegue(i).Second, 1);

        if ~isempty(matchingRowIndex)
           afterTable.x(i) = beforeTable.x(matchingRowIndex);
            afterTable.y(i) = beforeTable.y(matchingRowIndex);
        else
            afterTable.x(i) = NaN;
            afterTable.y(i) = NaN;
        end
    end
end

