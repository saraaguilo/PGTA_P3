clear all 
close all

%% Primero debemos cargar los archivos de excel
% El primero que se carga es el fichero de Asterix, después el de
% flightplans

choice1 = questdlg('Select the ASTERIX file', 'Dialog', 'OK', 'Cancel', 'OK');
switch choice1
    case 'OK'
        disp('You chose OK');
    case 'Cancel'
        disp('Canceled operation');
end

