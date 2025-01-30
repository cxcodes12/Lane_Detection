function [x1,y1,x2,y2] = myHoughLines(im, rho, theta)
[M,N] = size(im);
%calcul coordonate pentru linia detectata
%ecuatia: rho = xcos(theta)+ysin(theta)
if theta==0 %linie verticala
    x1 = rho;
    y1 = 1;
    x2 = rho;
    y2 = M;
elseif theta==-90 || theta==90 %linie orizontala
    x1 = 1;
    y1 = rho;
    x2 = N;
    y2 = rho;
else
    x1 = 1;
    y1 = (rho-x1*cosd(theta))/sind(theta);
    x2 = N;
    y2 = (rho-x2*cosd(theta))/sind(theta);
end
end