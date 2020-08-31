function a=bezier(x1,y1,x2,y2,x3,y3)
plot(x1,y1,'s')
hold on
plot(x2,y2,'s')
hold on
plot(x3,y3,'s')
hold on
i=0;
for t=0:0.05:1
    i=i+1;
% Vetores de posição (e aplicação da fórmula de Bézier):
    x(i)=(((t)^2)*x1)+(2*t*(1-t)*x2)+((1-t)^2*x3);
    y(i)=(((t)^2)*y1)+(2*t*(1-t)*y2)+((1-t)^2*y3);
end
% Plot da linhas de Bézier:
plot (x,y,'Color','black')
