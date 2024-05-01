function cumplimiento = LoA2(precedente, sucesiva, SID, dist)
    min = inf;
    cumplimiento = false;

    % Valor mínimo de las distancias entre dos aviones
    for i = 1:length(dist)
        if dist(i) < min && dist(i) > 1
            min = dist(i);
        end
    end
    % Comprobamos según SID y la clase de los aviones
    switch precedente
        case "HP"
            switch sucesiva
                case {"HP", "R", "LP"}
                    if SID == 1 && min < 5
                        cumplimiento = true;
                    elseif SID == 0 && min < 3
                        cumplimiento = true;
                    end
                case {"NR+", "NR-", "NR"}
                    if min < 3
                        cumplimiento = true;
                    end
            end
        case "R"
            switch sucesiva
                case "HP"
                    if SID == 1 && min < 7
                        cumplimiento = true;
                    elseif min < 5
                        cumplimiento = true;
                    end
                case {"R", "LP"}
                    if SID == 1 && min < 5
                        cumplimiento = true;
                    elseif min < 3
                        cumplimiento = true;
                    end
                case {"NR+", "NR-", "NR"}
                    if min < 3
                        cumplimiento = true;
                    end
            end
        case "LP"
            switch sucesiva
                case "HP"
                    if SID == 1 && min < 8
                        cumplimiento = true;
                    elseif min < 6
                        cumplimiento = true;
                    end
                case "R"
                    if SID == 1 && min < 6
                        cumplimiento = true;
                    elseif min < 4
                        cumplimiento = true;
                    end
                case "LP"
                    if SID == 1 && min < 5
                        cumplimiento = true;
                    elseif min < 3
                        cumplimiento = true;
                    end
                case {"NR+", "NR-", "NR"}
                    if min < 3
                        cumplimiento = true;
                    end
            end
        case "NR+"
            switch sucesiva
                case "HP"
                    if SID == 1 && min < 11
                        cumplimiento = true;
                    elseif min < 8
                        cumplimiento = true;
                    end
                case {"R", "LP"}
                    if SID == 1 && min < 9
                        cumplimiento = true;
                    elseif min < 6
                        cumplimiento = true;
                    end
                case "NR+"
                    if SID == 1 && min < 5
                        cumplimiento = true;
                    elseif min < 3
                        cumplimiento = true;
                    end
                case {"NR-", "NR"}
                    if min < 3
                        cumplimiento = true;
                    end
            end
        case "NR-"
            switch sucesiva
                case {"HP", "R", "LP"}
                    if min < 9
                        cumplimiento = true;
                    end
                case "NR+"
                    if SID == 1 && min < 9
                        cumplimiento = true;
                    elseif min < 6
                        cumplimiento = true;
                    end
                case "NR-"
                    if SID == 1 && min < 5
                        cumplimiento = true;
                    elseif min < 3
                        cumplimiento = true;
                    end
                case "NR"
                    if min < 3
                        cumplimiento = true;
                    end
            end
        case "NR"
            if sucesiva == "NR"
                if SID == 1 && min < 5
                    cumplimiento = true;
                elseif min < 3
                    cumplimiento = true;
                end
            elseif min < 9
                cumplimiento = true;
            end
    end
end
