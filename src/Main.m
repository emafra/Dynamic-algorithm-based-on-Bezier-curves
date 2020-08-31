video = videoinput('winvideo',2);
flag=0;
for i=1:10
    foto = getsnapshot(video); %Captura a imagem do v�deo.
    imshow(foto); % Mostra a imagem capturada.
    im_gray = rgb2gray(foto);
    %imshow(im_gray);    
    im_bw = im2bw(im_gray);
    %imshow(im_bw);
    im_bin = not(im_bw);
    %imshow(im_bin);
    im_label = bwlabel(im_bin,8);
    %imtool(im_label);
    N = max(max(im_label)); % Numero de objetos detectados. 
    prop = regionprops(im_label,'all'); % Fun��o para obter as propriedades
    % de cada objeto.
     hold on
    % Lista de objetos:
    quadrado=[];
    circulos=[];
    strars=[];
    % �ndices das Listas:
    q=0;
    q1=0;
    q2=0;
    % La�o para percorrer todos os objetos:
for i = 1:N
    [a,b] = size(prop(i).PixelList) % Captura atrav�s da vari�vel "a" o 
    % Numero de pixels de cada objeto
    if a>300 && a<3000 % Condi��o para eliminar ru�dos.
        % Condi��o para detectar quadrados:
        if prop(i).BoundingBox(:,3)*prop(i).BoundingBox(:,4) <= prop(i).Area*1.2 && ...
            prop(i).BoundingBox(:,3)*prop(i).BoundingBox(:,4) >= prop(i).Area*0.8
        % Mostra o Objeto detectado na imagem:
        plot(prop(i).Centroid(:,1),prop(i).Centroid(:,2),'b*');
        q=q+1; % Relaciona o objeto encontrado a um �ndice.
        quadrado(q)=i % Acrescenta o objeto em uma lista.
    % Condi��o para detectar C�rculos:        
        elseif prop(i).Perimeter <= (pi*(prop(i).EquivDiameter))*1.03 && prop(i).Area >= ...
            pi*(prop(i).EquivDiameter)*0.97 &&  prop(i).Area < ...
            prop(i).BoundingBox(:,3)*prop(i).BoundingBox(:,4)
            q1=q1+1; % Relaciona o objeto encontrado a um �ndice.
            % Mostra o objeto na imagem
            plot(prop(i).Centroid(:,1),prop(i).Centroid(:,2),'g*');
            circulos(q1)=i; % Acrescenta o objeto em uma lista.

        elseif   ((prop(i).EquivDiameter/2)^2)*pi ~ prop(i).Area 
            q2=q2+1; % Relaciona o objeto encontrado a um �ndice.
            plot(prop(i).Centroid(:,1),prop(i).Centroid(:,2),'r*');
            stars(q2)=i; % Acrescenta o objeto em uma lista.
        end  
    end
end

%  Define as vari�ves "q" e "q1" como tamanho da lista de objetos para as 
% classes quadrado e c�rculos:
[c,q] = size (quadrado);
[c,q1] = size (circulos);

if stars(1)>0 % Se houver a destec��o de estrela (precau��o para poss�veis
% erros).
%quadrados:
for k = 1:q-1
        
        %  Calculo do ponto central dos objetos interligados:
        xcentral=(prop(quadrado(k)).Centroid(:,1)+prop(quadrado(k+1)).Centroid(:,1))/2
        ycentral=(prop(quadrado(k)).Centroid(:,2)+prop(quadrado(k+1)).Centroid(:,2))/2
        
        %  Dist�ncia entre o ponto central dos pontos inteligados e o
        % centroid da estrela:
        distx = xcentral-prop(stars(1)).Centroid(:,1)
        disty = ycentral-prop(stars(1)).Centroid(:,2)
        
        
        % Ponto central de Bezier:
        
        % Se o objeto estiver na vertical:
        if prop(quadrado(k)).Centroid(:,1) <= ...
           prop(quadrado(k+1)).Centroid(:,1)*1.2 && ...
           prop(quadrado(k)).Centroid(:,1) >= ...
           prop(quadrado(k+1)).Centroid(:,1)*0.8
        x2 = xcentral + (500/(distx)) % Pontos centrais de bezier
        y2 = ycentral + (1/(disty))
        % Se estiver na horizontal ou diagonal:
        else prop(quadrado(k)).Centroid(:,2) <= ...
            prop(quadrado(k+1)).Centroid(:,2)*1.2 && ...
            prop(quadrado(k)).Centroid(:,2) >= ...
            prop(quadrado(k+1)).Centroid(:,2)*0.8
        x2 = xcentral + (1/(distx)) % Pontos centrais de bezier
        y2 = ycentral + (500/(disty))
        end
        
        % Chama a fun��o de Bezier
        bezier(prop(quadrado(k)).Centroid(:,1),...
        prop(quadrado(k)).Centroid(:,2),x2,y2,...
        prop(quadrado(k+1)).Centroid(:,1),prop(quadrado(k+1)).Centroid(:,2));
end

% Circulos(Mesmo processo aplicado para a classe dos quadrados):
for k = 1:q1-1
        xcentral=(prop(circulos(k)).Centroid(:,1)+prop(circulos(k+1)).Centroid(:,1))/2
        ycentral=(prop(circulos(k)).Centroid(:,2)+prop(circulos(k+1)).Centroid(:,2))/2
        
        distx = xcentral-prop(stars(1)).Centroid(:,1)
        disty = ycentral-prop(stars(1)).Centroid(:,2)
        
        x2 = xcentral + (1/(distx)) %arrumar esse x2 e y2
        y2 = ycentral + (500/(disty))
        
        bezier(prop(circulos(k)).Centroid(:,1),...
        prop(circulos(k)).Centroid(:,2),x2,y2,...
        prop(circulos(k+1)).Centroid(:,1),prop(circulos(k+1)).Centroid(:,2));
end
end
end

