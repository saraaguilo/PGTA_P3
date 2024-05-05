clear all 
close all

%% Carga de archivos Excel
% Primero cargamos el archivo de Asterix y luego el de Flightplans

% Solicitar al usuario que seleccione un archivo de Asterix
respuesta_msg1 = questdlg('Por favor, selecciona un archivo de Asterix.', 'Atención', 'OK', 'Cancelar', 'OK');

switch respuesta_msg1
    case 'OK'
        disp('Seleccionaste OK');
        % Abrir una interfaz gráfica para la selección de archivos
        [archivo, ruta] = uigetfile('*.csv*', 'Selecciona un archivo de Asterix');

        % Verificar si el usuario selecciona un archivo o cancela la operación
        if isequal(archivo, 0)
            disp('Operación cancelada por el usuario.');
            return;  % Salir del script si el usuario cancela la operación
        end

        % Verificar si la extensión del archivo es ".csv"
        if endsWith(archivo, '.csv', 'IgnoreCase', true)
            ruta_completa = fullfile(ruta, archivo);
        else
            disp('El archivo seleccionado no es un archivo CSV. Por favor, selecciona un archivo CSV.');
            return;  % Salir del script si el usuario selecciona un archivo no válido
        end

    case 'Cancelar'
        disp('Operación cancelada por el usuario.');
        return;  % Salir del script si el usuario cancela la operación
end

% Leer los datos del archivo CSV y crear una tabla
if exist('ruta_completa', 'var')
    tablaASTERIX = readtable(ruta_completa);
else
    disp('No se seleccionó un archivo CSV.');
    return;  % Salir del script si no se selecciona un archivo CSV
end

% Solicitar al usuario que seleccione un archivo de plan de vuelo
respuesta_msg2 = questdlg('Por favor, selecciona un archivo de plan de vuelo.', 'Atención', 'OK', 'Cancelar', 'OK');

switch respuesta_msg2
    case 'OK'
        disp('Seleccionaste OK');
        % Abrir una interfaz gráfica para la selección de archivos
        [archivo, ruta] = uigetfile('*.xlsx*', 'Selecciona un archivo de plan de vuelo');

        % Verificar si el usuario selecciona un archivo o cancela la operación
        if isequal(archivo, 0)
            disp('Operación cancelada por el usuario.');
            return;  % Salir del script si el usuario cancela la operación
        end

        % Verificar si la extensión del archivo es ".xlsx"
        if endsWith(archivo, '.xlsx', 'IgnoreCase', true)
            ruta_completa2 = fullfile(ruta, archivo);
        else
            disp('El archivo seleccionado no es un archivo xlsx. Por favor, selecciona un archivo xlsx.');
            return;  % Salir del script si el usuario selecciona un archivo no válido
        end

    case 'Cancelar'
        disp('Operación cancelada por el usuario.');
        return;  % Salir del script si el usuario cancela la operación
end

% Leer los datos del archivo Excel y crear una tabla
if exist('ruta_completa2', 'var')
    tablaPLANVUELO = readtable(ruta_completa2);
else
    disp('No se seleccionó un archivo xlsx.');
    return;  % Salir del script si no se selecciona un archivo Excel
end

%% Filtrado de archivos

LEBL_id = tablaPLANVUELO.Indicativo; 
id_Asterix = tablaASTERIX.Var11;

% Filtrar los callsign que tienen plan de vuelo dep en LEBL
included = ismember(id_Asterix, LEBL_id);
tablaFiltrada = tablaASTERIX(included,:);

posiciones_x = [];
posiciones_y = [];
posiciones_z = [];


for j = 1:height(tablaFiltrada)
    LAT = tablaFiltrada.Var3(j); 
    LON = tablaFiltrada.Var4(j); 
    H = str2double(tablaFiltrada.Var5{j}) * 0.3048; %para pasar de pies a metros
    distances = struct('Latitude', LAT, 'Longitude', LON, 'Height', H);
    distances = DEstereograficas(distances);
    posiciones_x = [posiciones_x; distances.X];
    posiciones_y = [posiciones_y; distances.Y];
    posiciones_z = [posiciones_z; distances.Z];
end

tablaCOORDENADAS = table(posiciones_x, posiciones_y, posiciones_z);
tablaFiltrada = [tablaFiltrada tablaCOORDENADAS];

%% Empezamos a analizar la tabla de departures de LEBL

ids = tablaPLANVUELO.id;
Indicativos = string(tablaPLANVUELO.Indicativo);
HoraDespegues = string(tablaPLANVUELO.HoraDespegue);
RutaSACTAs = string(tablaPLANVUELO.RutaSACTA);
TipoAeronaves = string(tablaPLANVUELO.TipoAeronave);
Estelas = string(tablaPLANVUELO.Estela);
ProcDesps = string(tablaPLANVUELO.ProcDesp);
PistaDesps = string(tablaPLANVUELO.PistaDesp);

% Inicializamos las variables para las pistas 06R y 24L
ids6 = [];
Indicativos6 = [];
HoraDespegues6 = [];
RutaSACTAs6 = [];
TipoAeronaves6 = [];
Estelas6 = [];
ProcDesps6 = [];

ids24 = [];
Indicativos24 = [];
HoraDespegues24 = [];
RutaSACTAs24 = [];
TipoAeronaves24 = [];
Estelas24 = [];
ProcDesps24 = [];

% Clasificamos los vuelos según la pista de despegue y construimos las tablas
for j = 1:length(PistaDesps)
    if PistaDesps(j) == "LEBL-06R"
        ids6 = [ids6; ids(j)];
        Indicativos6 = [Indicativos6; Indicativos(j)];
        HoraDespegues6 = [HoraDespegues6; HoraDespegues(j)];
        RutaSACTAs6 = [RutaSACTAs6; RutaSACTAs(j)];
        TipoAeronaves6 = [TipoAeronaves6; TipoAeronaves(j)];
        Estelas6 = [Estelas6; Estelas(j)];
        ProcDesps6 = [ProcDesps6; ProcDesps(j)];
    elseif PistaDesps(j) == "LEBL-24L"
        ids24 = [ids24; ids(j)];
        Indicativos24 = [Indicativos24; Indicativos(j)];
        HoraDespegues24 = [HoraDespegues24; HoraDespegues(j)];
        RutaSACTAs24 = [RutaSACTAs24; RutaSACTAs(j)];
        TipoAeronaves24 = [TipoAeronaves24; TipoAeronaves(j)];
        Estelas24 = [Estelas24; Estelas(j)];
        ProcDesps24 = [ProcDesps24; ProcDesps(j)];
    end
end

% Creamos tablas para las pistas 06R y 24L
table_runway6 = table(ids6, Indicativos6, HoraDespegues6, RutaSACTAs6, TipoAeronaves6, Estelas6, ProcDesps6);
table_runway24 = table(ids24, Indicativos24, HoraDespegues24, RutaSACTAs24, TipoAeronaves24, Estelas24, ProcDesps24);

indices_06R = PistaDesps == "LEBL-06R";
indices_24L = PistaDesps == "LEBL-24L";

tabla_runway06R = tablaFiltrada(indices_06R, :);
tabla_runway24L = tablaFiltrada(indices_24L, :);

%En el paso anterior, hemos conseguidos filtrar la tabla principal entre
%los vuelos que salen de la pista 06R o si salen de la pista 24L

%Ahora calcularemos la distancia entre aviones consecutivos

distances = [];
aeronaveanterior = []; 
aeronaveposterior = [];
listaaviones24L = []; 
listaaviones06R = []; 

listaaviones24L = table2array(tabla_runway24L(:, "Var11"));
listaaviones06R = table2array(tabla_runway06R(:, "Var11"));

uniqueFlightIds = unique(tabla_runway24L.Var11);
tabla_runway24L.Var11 = string(tabla_runway24L.Var11);
% uniqueFlightIds = string(uniqueFlightIds);
% Obtener el número total de vuelos
numFlights = height(tabla_runway24L);

% Inicializar la matriz para almacenar todas las distancias
allDistances = zeros(numFlights-1, 1);

for i = 1:numFlights-1
    currentFlightIndex = i;
    nextFlightIndex = i + 1;
 
    distance = distancescalculating(tabla_runway24L.posiciones_x(currentFlightIndex), tabla_runway24L.posiciones_y(currentFlightIndex), tabla_runway24L.posiciones_z(currentFlightIndex), ...
        tabla_runway24L.posiciones_x(nextFlightIndex), tabla_runway24L.posiciones_y(nextFlightIndex), tabla_runway24L.posiciones_z(nextFlightIndex));
    
    % Almacenar la distancia en la matriz allDistances
    allDistances(i) = distance; 
end


%% Pérdidas de Separación en despegues consecutivos, según RADAR

%Se sabe que la mínima separación, según radar, es de 3 NM

% Calculamos el cumplimiento del criterio de distancia para cada vuelo
cumplimientoRadar = sum(allDistances < 3 & allDistances > 0.5, 2);
countRadar = sum(cumplimientoRadar > 0);

for i = find(cumplimientoRadar > 0)'
    prev = string(tabla_runway24L.Var11(i));
    next = string(tabla_runway24L.Var11(i+1));
    fprintf("\t %s - %s", prev, next);
end
fprintf("\n Total vuelos que incumplen la mínima distancia de separación por RADAR: %d\n", countRadar);

%% Pérdidas de separación en despegues consecutivos, según ESTELA

% Creamos un vector para identificar el tipo de estela de cada avión
estelasAviones = string(tablaPLANVUELO.Estela(ismember(tablaPLANVUELO.Indicativo, tabla_runway24L.Var11)));

% Comprobamos la separación por estela
cumplimientoEstela = Estela(allDistances, estelasAviones(1:end-1), estelasAviones(2:end));
countEstela24 = sum(cumplimientoEstela > 0);
for i = find(cumplimientoEstela > 0)
    previous = tabla_runway24L.Var11(i);
    following = tabla_runway24L.Var11(i+1);
    est1 = estelasAviones(i);
    est2 = estelasAviones(i+1);
end

fprintf("\n Total vuelos que incumplen la mínima distancia de separación por ESTELA: %d\n", countEstela24);

%% Pérdidas de separación en despegues consecutivos, según LoA

aircraftclassification = readtable("Tabla_Clasificacion_aeronaves.xlsx");
mismasid06 = readtable("Tabla_misma_SID_06R.xlsx");
mismasid24 = readtable("Tabla_misma_SID_24L.xlsx");

% Carga de datos
aHP = aircraftclassification.HP;
aNR = aircraftclassification.NR;
aNRMas = aircraftclassification.("NR+");
aNRMenos = aircraftclassification.("NR-");
aLP = aircraftclassification.LP;

[models, aircraftclassification] = clasificarAeronaves(tabla_runway24L.Var11, tablaPLANVUELO, aHP, aNR, aNRMas, aNRMenos, aLP);
sids = ismember(mismasid24.Misma_SID_G1, tablaPLANVUELO.ProcDesp) | ismember(mismasid24.Misma_SID_G2, tablaPLANVUELO.ProcDesp) | ismember(mismasid24.Misma_SID_G3, tablaPLANVUELO.ProcDesp);

% Verificación de LoA
cumplimientoLoA = arrayfun(@(i) LoA2(aircraftclassification(i), aircraftclassification(i+1), sids(i), allDistances(i,:)), 1:(length(allDistances)-1));
countSID24 = sum(cumplimientoLoA);

for i = 1:length(cumplimientoLoA)
    if cumplimientoLoA(i)
        previous = string(listaaviones24L(i));
        following = string(listaaviones24L(i+1));
        est1 = string(aircraftclassification(i));
        est2 = string(aircraftclassification(i+1));
        fprintf(previous + " (" + est1 + ") - " + following + " (" + est2 + ")\t\t");
        if mod(i, 5) == 0
            fprintf("\n");
        end
    end
end
fprintf("\n Total vuelos que incumplen la mínima distancia de separación por LoA: %d\n", countSID24);

%% Creación de tabla de resultados
departures = arrayfun(@(i) listaaviones24L(i) + " - " + listaaviones24L(i+1), 2:length(listaaviones24L), 'UniformOutput', false);
departures = [departures; ""];
tablaResultados = table(departures, cumplimientoRadar.', cumplimientoEstela.', cumplimientoLoA.');

%% Calculo, de manera estadística, de la posición (lat,lon), (x,y) y altitud en el momento del inicio del viraje en las aeronaves (24L)

latitude = [];  
longitude = [];
altitude = [];

for i = 1:length(tabla_runway24L.PistaDesps)
    if tabla_runway24L.PistaDesps(i) == "LEBL-24L"
        latitude(end+1) = tabla_runway24L.Var3(i);
        longitude(end+1) = tabla_runway24L.Var4(i);
        altitude(end+1) = tabla_runway24L.Var5(i);
    end
end

% Calcular la media de las posiciones y altitudes
if ~isempty(latitude)
    mean_latitude = mean(latitude);
    mean_longitude = mean(longitude);
    mean_altitude = mean(altitude);
    
    fprintf('Estadísticas en el momento del inicio del viraje:\n');
    fprintf('Latitud media: %.6f\n', mean_latitude);
    fprintf('Longitud media: %.6f\n', mean_longitude);
    fprintf('Altitud media: %.2f\n', mean_altitude);
else
    fprintf('No se encontraron datos para el momento del inicio del viraje en la RWY 24L.\n');
end

%% Determinar el radial del DVOR BCN a esos puntos para comprobar si cumple la Nota de la SID en el AIP

% Coordenadas del DVOR BCN
vorr_lat = dms2degrees([41, 18, 25.6]); 
vorr_lon = dms2degrees([2, 6, 28.1]);    

% Calculamos el rumbo magnético desde el DVOR BCN hacia cada punto de inicio del viraje
for i = 1:length(latitude)
    lat = latitude(i);
    lon = longitude(i);
    [azimuth, ~, ~] = geodetic2aer(lat, lon, 0, vorr_lat, vorr_lon, 0, wgs84Ellipsoid);
    fprintf('Radial del DVOR BCN al punto %d: %.2f grados\n', i, azimuth);
end

%% Used functions

function distance = distancescalculating(posiciones_x1, posiciones_y1, posiciones_z1, posiciones_x2, posiciones_y2, posiciones_z2)
    
    diff_x = posiciones_x2 - posiciones_x1;
    diff_y = posiciones_y2 - posiciones_y1;
    diff_z = posiciones_z2 - posiciones_z1;
    
    % Calcula la distancia euclidiana
    distance = sqrt(diff_x.^2 + diff_y.^2 + diff_z.^2);
end

