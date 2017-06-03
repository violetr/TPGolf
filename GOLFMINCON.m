function [X, fval, exitflag, history] = GOLFMINCON(x0,y0,xn,yn,n,Tini,algoritmo,grafico)

% esta funcion minimiza la función fobjetivo.m
% en la región factible determinada por las restricciones
% no lineales determinadas en restnolineales.m
% con las restricciones lineales especificadas en en Ax=b
% y Aeq<=beq. x0,y0, xn,yn son las variables espaciales
% iniciales y finales (fijos). Tini es es el valor inicial 
% que se le pasa a fmincon como valor de inicial. Si grafico 
% vale true entonces grafica el resultado. La función de x,y 
% que determina la forma del terreno está especificada en terreno.m

% ACLARACIÓN!: si se cambia la función terreno hay que cambiar a 
% mano en restnolineales dz/dy (no lineal) y dz/dx (lineal). Si 
% dz/dx deja de ser lineal, hay que cancelar la condición lineal
% y agregar la condición no lineal en restnolineales. 

%llamado: GOLFMINCON(1,2,1,-2,50,2,'sqp',true) (u otro algoritmo)

% constantes que usamos
g=9.8; %gravedad
m=0.01; %Masa de la bola
mu=0.07; %Rozamiento

% T es una variable, no un parametro!
% sugieren que el inicial este entre 1 y 3
% el lugar de T es nvar

nvar=5*(n+1)+3*n+14*(n-1)+1;
neqlin=5*(n-1)+5; 
nineqlin=1; %T es positivo
neqnolin=3*n+2*(n+1)+11*(n-1);
nineqnolin=n+1; %on  the green


variables=zeros(nvar,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESTRICCIONES LINEALES

Aeq=zeros(neqlin,nvar); %Sera la matriz de restricciones lineales de igualdad.

beq=zeros(neqlin,1);

%Condiciones de llegada y partida

beq(5*(n-1)+1,1) = x0;
beq(5*(n-1)+2,1) = y0;
beq(5*(n-1)+3,1) = xn;
beq(5*(n-1)+4,1) = yn;
beq(5*(n-1)+5,1) = 0.05; %dzdx=0.05

Aeq(5*(n-1)+1,1) = 1;
Aeq(5*(n-1)+2,n+2) = 1;
Aeq(5*(n-1)+3,(n+1)) = 1;
Aeq(5*(n-1)+4,2*(n+1)) = 1;
Aeq(5*(n-1)+5,3*(n+1)+1) = 1;


%restricciones lineales de igualdad

paraminicial_x=5*(n+1)+3*n+7*(n-1);
paraminicial_y=5*(n+1)+3*n+8*(n-1);
paraminicial_z=5*(n+1)+3*n+9*(n-1);

paraminicial_ax=5*(n+1)+3*n;
paraminicial_ay=5*(n+1)+3*n+(n-1);
%paraminicial_az=5*(n+1)+3*n+2*(n-1)

for i=1:n-1
    
    %v_x_avg
    
    Aeq(i,paraminicial_x+i)=-1;
    Aeq(i,5*(n+1)+i+1)=0.5;
    Aeq(i,5*(n+1)+i)=0.5;
    
    %v_y_avg
    
    Aeq((n-1)+i,paraminicial_y+i)=-1;
    Aeq((n-1)+i,5*(n+1)+n+i+1)=0.5;
    Aeq((n-1)+i,5*(n+1)+n+i)=0.5;
    
    %v_z_avg
    
    Aeq(2*(n-1)+i,paraminicial_z+i)=-1;
    Aeq(2*(n-1)+i,5*(n+1)+2*n+i+1)=0.5;
    Aeq(2*(n-1)+i,5*(n+1)+2*n+i)=0.5;
    
    
    %a_x
    
    Aeq(3*(n-1)+i,paraminicial_ax+i)=-1;
    Aeq(3*(n-1)+i,5*(n+1)+3*n+4*(n-1)+i)=1/m;
    Aeq(3*(n-1)+i,5*(n+1)+3*n+11*(n-1)+i)=1/m;
    
    
    %a_y
    
    Aeq(4*(n-1)+i,paraminicial_ay+i)=-1;
    Aeq(4*(n-1)+i,5*(n+1)+3*n+5*(n-1)+i)=1/m;
    Aeq(4*(n-1)+i,5*(n+1)+3*n+12*(n-1)+i)=1/m;
    
    %a_z
    
%     Aeq(5*(n-1)+i,paraminicial_az+i)=-1;
%     Aeq(5*(n-1)+i,5*(n+1)+3*n+3*(n-1)+i)=1/m;
%     Aeq(5*(n-1)+i,5*(n+1)+3*n+13*(n-1)+i)=1/m;
    
    %b_(a_z)
    
    %beq(5*(n-1)+i)=g;
    
    
end

%unica restric lineal ineq: (T positivo) 
Aineq=zeros(1,nvar);
Aineq(1,nvar)=-1;
bineq=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% restricciones no lineales en restnolinales.m

% variables iniciales en variablesini.m

varini=variables_iniciales_golf(mu,n,g,m,nvar,Tini,y0,yn,x0,xn);

options=optimset('Display','iter','OutputFcn',@outfun,'Algorithm',algoritmo);
options.MaxFunEvals = 1000000;
options.MaxIter = 1000000;

history.x = [];
history.fval = [];

 function stop = outfun(x,optimValues,state)
     stop = false;
 
     switch state
         case 'init'
             hold on
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.fval = [history.fval; optimValues.fval];
           history.x = [history.x; x];
         % Concatenate current search direction with 
         % searchdir.
           plot(x(1),x(2),'o');
         % Label points with iteration number and add title.
         % Add .15 to x(1) to separate label from plotted 'o'
           text(x(1)+.15,x(2),... 
                num2str(optimValues.iteration));
           title('Sequence of Points Computed by fmincon');
         case 'done'
             hold off
         otherwise
     end
 end

[X, fval, exitflag]=fmincon(@(variables)fobjetivo(variables,n),varini,Aineq,bineq,Aeq,beq,[],[],@(variables)restnolineales(variables,g,m,n,mu),options);

%variables espaciales:
Puntos=zeros(n+1,3);
Puntos(1:n+1,1)=X(1:n+1);
Puntos(1:n+1,2)=X(n+2:2*(n+1));
Puntos(1:n+1,3)=X(2*(n+1)+1:3*(n+1));

exitflag

if(grafico) 
    %grafico:
    x=-4:0.01:4;
    y=-4:0.01:4;
    [A,B]=meshgrid(x,y);
    z=zeros(size(A,1),size(A,2));
    for i=1:size(A,1)
        for j=1:size(A,2)
            z(i,j)=terreno(A(i,j),B(i,j));
        end
    end
    z(A.^2+ B.^2 > 16) = NaN;

    grafica_golf_sinterreno(Puntos(1:n+1,1),Puntos(1:n+1,2),Puntos(1:n+1,3),A,B,z,x0,y0,xn,yn,'b')
end
end



