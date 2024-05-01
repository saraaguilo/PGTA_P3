clear all 
close all

%% Primero debemos cargar los archivos de excel
% El primero que se carga es el fichero de Asterix, después el de
% flightplans

% Prompt the user to select an ASTERIX file
respuesta_msg1 = questdlg('Por favor, selecciona un archivo de ASTERIX.', 'Atención', 'OK', 'Cancelar', 'OK');

switch respuesta_msg1
    case 'OK'
        disp('You chose OK');
        % Open a graphical interface for file selection
        [archivo, ruta] = uigetfile('*.csv*', 'Selecciona un archivo de ASTERIX');

        % Check if the user selects a file or cancels the operation
        if isequal(archivo, 0)
            disp('Operación cancelada por el usuario.');
            return;  % Exit the script if the user cancels the operation
        end

        % Check if the file extension is ".csv"
        if endsWith(archivo, '.csv', 'IgnoreCase', true)
            ruta_completa = fullfile(ruta, archivo);
        else
            disp('El archivo seleccionado no es un archivo CSV. Por favor, selecciona un archivo CSV.');
            return;  % Exit the script if the user selects an invalid file
        end

    case 'Cancelar'
        disp('Operación cancelada por el usuario.');
        return;  % Exit the script if the user cancels the operation
end

% Read the data from the CSV file and create a table
if exist('ruta_completa', 'var')
    tablaASTERIX = readtable(ruta_completa);
else
    disp('No se seleccionó un archivo CSV.');
    return;  % Exit the script if no CSV file is selected
end

% Prompt the user to select a flight plan file
respuesta_msg2 = questdlg('Por favor, selecciona un archivo de plan de vuelo', 'Atención', 'OK', 'Cancelar', 'OK');

switch respuesta_msg2
    case 'OK'
        disp('You chose OK');
        % Open a graphical interface for file selection
        [archivo, ruta] = uigetfile('*.xlsx*', 'Selecciona un archivo de plan de vuelo');

        % Check if the user selects a file or cancels the operation
        if isequal(archivo, 0)
            disp('Operación cancelada por el usuario.');
            return;  % Exit the script if the user cancels the operation
        end

        % Check if the file extension is ".xlsx"
        if endsWith(archivo, '.xlsx', 'IgnoreCase', true)
            ruta_completa2 = fullfile(ruta, archivo);
        else
            disp('El archivo seleccionado no es un archivo xlsx. Por favor, selecciona un archivo xlsx.');
            return;  % Exit the script if the user selects an invalid file
        end

    case 'Cancelar'
        disp('Operación cancelada por el usuario.');
        return;  % Exit the script if the user cancels the operation
end

% Read the data from the Excel file and create a table
if exist('ruta_completa2', 'var')
    tablaPLANVUELO = readtable(ruta_completa2);
else
    disp('No se seleccionó un archivo xlsx.');
    return;  % Exit the script if no Excel file is selected
end




