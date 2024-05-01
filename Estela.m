function cumple = Estela(dist, preceding, succeding)
    minimoValor = inf; 
    cumple = 0; 
    
    % Buscamos el mínimo valor de las distancias que sean mayores que 0.5
    for i = 1:length(dist)
        if dist(i) > 1 && dist(i) < minimoValor
            minimoValor = dist(i);
        end
    end
    
    % Comprobamos según el tipo de estela de los aviones
    if preceding == "Super pesada"
        switch succeding
            case "Pesada"
                if minimoValor < 6
                    cumple = 1;
                end
            case "Media"
                if minimoValor < 7
                    cumple = 1; 
                end
            case "Ligera"
                if minimoValor < 8
                    cumple = 1; 
                end
        end
    elseif preceding == "Pesada"
        switch succeding
            case "Pesada"
                if minimoValor < 4
                    cumple = 1;
                end
            case "Media"
                if minimoValor < 5
                    cumple = 1;  
                end
            case "Ligera"
                if minimoValor < 6
                    cumple = 1; 
                end
        end
    elseif preceding == "Media" && succeding == "Ligera"
        if minimoValor < 5
            cumple = 1; 
        end
    end
end
