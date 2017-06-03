function grafica_golf(X,Y,Z)

x=-4:0.01:4;
y=-4:0.01:4;
[A,B]=meshgrid(x,y);
z=zeros(size(A,1),size(A,2));
for i=1:size(A,1)
    for j=1:size(A,2)
        z(i,j)=terreno(A(i,j),B(i,j));
    end
end

surf(A,B,z)
colormap([0, 1, 0.5])
shading interp
hold on
scatter3(X,Y,Z)
end

