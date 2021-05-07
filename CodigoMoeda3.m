clear all;
close all;
pkg load image;

################################################################
## PRÉ-PROCESSAMENTO
imagemMoeda = imread('/mnt/Archives/JoaoGabriel/Faculdade/PDI/ProjetoPDI/Marco3/Banco/18.jpg');
figure('Name', 'Imagem Original: Moedas');
imshow(imagemMoeda);

x=1;
for i=1:3:size(imagemMoeda,1)
    y=1;
    for j=1:3:size(imagemMoeda,2)
        imgMoedaReduzida(x,y,:) = imagemMoeda(i,j,:);
        y=y+1;
    end
    x=x+1;
end
##figure('Name','Imagem Reduzida');
##imshow(imgMoedaReduzida);


################################################################
## SEGMENTAÇÃO
imSegmentada = uint8(zeros(size(imgMoedaReduzida,1),size(imgMoedaReduzida,2),size(imgMoedaReduzida,3)));
objetoMetrica = uint8(zeros(size(imgMoedaReduzida,1),size(imgMoedaReduzida,2),size(imgMoedaReduzida,3)));

for i=1:size(imgMoedaReduzida,1)
  for j=1:size(imgMoedaReduzida,2)
      % REMOVENDO FUNDO AZUL
      if(imgMoedaReduzida(i,j,1) < 130 && imgMoedaReduzida(i,j,2) < 130 && imgMoedaReduzida(i,j,3) > 150 ||
        imgMoedaReduzida(i,j,1) < 50 && imgMoedaReduzida(i,j,2) < 50 && imgMoedaReduzida(i,j,3) > 100 ||
        imgMoedaReduzida(i,j,1) < 140 && imgMoedaReduzida(i,j,2) < 170 && imgMoedaReduzida(i,j,3) > 220)
          imSegmentada(i,j,:) = 0;
      %REMOVENTO OBJETO DE MÉTRICA E GUARDANDO NUMA MATRIZ
      elseif(imgMoedaReduzida(i,j,1) > 200 && imgMoedaReduzida(i,j,2) < 200 && imgMoedaReduzida(i,j,3) > 200 ||
            imgMoedaReduzida(i,j,1) > 200 && imgMoedaReduzida(i,j,2) < 150 && imgMoedaReduzida(i,j,3) > 180 )
        objetoMetrica(i,j,:) = imgMoedaReduzida(i,j,:);
        imSegmentada(i,j,:) = 0;
      else
        imSegmentada(i,j,:) = 255;
    end
  end
end
##figure('Name', 'Imagem Segmentada');
##imshow(imSegmentada);


##################################################################
#### EROSÃO PARA REMOVER O RUIDO DO OBJETO METRICA
objetoMetricaBW = im2bw(objetoMetrica);
##figure('Name', 'Objeto Metrica');
##imshow(objetoMetricaBW, [0 1]);

EE = [1 1 1; 1 1 1; 1 1 1]; 
metricaErode = objetoMetricaBW;
for i=2:size(objetoMetricaBW,1)-1
  for j=2:size(objetoMetricaBW,2)-1
    if(objetoMetricaBW(i,j)==1) 
      if !(objetoMetricaBW(i-1,j-1) == EE(1,1) && objetoMetricaBW(i-1,j) == EE(1,2) && objetoMetricaBW(i-1,j+1) == EE(1,3) && objetoMetricaBW(i,j-1) == EE(2,1) && objetoMetricaBW(i,j) == EE(2,2) && objetoMetricaBW(i,j+1) == EE(2,3) && objetoMetricaBW(i+1,j-1) == EE(3,1) && objetoMetricaBW(i+1,j) == EE(3,2) && objetoMetricaBW(i+1,j+1) == EE (3,3))
         metricaErode(i,j) = 0;
      end    
    end
  end
end

##figure('Name','Metrica - SEM RUÍDOS BRANCOS');
##imshow(metricaErode, [0 1]);


##################################################################
## DILATAÇÃO PARA REMOVER RUIDO PRETO DO OBJETO DE METRICA
EE = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1];
metricaDilate = metricaErode;
for i=3:size(objetoMetricaBW,1)-1
  for j=3:size(objetoMetricaBW,2)-1
    if(metricaErode(i,j)==EE(2,2)) 
      if(EE(1,1)==1) metricaDilate(i-2,j-2) = 1; end
      if(EE(1,2)==1) metricaDilate(i-2,j-1) = 1; end
      if(EE(1,3)==1) metricaDilate(i-2,j) = 1; end
      if(EE(1,4)==1) metricaDilate(i-2,j+1) = 1; end
      if(EE(1,5)==1) metricaDilate(i-2,j+2) = 1; end
      if(EE(2,1)==1) metricaDilate(i-1,j-2) = 1; end
      if(EE(2,2)==1) metricaDilate(i-1,j-1) = 1; end
      if(EE(2,3)==1) metricaDilate(i-1,j) = 1; end
      if(EE(2,4)==1) metricaDilate(i-1,j+1) = 1; end
      if(EE(2,5)==1) metricaDilate(i-1,j+2) = 1; end
      if(EE(3,1)==1) metricaDilate(i,j-2) = 1; end
      if(EE(3,2)==1) metricaDilate(i,j-1) = 1; end
      if(EE(3,3)==1) metricaDilate(i,j) = 1; end
      if(EE(3,4)==1) metricaDilate(i,j+1) = 1; end
      if(EE(3,5)==1) metricaDilate(i,j+2) = 1; end
      if(EE(4,1)==1) metricaDilate(i+1,j-2) = 1; end
      if(EE(4,2)==1) metricaDilate(i+1,j-1) = 1; end
      if(EE(4,4)==1) metricaDilate(i+1,j+1) = 1; end
      if(EE(4,5)==1) metricaDilate(i+1,j+2) = 1; end
      if(EE(5,1)==1) metricaDilate(i+2,j-2) = 1; end
      if(EE(5,2)==1) metricaDilate(i+2,j-1) = 1; end
      if(EE(5,3)==1) metricaDilate(i+2,j) = 1; end
      if(EE(5,4)==1) metricaDilate(i+2,j+1) = 1; end
      if(EE(5,5)==1) metricaDilate(i+2,j+2) = 1; end
    end
  end
end

##figure('Name','Metrica Dilatada - SEM RUÍDOS PRETOS');
##imshow(metricaDilate, [0 1]);


##################################################################
#### EROSÃO PARA REMOVER O RUIDO BRANCO DAS MOEDAS
MoedaBW = im2bw(imSegmentada);
##figure('Name', 'Imagem Binaria');
##imshow(MoedaBW, [0 1]);

EE = [1 1 1; 1 1 1; 1 1 1]; 
imErode2 = MoedaBW;
for i=2:size(MoedaBW,1)-1
  for j=2:size(MoedaBW,2)-1
    if(MoedaBW(i,j)==1) 
      if !(MoedaBW(i-1,j-1) == EE(1,1) && MoedaBW(i-1,j) == EE(1,2) && MoedaBW(i-1,j+1) == EE(1,3) && MoedaBW(i,j-1) == EE(2,1) && MoedaBW(i,j) == EE(2,2) && MoedaBW(i,j+1) == EE(2,3) && MoedaBW(i+1,j-1) == EE(3,1) && MoedaBW(i+1,j) == EE(3,2) && MoedaBW(i+1,j+1) == EE (3,3))
         imErode2(i,j) = 0;
      end    
    end
  end
end

##figure('Name','Imagem Erodida Geometrico - SEM RUÍDOS BRANCOS');
##imshow(imErode2, [0 1]);


##################################################################
#### DILATAÇÃO PARA REMOVER RUIDOS PRETOS DA MOEDA
EE = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1];
imDilate = imErode2;
for i=3:size(MoedaBW,1)-1
  for j=3:size(MoedaBW,2)-1
    if(imErode2(i,j)==EE(2,2)) 
      if(EE(1,1)==1) imDilate(i-2,j-2) = 1; end
      if(EE(1,2)==1) imDilate(i-2,j-1) = 1; end
      if(EE(1,3)==1) imDilate(i-2,j) = 1; end
      if(EE(1,4)==1) imDilate(i-2,j+1) = 1; end
      if(EE(1,5)==1) imDilate(i-2,j+2) = 1; end
      if(EE(2,1)==1) imDilate(i-1,j-2) = 1; end
      if(EE(2,2)==1) imDilate(i-1,j-1) = 1; end
      if(EE(2,3)==1) imDilate(i-1,j) = 1; end
      if(EE(2,4)==1) imDilate(i-1,j+1) = 1; end
      if(EE(2,5)==1) imDilate(i-1,j+2) = 1; end
      if(EE(3,1)==1) imDilate(i,j-2) = 1; end
      if(EE(3,2)==1) imDilate(i,j-1) = 1; end
      if(EE(3,3)==1) imDilate(i,j) = 1; end
      if(EE(3,4)==1) imDilate(i,j+1) = 1; end
      if(EE(3,5)==1) imDilate(i,j+2) = 1; end
      if(EE(4,1)==1) imDilate(i+1,j-2) = 1; end
      if(EE(4,2)==1) imDilate(i+1,j-1) = 1; end
      if(EE(4,4)==1) imDilate(i+1,j+1) = 1; end
      if(EE(4,5)==1) imDilate(i+1,j+2) = 1; end
      if(EE(5,1)==1) imDilate(i+2,j-2) = 1; end
      if(EE(5,2)==1) imDilate(i+2,j-1) = 1; end
      if(EE(5,3)==1) imDilate(i+2,j) = 1; end
      if(EE(5,4)==1) imDilate(i+2,j+1) = 1; end
      if(EE(5,5)==1) imDilate(i+2,j+2) = 1; end
    end
  end
end
##figure('Name','Imagem Dilatada Geometrico - SEM RUÍDOS PRETOS');
##imshow(imDilate, [0 1]);


##################################################################
## DESCRIÇÃO E RECONHECIMENTO
regiaoMetrica = regionprops(metricaDilate, 'Image', 'Area', 'MajorAxisLength');
alturaMetrica = size(regiaoMetrica.Image,2);
regioes = regionprops(imDilate, 'Image', 'Area', 'MajorAxisLength', 'Eccentricity');
quantidadeObjetos = size(regioes,1);

mediaMoedas = 0;
for i=1:quantidadeObjetos
  mediaMoedas = regioes(i).Area + mediaMoedas;
end
mediaMoedas = mediaMoedas / quantidadeObjetos;

cont=1;
for i=1:size(regioes,1)
  if(regioes(i).Area > mediaMoedas / 2 && regioes(i).Eccentricity < 0.4)
     regioesMoedas(cont) = regioes(i);
     cont = cont + 1;
  endif
endfor

moedaCinco = 0;
moedaDez = 0;
moedaVinteCinco = 0;
moedaCinquenta = 0;
moedaUmReal = 0;

for i=1:size(regioesMoedas,2)
   pixelsDiametroMoeda = size(regioesMoedas(i).Image,2);
   diametroMoeda = pixelsDiametroMoeda * 10 / alturaMetrica;
   vetorDiametros(i) = diametroMoeda;

   if (diametroMoeda > 21 && diametroMoeda < 22.5)
     moedaCinco = moedaCinco + 1;
   elseif (diametroMoeda > 18.5 && diametroMoeda < 21 )
     moedaDez = moedaDez + 1;
   elseif (diametroMoeda > 24 && diametroMoeda < 26)
     moedaVinteCinco = moedaVinteCinco + 1;
   elseif (diametroMoeda > 22.5 && diametroMoeda < 24)
     moedaCinquenta = moedaCinquenta + 1;
   elseif (diametroMoeda > 26)
     moedaUmReal = moedaUmReal + 1;
   endif
end

quantidadeMoedas = moedaCinco + moedaDez + moedaVinteCinco + moedaCinquenta + moedaUmReal;
valorTotal = moedaCinco * 0.05 + moedaDez * 0.10 + moedaVinteCinco * 0.25 + moedaCinquenta * 0.50 + moedaUmReal * 1.0;

disp("---------- RESULTADOS: ----------");
disp("                                 ");
disp(strcat("QUANTIDADE DE MOEDAS: ", num2str(quantidadeMoedas)));
disp("                                 ");
disp("----------CLASSIFICAÇÃO: ----------");
disp(strcat("Moedas de R$ 0,05 centavos:", num2str(moedaCinco)));
disp(strcat("Moedas de R$ 0,10 centavos:", num2str(moedaDez)));
disp(strcat("Moedas de R$ 0,25 centavos:", num2str(moedaVinteCinco)));
disp(strcat("Moedas de R$ 0,50 centavos:", num2str(moedaCinquenta)));
disp(strcat("Moedas de R$ 1,00 real:", num2str(moedaUmReal)));
disp("                                 ");
disp(strcat("Valor total em R$:", num2str(valorTotal, "%5.2f")));
disp("                                 ");



labelQntdMoedas = strcat("Quantidade de moedas: ", num2str(quantidadeMoedas));
labelValorTotal = strcat("Valor total: R$", num2str(valorTotal));

figure("Name", "Resultado Final"), imshow(imagemMoeda);
title({labelQntdMoedas; labelValorTotal;}, "fontsize", 20)

moeda05centavos = strcat({' '}, "R$0,05: ",{' '}, num2str(moedaCinco));
text(200,100, moeda05centavos, "fontsize", 18, "color", "white");
moeda10centavos = strcat({' '}, "R$0,10: ",{' '}, num2str(moedaDez));
text(700,100, moeda10centavos, "fontsize", 18, "color", "white");
moeda25centavos = strcat({' '}, "R$0,25: ",{' '}, num2str(moedaVinteCinco));
text(1200,100, moeda25centavos, "fontsize", 18, "color", "white");
moeda50centavos = strcat({' '}, "R$0,50: ",{' '}, num2str(moedaCinquenta));
text(1700,100, moeda50centavos, "fontsize", 18, "color", "white");
moeda1real = strcat({' '}, "R$1,00: ",{' '}, num2str(moedaUmReal));
text(2200,100, moeda1real, "fontsize", 18, "color", "white");