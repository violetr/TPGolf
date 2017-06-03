%Defino solucion inicial factible
function [varini]= variables_iniciales_golf(mu,n,g,m,nvar,Tini,y0,yn,x0,xn)

varini=ones(nvar,1);


%posicion
for i=1:n+1
    %y
    varini((n+1)+i)=(i-1)/n*yn + (1-(i-1)/n)*y0;
    %x
    %varini(i)=(i-1)/n*xn + (1-(i-1)/n)*x0
    varini(i)=(varini((n+1)+i))^2/4;
    %z
    varini(2*(n+1)+i)=terreno(varini(i),varini(n+1+i));
end

varini(nvar)=Tini; %tiempo

varini(3*(n+1)+1:4*(n+1))=0.05; %dzdx

varini(4*(n+1)+1:5*(n+1))=-0.3./(1+varini(n+1+1:2*(n+1)).^2)-0.05; %dzdy

varini(5*(n+1)+1:5*(n+1)+n)=(varini(2:n+1)-varini(1:n))./varini(nvar)*n; %v_x

%Velocidad_y

varini(5*(n+1)+n+1:5*(n+1)+2*n)=(varini(n+3:2*(n+1))-varini(n+1+1:2*(n+1)-1))./varini(nvar)*n;

%Velocidad_z
varini(5*(n+1)+2*n+1:5*(n+1)+3*n)=(varini(2*(n+1)+2:3*(n+1))-varini(2*(n+1)+1:3*(n+1)-1))./varini(nvar)*n;

%Aceleracion_x
varini(5*(n+1)+3*n+1:5*(n+1)+3*n+n-1)=(varini(5*(n+1)+2:5*(n+1)+n)-varini(5*(n+1)+1:5*(n+1)+n-1))./varini(nvar)*n;

%Aceleracion_y
varini(5*(n+1)+3*n+n-1+1:5*(n+1)+3*n+2*(n-1))=(varini(5*(n+1)+n+2:5*(n+1)+2*n)-varini(5*(n+1)+n+1:5*(n+1)+2*n-1))./varini(nvar)*n;

%Aceleracion_z
varini(5*(n+1)+3*n+2*(n-1)+1:5*(n+1)+3*n+3*(n-1))=(varini(5*(n+1)+2*n+2:5*(n+1)+3*n)-varini(5*(n+1)+2*n+1:5*(n+1)+3*n-1))./varini(nvar)*n;

%Normal en z
varini(5*(n+1)+3*n+3*(n-1)+1:5*(n+1)+3*n+4*(n-1))=m*(g-varini(5*(n+1)+3*n+1:5*(n+1)+3*n+n-1).*varini(3*(n+1)+2:3*(n+1)+n)-varini(5*(n+1)+3*n+n-1+1:5*(n+1)+3*n+2*(n-1)).*varini(4*(n+1)+2:4*(n+1)+n)+varini(5*(n+1)+3*n+2*(n-1)+1:5*(n+1)+3*n+3*(n-1)))./(varini(3*(n+1)+2:3*(n+1)+n).^2+varini(4*(n+1)+2:4*(n+1)+n).^2+1);

%Normal en x
varini(5*(n+1)+3*n+4*(n-1)+1:5*(n+1)+3*n+5*(n-1))=-varini(3*(n+1)+2:3*(n+1)+n).*varini(5*(n+1)+3*n+3*(n-1)+1:5*(n+1)+3*n+4*(n-1));

%Normal en y
varini(5*(n+1)+3*n+5*(n-1)+1:5*(n+1)+3*n+6*(n-1))=-varini(4*(n+1)+2:4*(n+1)+n).*varini(5*(n+1)+3*n+3*(n-1)+1:5*(n+1)+3*n+4*(n-1));

%Nmag
varini(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1))=m*(g-varini(5*(n+1)+3*n+1:5*(n+1)+3*n+n-1).*varini(3*(n+1)+2:3*(n+1)+n)-varini(5*(n+1)+3*n+n-1+1:5*(n+1)+3*n+2*(n-1)).*varini(4*(n+1)+2:4*(n+1)+n)+varini(5*(n+1)+3*n+2*(n-1)+1:5*(n+1)+3*n+3*(n-1)))./sqrt(varini(3*(n+1)+2:3*(n+1)+n).^2+varini(4*(n+1)+2:4*(n+1)+n).^2+1);

%vxavg

varini(5*(n+1)+3*n+7*(n-1)+1:5*(n+1)+3*n+8*(n-1))=(varini(5*(n+1)+2:5*(n+1)+n)+varini(5*(n+1)+1:5*(n+1)+n-1))/2;

varini(5*(n+1)+3*n+8*(n-1)+1:5*(n+1)+3*n+9*(n-1))=(varini(5*(n+1)+n+2:5*(n+1)+2*n)+varini(5*(n+1)+n+1:5*(n+1)+2*n-1))/2;

varini(5*(n+1)+3*n+9*(n-1)+1:5*(n+1)+3*n+10*(n-1))=(varini(5*(n+1)+2*n+2:5*(n+1)+3*n)+varini(5*(n+1)+2*n+1:5*(n+1)+3*n-1))/2;

%speed
varini(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1))=sqrt(varini(5*(n+1)+3*n+7*(n-1)+1:5*(n+1)+3*n+8*(n-1)).^2+varini(5*(n+1)+3*n+8*(n-1)+1:5*(n+1)+3*n+9*(n-1)).^2+varini(5*(n+1)+3*n+9*(n-1)+1:5*(n+1)+3*n+10*(n-1)).^2);

%Friccion en X
varini(5*(n+1)+3*n+11*(n-1)+1:5*(n+1)+3*n+12*(n-1))=-mu*varini(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1)).*varini(5*(n+1)+3*n+7*(n-1)+1:5*(n+1)+3*n+8*(n-1))./varini(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1));

%Friccion en Y
varini(5*(n+1)+3*n+12*(n-1)+1:5*(n+1)+3*n+13*(n-1))=-mu*varini(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1)).*varini(5*(n+1)+3*n+8*(n-1)+1:5*(n+1)+3*n+9*(n-1))./varini(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1));

%Friccion en Z
varini(5*(n+1)+3*n+13*(n-1)+1:5*(n+1)+3*n+14*(n-1))=-mu*varini(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1)).*varini(5*(n+1)+3*n+9*(n-1)+1:5*(n+1)+3*n+10*(n-1))./varini(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1));

end
