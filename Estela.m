function cumple = Estela(dist, preceding, succeding)
    minimoValor = min(dist(dist > 0.5), [], 2);  % Buscamos el mínimo valor de las distancias que sean mayores que 0.5
    cumple = false(size(preceding));
    
    for i = 1:numel(preceding)
        if preceding(i) == "Super pesada"
            switch succeding(i)
                case "Pesada"
                    if minimoValor(i) < 6
                        cumple(i) = true;
                    end
                case "Media"
                    if minimoValor(i) < 7
                        cumple(i) = true; 
                    end
                case "Ligera"
                    if minimoValor(i) < 8
                        cumple(i) = true; 
                    end
            end
        elseif preceding(i) == "Pesada"
            switch succeding(i)
                case "Pesada"
                    if minimoValor(i) < 4
                        cumple(i) = true;
                    end
                case "Media"
                    if minimoValor(i) < 5
                        cumple(i) = true;  
                    end
                case "Ligera"
                    if minimoValor(i) < 6
                        cumple(i) = true; 
                    end
            end
        elseif preceding(i) == "Media" && succeding(i) == "Ligera"
            if minimoValor(i) < 5
                cumple(i) = true; 
            end
        end
    end
end

