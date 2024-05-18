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
    [num, txt, raw] = xlsread(ruta_completa);
    txt = txt(2:end, :);
    tablaASTERIX.Var1=txt(:,1);
   
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


    LAT = str2double(regexprep(tablaFiltrada.Var3, ',', '.')); 
    LON = str2double(regexprep(tablaFiltrada.Var4, ',', '.')); 
    H = str2double(regexprep(tablaFiltrada.Var5, ',', '.')); 
    distances = struct('Latitude', LAT, 'Longitude', LON, 'Height', H);
    distances = DEstereograficas(distances);
    posiciones_x = [posiciones_x; distances.X];
    posiciones_y = [posiciones_y; distances.Y];
    posiciones_z = [posiciones_z; distances.Z];


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
tabla_runway06R.Var11 = string(tabla_runway06R.Var11);
% uniqueFlightIds = string(uniqueFlightIds);
% Obtener el número total de vuelos
numFlights = height(tabla_runway24L);
numFlights2 = height(tabla_runway06R);

% Inicializar la matriz para almacenar todas las distancias



%% Pérdidas de Separación en despegues consecutivos, según RADAR

%Se sabe que la mínima separación, según radar, es de 3 NM

%Creamos la tabla filtrada de 24L para TWR, primera detección
tabla_TWR24L = table();
indicativos_vistos24 = {};

for i = 1:height(tabla_runway24L)
    indicativo = tabla_runway24L.Var11(i);
    
    if ~ismember(indicativo, indicativos_vistos24)
        indicativos_vistos24 = [indicativos_vistos24, indicativo];
        tabla_TWR24L = [tabla_TWR24L; tabla_runway24L(i,:)];
    end
end

%Creamos la tabla filtrada para 06R para TWR, primera detección

tabla_TWR06R = table();
indicativos_vistos06 = {};

for i = 1:height(tabla_runway06R)
    indicativo = tabla_runway06R.Var11(i);
    
    if ~ismember(indicativo, indicativos_vistos06)
        indicativos_vistos06 = [indicativos_vistos06, indicativo];
        tabla_TWR06R = [tabla_TWR06R; tabla_runway06R(i,:)];
    end
end

%Creamos la tabla filtrada para 06R para TMA

tabla_TMA24 = table();

for i = 1:length(indicativos_vistos24)
    indicativo = indicativos_vistos24(i);
    filas_indicativo = tabla_runway24L(tabla_runway24L.Var11 == indicativo, :);
    filas_indicativo(1,:) = [];
    tabla_TMA24 = [tabla_TMA24; filas_indicativo];
end
tabla_TMA24=sortrows(tabla_TMA24,1);

%Creamos la tabla filtrada para 24L para TMA

tabla_TMA06 = table();

for i = 1:length(indicativos_vistos06)
    indicativo2 = indicativos_vistos06{i};
    filas_indicativo2 = tabla_runway06R(tabla_runway06R.Var11 == indicativo2, :);
    filas_indicativo2(1,:) = [];
    tabla_TMA06 = [tabla_TMA06; filas_indicativo2];
end
tabla_TMA06=sortrows(tabla_TMA06,1);

%important
numFlights24TWR = height(tabla_TWR24L);
numFlights06TWR = height(tabla_TWR06R);
numFlights24TMA = height(tabla_TMA24);
numFlights06TMA = height(tabla_TMA06);
% Inicializar la matriz para almacenar todas las distancias
allDistances24TWR = zeros(numFlights24TWR-1, 1);
allDistances06TWR = zeros(numFlights06TWR-1, 1);
allDistances24TMA = zeros(numFlights24TMA-1, 1);
allDistances06TMA = zeros(numFlights06TMA-1, 1);

for i = 1:numFlights24TWR-1
    currentFlightIndex = i;
    nextFlightIndex = i + 1;
 
    distance24TWR = distancescalculating(tabla_TWR24L.posiciones_x(currentFlightIndex), tabla_TWR24L.posiciones_y(currentFlightIndex), tabla_TWR24L.posiciones_z(currentFlightIndex), ...
        tabla_TWR24L.posiciones_x(nextFlightIndex), tabla_TWR24L.posiciones_y(nextFlightIndex), tabla_TWR24L.posiciones_z(nextFlightIndex));
    
    % Almacenar la distancia en la matriz allDistances en NM
    allDistances24TWR(i) = distance24TWR/1852; 
end

for i = 1:numFlights06TWR-1
    currentFlightIndex = i;
    nextFlightIndex = i + 1;
 
    distance06TWR = distancescalculating(tabla_TWR06R.posiciones_x(currentFlightIndex), tabla_TWR06R.posiciones_y(currentFlightIndex), tabla_TWR06R.posiciones_z(currentFlightIndex), ...
        tabla_TWR06R.posiciones_x(nextFlightIndex), tabla_TWR06R.posiciones_y(nextFlightIndex), tabla_TWR06R.posiciones_z(nextFlightIndex));
    
    % Almacenar la distancia en la matriz allDistances en NM
    allDistances06TWR(i) = distance06TWR/1852; 
end

for i = 1:numFlights24TMA-1
    currentFlightIndex = i;
    nextFlightIndex = i + 1;
 
    distance24TMA = distancescalculating(tabla_TMA24.posiciones_x(currentFlightIndex), tabla_TMA24.posiciones_y(currentFlightIndex), tabla_TMA24.posiciones_z(currentFlightIndex), ...
        tabla_TMA24.posiciones_x(nextFlightIndex), tabla_TMA24.posiciones_y(nextFlightIndex), tabla_TMA24.posiciones_z(nextFlightIndex));
    
    % Almacenar la distancia en la matriz allDistances en NM
    allDistances24TMA(i) = distance24TMA/1852; 
end

for i = 1:numFlights06TMA-1
    currentFlightIndex = i;
    nextFlightIndex = i + 1;
 
    distance06TMA = distancescalculating(tabla_TMA06.posiciones_x(currentFlightIndex), tabla_TMA06.posiciones_y(currentFlightIndex),tabla_TMA06.posiciones_z(currentFlightIndex), ...
      tabla_TMA06.posiciones_x(nextFlightIndex), tabla_TMA06.posiciones_y(nextFlightIndex), tabla_TMA06.posiciones_z(nextFlightIndex));
    
    % Almacenar la distancia en la matriz allDistances en NM
    allDistances06TMA(i) = distance06TMA/1852; 
end

%aqui sacaba

% Calculamos el cumplimiento del criterio de distancia para cada vuelo, de
% la pista 24LTWR
cumplimientoRadar24TWR = sum(allDistances24TWR < 3 & allDistances24TWR > 0.5, 2);
countRadar24TWR = sum(cumplimientoRadar24TWR > 0);

%i = find(cumplimientoRadar24TWR > 0, 1);
for i=1:height(tabla_TWR24L)-1
if ~isempty(i)
    prev = string(tabla_TWR24L.Var11(i));
    next = string(tabla_TWR24L.Var11(i+1));
    if(allDistances24TWR(i)<3 & allDistances24TWR(i) > 0.5)
    fprintf("\t %s - %s\n", prev, next);
    %countRadar = 1;
    end
else
    fprintf("No hay vuelos que incumplan la mínima distancia de separación por RADAR de la pista 24L TWR.\n");
end
end
fprintf("Total vuelos que incumplen la mínima distancia de separación por RADAR de la pista 24L TWR: %d\n", countRadar24TWR);


% Calculamos el cumplimiento del criterio de distancia para cada vuelo, de
% la pista 06RTWR
cumplimientoRadar06TWR = sum(allDistances06TWR < 3 & allDistances06TWR > 0.5, 2);
countRadar06TWR = sum(cumplimientoRadar06TWR > 0);

%i = find(cumplimientoRadar24TWR > 0, 1);
for i=1:height(tabla_TWR06R)-1
if ~isempty(i)
    prev = string(tabla_TWR06R.Var11(i));
    next = string(tabla_TWR06R.Var11(i+1));
    if(allDistances06TWR(i)<3 & allDistances06TWR(i) > 0.5)
    fprintf("\t %s - %s\n", prev, next);
    %countRadar = 1;
    end
else
    fprintf("No hay vuelos que incumplan la mínima distancia de separación por RADAR de la pista 06R TWR.\n");
end
end
fprintf("Total vuelos que incumplen la mínima distancia de separación por RADAR de la pista 06R TWR: %d\n", countRadar06TWR);


cumplimientoRadar24TMA = sum(allDistances24TMA < 3 & allDistances24TMA > 0.5, 2);
countRadar24TMA = sum(cumplimientoRadar24TMA > 0);

%i = find(cumplimientoRadar24TWR > 0, 1);
for i=1:height(tabla_TMA24)-1
if ~isempty(i)
    prev = string(tabla_TMA24.Var11(i));
    next = string(tabla_TMA24.Var11(i+1));
    if(allDistances24TMA(i)<3 & allDistances24TMA(i) > 0.5)
    fprintf("\t %s - %s\n", prev, next);
    %countRadar = 1;
    end
else
    fprintf("No hay vuelos que incumplan la mínima distancia de separación por RADAR de la pista 24L TMA.\n");
end
end
fprintf("Total vuelos que incumplen la mínima distancia de separación por RADAR de la pista 24L TMA: %d\n", countRadar24TMA);


cumplimientoRadar06TMA = sum(allDistances06TMA < 3 & allDistances06TMA > 0.5, 2);
countRadar06TMA = sum(cumplimientoRadar06TMA > 0);

%i = find(cumplimientoRadar24TWR > 0, 1);
for i=1:height(tabla_TMA06)-1
if ~isempty(i)
    prev = string(tabla_TMA06.Var11(i));
    next = string(tabla_TMA06.Var11(i+1));
    if(allDistances06TMA(i)<3 & allDistances06TMA(i) > 0.5)
    fprintf("\t %s - %s\n", prev, next);
    %countRadar = 1;
    end
else
    fprintf("No hay vuelos que incumplan la mínima distancia de separación por RADAR de la pista 06R TWR.\n");
end
end
fprintf("Total vuelos que incumplen la mínima distancia de separación por RADAR de la pista 06R TMA: %d\n", countRadar06TMA);

%% Pérdidas de separación en despegues consecutivos, según ESTELA

% Creamos un vector para identificar el tipo de estela de cada avión
estelasAviones24TWR = string(tablaPLANVUELO.Estela(ismember(tablaPLANVUELO.Indicativo, tabla_TWR24L.Var11)));

% Comprobamos la separación por estela
cumplimientoEstela24TWR = Estela(allDistances24TWR, estelasAviones24TWR(1:end-1), estelasAviones24TWR(2:end));
countEstela24TWR = sum(cumplimientoEstela24TWR > 0);

% Ajustamos el bucle para emparejar correctamente los indicativos y sus siguientes
for i = 1:numel(cumplimientoEstela24TWR)
    if cumplimientoEstela24TWR(i) > 0
        previous = tabla_TWR24L.Var11(i);
        following = tabla_TWR24L.Var11(i+1);
        est1 = estelasAviones24TWR(i);
        est2 = estelasAviones24TWR(i+1);
        fprintf("\t %s - %s\n", previous, following);
    end
end

fprintf("\n Total vuelos que incumplen la mínima distancia de separación por ESTELA para la pista 24L TWR: %d\n", countEstela24TWR);


% Creamos un vector para identificar el tipo de estela de cada avión, para
% la pista 06R
estelasAviones2 = string(tablaPLANVUELO.Estela(ismember(tablaPLANVUELO.Indicativo, table_runway6.Indicativos6)));

% Comprobamos la separación por estela
cumplimientoEstela2 = Estela(allDistances06R, estelasAviones2(1:end-1), estelasAviones2(2:end));
countEstela06 = sum(cumplimientoEstela2 > 0);
for i = find(cumplimientoEstela2 > 0)
    previous2 = table_runway6.Indicativos6(i);
    following2 = table_runway6.Indicativos6(i+1);
    est3 = estelasAviones2(i);
    est4 = estelasAviones2(i+1);
    % fprintf("\t %s - %s\n", previous2, following2);
end

fprintf("\n Total vuelos que incumplen la mínima distancia de separación por ESTELA para la pista 06R: %d\n", countEstela06);


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


%% Velocidad IAS de los despegues a distintas altitudes: 850 ft, 1500 ft y 3500 ft

%%mirar lo de hora de despegue

% Aquí usaremos la tabla filtrada para la pista 24L
% 1m = 3.28084ft

array_velocidades850 = [];
array_velocidades1500 = [];
array_velocidades3500 = [];

unique_planes = unique(tabla_runway24L.Var11);  


for plane_id = unique_planes'
    rows = tabla_runway24L.Var11 == plane_id;
    alturas_cell = tabla_runway24L.Var5(rows); 


alturas_str_cleaned = regexprep(alturas_cell, '[^\d.]', ''); 
alturas_numeric = str2double(alturas_str_cleaned);
alturas = alturas_numeric * 3.28084; 

    IAS_values = tabla_runway24L.Var19(rows);
    % disp(IAS_values +" a1");

   
    velocidad850 = NaN;
    velocidad1500 = NaN;
    velocidad3500 = NaN;
    for j = 1:length(alturas)
        if isnan(velocidad850) && alturas(j) >= 850
            velocidad850 = IAS_values(j);
            % disp(IAS_values+" f2");
        end
        if isnan(velocidad1500) && alturas(j) >= 1500
            velocidad1500 = IAS_values(j);
            % disp(IAS_values+" j3");
        end
        if isnan(velocidad3500) && alturas(j) >= 3500
            velocidad3500 = IAS_values(j);
            % disp(IAS_values+" k4");
        end
        if ~isnan(velocidad850) && ~isnan(velocidad1500) && ~isnan(velocidad3500)
            break;
        end
    end
  
    array_velocidades850(end+1) = velocidad850;
    array_velocidades1500(end+1) = velocidad1500;
    array_velocidades3500(end+1) = velocidad3500;
end

disp('Velocidades a 850 ft para 24L:');
disp(array_velocidades850);
disp('Velocidades a 1500 ft para 24L:');
disp(array_velocidades1500);
disp('Velocidades a 3500 ft para 24L:');
disp(array_velocidades3500);

% Aquí usaremos la tabla filtrada para la pista 06R
% 1m = 3.28084ft

array_velocidades850_06 = [];
array_velocidades1500_06= [];
array_velocidades3500_06 = [];

unique_planes_06 = unique(tabla_runway06R.Var11);  


for plane_id_06 = unique_planes_06'
    rows_06 = tabla_runway06R.Var11 == plane_id_06;
    alturas_cell_06 = tabla_runway06R.Var5(rows_06); % Corregido

    alturas_str_cleaned_06 = regexprep(alturas_cell_06, '[^\d.]', ''); 
    alturas_numeric_06 = str2double(alturas_str_cleaned_06);
    alturas_06 = alturas_numeric_06 * 3.28084;  

    IAS_values_06 = tabla_runway06R.Var19(rows_06);
    velocidad850_06 = NaN;
    velocidad1500_06 = NaN;
    velocidad3500_06 = NaN;
    for j = 1:length(alturas_06)
        if isnan(velocidad850_06) && alturas_06(j) >= 850
            velocidad850_06 = IAS_values_06(j);
        end
        if isnan(velocidad1500_06) && alturas_06(j) >= 1500
            velocidad1500_06 = IAS_values_06(j);
        end
        if isnan(velocidad3500_06) && alturas_06(j) >= 3500
            velocidad3500_06 = IAS_values_06(j);
        end
        if ~isnan(velocidad850_06) && ~isnan(velocidad1500_06) && ~isnan(velocidad3500_06)
            break;
        end
    end
  
    array_velocidades850_06(end+1) = velocidad850_06;
    array_velocidades1500_06(end+1) = velocidad1500_06;
    array_velocidades3500_06(end+1) = velocidad3500_06;
end

disp('Velocidades a 850 ft para 06R:');
disp(array_velocidades850_06);
disp('Velocidades a 1500 ft para 06R:');
disp(array_velocidades1500_06);
disp('Velocidades a 3500 ft para 06R:');
disp(array_velocidades3500_06);
        
%% Used functions

function distance = distancescalculating(posiciones_x1, posiciones_y1, posiciones_z1, posiciones_x2, posiciones_y2, posiciones_z2)
    
    diff_x = posiciones_x2 - posiciones_x1;
    diff_y = posiciones_y2 - posiciones_y1;
    diff_z = posiciones_z2 - posiciones_z1;
    
    % Calcula la distancia euclidiana
    distance = sqrt(diff_x.^2 + diff_y.^2 + diff_z.^2);
end



