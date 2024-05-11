function info = LoA(info)
% Aquí leemos la tabla donde se clasifican las aeronaves
    aircraft_table = readtable("Inputs\Tabla_Clasificacion_aeronaves.xlsx");
    if ~ismember('AircraftType', info.Properties.VariableNames)
        info.AircraftType = repmat("R", height(info), 1);
    end

    for i = 1:height(info)
        currentAircraft = info.TipoAeronave{i};
        rowIndex = strcmp(aircraft_table.AircraftName, currentAircraft);

        if any(rowIndex)
            info.AircraftType{i} = aircraft_table.AircraftType(rowIndex);
        end
    end
end