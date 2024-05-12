function [taulamodel,taulatipus] = clasificarAviones(listaOrdenDep24,tablaPLANVUELO,aviones)
%input: callsigns, classigns amb avio i tipus d'avio

taulamodel = []; %columna1: model. cloumna2: tipus
for i=1:size(listaOrdenDep24,1)
pos=find(tablaPLANVUELO.Indicativo==listaOrdenDep24(i));
taulamodel=[taulamodel,(tablaPLANVUELO.TipoAeronave(pos(1)))];
end

taulatipus=[];
for i=1:length(taulamodel)
    pos1=find(aviones.HP==taulamodel(i));
    pos2=find(aviones.NR==taulamodel(i));
    pos3=find(aviones.("NR+")==taulamodel(i));
    pos4=find(aviones.("NR-")==taulamodel(i));
    pos5=find(aviones.LP==taulamodel(i));
    if(isempty(pos1))
        if(isempty(pos2))
            if(isempty(pos3))
            if(isempty(pos4))
                if(isempty(pos5))
                taulatipus=[taulatipus, "R"];
                else
                    taulatipus=[taulatipus, "LP"];
                end
            
            else
                taulatipus=[taulatipus, "NR-"];
            
            end
            else
                taulatipus=[taulatipus, "NR+"];
            end

   
        else
            taulatipus=[taulatipus, "NR"];

        end
    else
        taulatipus=[taulatipus, "HP"];
    end
end





% i=1;
% k=1;
% found=0;
% taulatipus=[];
% while(i<=length(taulamodel))
%     while(k<=size(aviones,1)&&found==0)
% if(strcmp(taulamodel(i),(aviones(k,1))))
%     taulatipus=[taulatipus,"HP"];
%     found=1;
% elseif(strcmp(taulamodel(i),(aviones(k,2))))
%     taulatipus=[taulatipus,"NR"];
%     found=1;
% elseif(strcmp(taulamodel(i),(aviones(k,3))))
%     taulatipus=[taulatipus,"NR+"];
%     found=1;
% elseif(strcmp(taulamodel(i),(aviones(k,4))))
%     taulatipus=[taulatipus,"NR-"];
%     found=1;
% elseif(strcmp(taulamodel(i),(aviones(k,5))))
%     taulatipus=[taulatipus,"LP"];
%     found=1;
% elseif(k==size(aviones,1) && found==0)
%     taulatipus=[taulatipus,"R"];
%     found=1;
%     k=1;
% else
%    k=k+1;
% end
% 
% end
%   i=i+1;   
%   found=0;
%  end

end