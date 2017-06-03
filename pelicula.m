% genera la pelicula de la pelotita

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



xx=Puntos(1:n+1,1)
yy=Puntos(1:n+1,2)
zz=Puntos(1:n+1,3)

for i=1:n+1
%     size(x)
%     size(y)
%     size(u(:,:,i))
%     sol=mesh(x,y,u(:,:,i))
%     axis([0,1,0,1,min(min(min(u))),max(max(max(u)))])
    grafica_golf_sinterreno(xx(i),yy(i),zz(i),A,B,z,'b')
    i
    MO(i)=getframe;
end

%axis([-4,4,-4,4,min(zz),max(zz)])
movie(MO)
movie2avi(MO,'MovieGolf3.avi')
