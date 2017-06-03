function [c,ceq]=restnolineales(variables,g,m,n,mu)

nvar=5*(n+1)+3*n+14*(n-1)+1;

%podria hacer un mapeo de este estilo

%  On the green
c(1:n+1) = variables(1:(n+1)).^2 + variables((n+1)+1:2*(n+1)).^2 - 16; 

% en altura de terreno:
ceq(1:n+1)=variables(2*(n+1)+1:3*(n+1))-terreno(variables(1:n+1),variables(n+1+1:2*(n+1)));

% dzdy:
ceq(n+1+1:2*(n+1))=variables(4*(n+1)+1:5*(n+1))+0.3./(1+variables(n+1+1:2*(n+1)).^2)-0.05;


%Velocidad_x

ceq(2*(n+1)+1:2*(n+1)+n)=variables(5*(n+1)+1:5*(n+1)+n)-(variables(2:n+1)-variables(1:n))./variables(nvar)*n;

%Velocidad_y

ceq(2*(n+1)+n+1:2*(n+1)+n+n)=variables(5*(n+1)+n+1:5*(n+1)+2*n)-(variables(n+3:2*(n+1))-variables(n+1+1:2*(n+1)-1))./variables(nvar)*n;

%Velocidad_z

ceq(2*(n+1)+2*n+1:2*(n+1)+2*n+n)=variables(5*(n+1)+2*n+1:5*(n+1)+3*n)-(variables(2*(n+1)+2:3*(n+1))-variables(2*(n+1)+1:3*(n+1)-1))./variables(nvar)*n;



%Aceleracion_x

ceq(2*(n+1)+3*n+1:2*(n+1)+3*n+n-1)=variables(5*(n+1)+3*n+1:5*(n+1)+3*n+n-1)-(variables(5*(n+1)+2:5*(n+1)+n)-variables(5*(n+1)+1:5*(n+1)+n-1))./variables(nvar)*n;

%Aceleracion_y

ceq(2*(n+1)+3*n+n-1+1:2*(n+1)+3*n+2*(n-1))=variables(5*(n+1)+3*n+n-1+1:5*(n+1)+3*n+2*(n-1))-(variables(5*(n+1)+n+2:5*(n+1)+2*n)-variables(5*(n+1)+n+1:5*(n+1)+2*n-1))./variables(nvar)*n;

%Aceleracion_z

ceq(2*(n+1)+3*n+2*(n-1)+1:2*(n+1)+3*n+3*(n-1))=variables(5*(n+1)+3*n+2*(n-1)+1:5*(n+1)+3*n+3*(n-1))-(variables(5*(n+1)+2*n+2:5*(n+1)+3*n)-variables(5*(n+1)+2*n+1:5*(n+1)+3*n-1))./variables(nvar)*n;


%Normal en z
ceq(2*(n+1)+3*n+3*(n-1)+1:2*(n+1)+3*n+4*(n-1))=variables(5*(n+1)+3*n+3*(n-1)+1:5*(n+1)+3*n+4*(n-1))-m*(g-variables(5*(n+1)+3*n+1:5*(n+1)+3*n+n-1).*variables(3*(n+1)+2:3*(n+1)+n)-variables(5*(n+1)+3*n+n-1+1:5*(n+1)+3*n+2*(n-1)).*variables(4*(n+1)+2:4*(n+1)+n)+variables(5*(n+1)+3*n+2*(n-1)+1:5*(n+1)+3*n+3*(n-1)))./(variables(3*(n+1)+2:3*(n+1)+n).^2+variables(4*(n+1)+2:4*(n+1)+n).^2+1);



%Normal en x
ceq(2*(n+1)+3*n+4*(n-1)+1:2*(n+1)+3*n+5*(n-1))=variables(5*(n+1)+3*n+4*(n-1)+1:5*(n+1)+3*n+5*(n-1))+variables(3*(n+1)+2:3*(n+1)+n).*variables(5*(n+1)+3*n+3*(n-1)+1:5*(n+1)+3*n+4*(n-1));

%Normal en y
ceq(2*(n+1)+3*n+5*(n-1)+1:2*(n+1)+3*n+6*(n-1))=variables(5*(n+1)+3*n+5*(n-1)+1:5*(n+1)+3*n+6*(n-1))+variables(4*(n+1)+2:4*(n+1)+n).*variables(5*(n+1)+3*n+3*(n-1)+1:5*(n+1)+3*n+4*(n-1));

%Nmag
ceq(2*(n+1)+3*n+6*(n-1)+1:2*(n+1)+3*n+7*(n-1))=variables(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1))-m*(g-variables(5*(n+1)+3*n+1:5*(n+1)+3*n+n-1).*variables(3*(n+1)+2:3*(n+1)+n)-variables(5*(n+1)+3*n+n-1+1:5*(n+1)+3*n+2*(n-1)).*variables(4*(n+1)+2:4*(n+1)+n)+variables(5*(n+1)+3*n+2*(n-1)+1:5*(n+1)+3*n+3*(n-1)))./sqrt(variables(3*(n+1)+2:3*(n+1)+n).^2+variables(4*(n+1)+2:4*(n+1)+n).^2+1);

%speed
ceq(2*(n+1)+3*n+7*(n-1)+1:2*(n+1)+3*n+8*(n-1))=variables(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1))-sqrt(variables(5*(n+1)+3*n+7*(n-1)+1:5*(n+1)+3*n+8*(n-1)).^2+variables(5*(n+1)+3*n+8*(n-1)+1:5*(n+1)+3*n+9*(n-1)).^2+variables(5*(n+1)+3*n+9*(n-1)+1:5*(n+1)+3*n+10*(n-1)).^2);

%Friccion en X
ceq(2*(n+1)+3*n+8*(n-1)+1:2*(n+1)+3*n+9*(n-1))=variables(5*(n+1)+3*n+11*(n-1)+1:5*(n+1)+3*n+12*(n-1))+mu*variables(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1)).*variables(5*(n+1)+3*n+7*(n-1)+1:5*(n+1)+3*n+8*(n-1))./variables(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1));


%Friccion en Y
ceq(2*(n+1)+3*n+9*(n-1)+1:2*(n+1)+3*n+10*(n-1))=variables(5*(n+1)+3*n+12*(n-1)+1:5*(n+1)+3*n+13*(n-1))+mu*variables(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1)).*variables(5*(n+1)+3*n+8*(n-1)+1:5*(n+1)+3*n+9*(n-1))./variables(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1));

%Friccion en Z
ceq(2*(n+1)+3*n+10*(n-1)+1:2*(n+1)+3*n+11*(n-1))=variables(5*(n+1)+3*n+13*(n-1)+1:5*(n+1)+3*n+14*(n-1))+mu*variables(5*(n+1)+3*n+6*(n-1)+1:5*(n+1)+3*n+7*(n-1)).*variables(5*(n+1)+3*n+9*(n-1)+1:5*(n+1)+3*n+10*(n-1))./variables(5*(n+1)+3*n+10*(n-1)+1:5*(n+1)+3*n+11*(n-1));

% "CHEQUEADO" HASTA ACA

end