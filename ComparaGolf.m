function [Comparacion, o1, o2, o3] = ComparaGolf(x0,y0,xn,yn,n,Tini) 
% llamada: ComparaGolf(1,2,1,-2,50,2)

%Funcion que compara los resultados obtenidos con los distintos algoritmos
%de la funcion fmincon de matlab

%algoritmo = ['interior-point', sqp, active-set]; %El otro algoritmo no se puede utilizar por el tipo de restricciones

Comparacion = ones(3,4); %En la matriz comparativo, guardaremos en la fila i, el fval, la exitflag y el tiempo que demore cada algoritmo

tic
[X1, f1, e1, h1] = GOLFMINCON(x0,y0,xn,yn,n,Tini,'interior-point',false);
t1=toc;

Comparacion(1,1) = f1;
Comparacion(1,2) = e1;
Comparacion(1,3) = t1;
Comparacion(1,4) = X1(length(X1));

tic
[X2, f2, e2, h2] = GOLFMINCON(x0,y0,xn,yn,n,Tini,'sqp',false);
t2=toc;

Comparacion(2,1) = f2;
Comparacion(2,2) = e2;
Comparacion(2,3) = t2;
Comparacion(2,4) = X2(length(X2));

tic
[X3, f3, e3, h3] = GOLFMINCON(x0,y0,xn,yn,n,Tini,'active-set',false);
t3=toc;

Comparacion(3,1) = f3;
Comparacion(3,2) = e3;
Comparacion(3,3) = t3;
Comparacion(3,4) = X3(length(X3));


%terreno para el grafico

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
 
Puntos1=zeros(n+1,3);
Puntos1(1:n+1,1)=X1(1:n+1);
Puntos1(1:n+1,2)=X1(n+2:2*(n+1));
Puntos1(1:n+1,3)=X1(2*(n+1)+1:3*(n+1));

figure(1); clf;
set(0,'defaultLineLineWidth',0.5);   % set the default line width to lw
set(0,'defaultLineMarkerSize',8); % set the default line marker size to msz


[p1]=grafica_golf_sinterreno(Puntos1(1:n+1,1),Puntos1(1:n+1,2),Puntos1(1:n+1,3),A,B,z,x0,y0,xn,yn,'b');
hold on

Puntos2=zeros(n+1,3);
Puntos2(1:n+1,1)=X2(1:n+1);
Puntos2(1:n+1,2)=X2(n+2:2*(n+1));
Puntos2(1:n+1,3)=X2(2*(n+1)+1:3*(n+1));

[p2]=grafica_golf_sinterreno(Puntos2(1:n+1,1),Puntos2(1:n+1,2),Puntos2(1:n+1,3),A,B,z,x0,y0,xn,yn,'r');

Puntos3=zeros(n+1,3);
Puntos3(1:n+1,1)=X3(1:n+1);
Puntos3(1:n+1,2)=X3(n+2:2*(n+1));
Puntos3(1:n+1,3)=X3(2*(n+1)+1:3*(n+1));


hold on

[p3]=grafica_golf_sinterreno(Puntos3(1:n+1,1),Puntos3(1:n+1,2),Puntos3(1:n+1,3),A,B,z,x0,y0,xn,yn,'m');

legend([p1 p2 p3],'interior-point','sqp', 'active-set','Location', 'SouthEast');

print('comparaciongolf','-dpng','-r300');

figure(1); clf;
set(0,'defaultLineLineWidth',0.5);   % set the default line width to lw
set(0,'defaultLineMarkerSize',8); % set the default line marker size to msz


hold off
plot(h1.fval,'bo')
print('fobjetivo_A_golf','-dpng','-r300');

hold off
plot(h2.fval,'bo')
print('fobjetivo_B_golf','-dpng','-r300');

hold off
plot(h3.fval,'bo')
print('fobjetivo_C_golf','-dpng','-r300');

end