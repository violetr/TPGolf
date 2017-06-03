function [p]=grafica_golf_sinterreno(X,Y,Z,xterreno,yterreno,zterreno,x0,y0,xn,yn,colorpelota)

% esta funcion grafica puntos de la pelota sin graficar el terreno

surf(xterreno,yterreno,zterreno,'FaceColor',[0, 1, 0.5],'FaceAlpha',0.5,'EdgeColor','none')

hold on

scatter3(x0,y0,terreno(x0,y0),'r','filled','SizeData',70)

scatter3(xn,yn,terreno(xn,yn),'k','filled','SizeData',80)
%scatter3(1,-2,terreno(1,-2)+1/2,'k','filled','SizeData',90)
%scatter3(1,-2,terreno(1,-2)+3/4,'k','filled','SizeData',90)
%scatter3(1,-2,terreno(1,-2)+1,'k','filled','SizeData',90)

hold on
line([xn xn],[yn yn],[terreno(xn,yn) terreno(xn,yn)+1/8],'Color','k','LineWidth',1.5)
% plot3(1,-2,terreno(1,-2),'k')
% hold on
% plot3(1,-2,terreno(1,-2)+5/4,'k')

hold on
p=scatter3(X,Y,Z,'filled',colorpelota)
view([-100 -6])
axis off
hold off
end
