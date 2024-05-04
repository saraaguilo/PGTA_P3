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

function distance = distancescalculating(posiciones_x1, posiciones_y1, posiciones_z1, posiciones_x2, posiciones_y2, posiciones_z2)
    
    diff_x = posiciones_x2 - posiciones_x1;
    diff_y = posiciones_y2 - posiciones_y1;
    diff_z = posiciones_z2 - posiciones_z1;
    
    % Calcula la distancia euclidiana
    distance = sqrt(diff_x.^2 + diff_y.^2 + diff_z.^2);
end
