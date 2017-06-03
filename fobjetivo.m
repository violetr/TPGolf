function vfi = fobjetivo(variables,n) %Funcion objetivo, se busca minimizar la velocidad en el punto de llegada

vfi=variables(5*(n+1)+n)^2+variables(5*(n+1)+2*n)^2;
% variante que no intenta que se vuelva cero la velocidad, si no chica
%vfi=(variables(5*(n+1)+n)^2+variables(5*(n+1)+2*n)^2-0.25)^2;

end
