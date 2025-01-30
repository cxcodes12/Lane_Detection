function [im_contur] = myCanny(im)
%aplicare filtru gaussian
x = -3.5:0.5:3.5;
y = -3.5:0.5:3.5;
k1 = length(x); %15
k2 = length(y); %15
G = zeros(k1,k2);
msigma = 1; %abaterea medie, la patrat devine dispersie, cu cat dispersia e mai mare, cu atat banda e mai ingusta

for i=1:k1
    for j=1:k2
        G(i,j) = 1/(2*pi*msigma^2)*exp(-(x(i)^2+y(j)^2)/(2*msigma^2));
    end
end
G = G/sum(G(:));  %normare
%aplicare masca prin convolutie
[M,N] = size(im);
im_filtr = zeros(M,N);
for i=ceil(k1/2):M-floor(k1/2)
    for j=ceil(k2/2):N-floor(k2/2)
        im_filtr(i,j) = sum(sum(double(im(i-floor(k1/2):i+floor(k1/2),j-floor(k2/2):j+floor(k2/2))).*G));
    end
end
im_filtr = im_filtr(ceil(k1/2):M-floor(k1/2),ceil(k2/2):N-floor(k2/2));

% calcul gradienti sobel
[M,N] = size(im_filtr);
Gx = [-1,0,1;-2,0,2;-1,0,1];
Gy = [1,2,1;0,0,0;-1,-2,-1];
gradient_X = zeros(size(im_filtr));
gradient_Y = zeros(size(im_filtr));
for i=2:M-1
    for j=2:N-1
        patch = im_filtr(i-1:i+1,j-1:j+1);
        gradient_X(i,j) = sum(sum(patch.*Gx));
        gradient_Y(i,j) = sum(sum(patch.*Gy));
    end
end

%magnitudine si unghi pentru gradienti
angle = atan2(gradient_Y,gradient_X);
angle = angle*180/pi;
magnitude = sqrt(gradient_X.^2+gradient_Y.^2);

%corectie unghiuri negative
for i=1:size(angle,1)
    for j=1:size(angle,2)
        if angle(i,j)<0
            angle(i,j) = 180+angle(i,j);
        end
    end
end

%aproximare gradient pe 4 directii - 0,45,90,135 grade
for i = 1 :size(angle,1)
    for j = 1:size(angle,2)
        if ((angle(i, j) >= 0 ) && (angle(i, j) < 22.5) || (angle(i, j) >= 157.5) && (angle(i, j) < 202.5) || (angle(i, j) >= 337.5) && (angle(i, j) <= 360))
            angle(i, j) = 0;
        elseif ((angle(i, j) >= 22.5) && (angle(i, j) < 67.5) || (angle(i, j) >= 202.5) && (angle(i, j) < 247.5))
            angle(i, j) = 45;
        elseif ((angle(i, j) >= 67.5 && angle(i, j) < 112.5) || (angle(i, j) >= 247.5 && angle(i, j) < 292.5))
            angle(i, j) = 90;
        elseif ((angle(i, j) >= 112.5 && angle(i, j) < 157.5) || (angle(i, j) >= 292.5 && angle(i, j) < 337.5))
            angle(i, j) = 135;
        end
    end
end

%Non-Maximum supression
img_edge = zeros(size(magnitude));
for i=2:size(magnitude,1)-1
    for j=2:size(magnitude,2)-1
        if angle(i,j) == 0
            img_edge(i,j) = (magnitude(i,j) == max([magnitude(i,j),magnitude(i,j+1),magnitude(i,j-1)]));
        elseif angle(i,j) == 45
            img_edge(i,j) = (magnitude(i,j) == max([magnitude(i,j),magnitude(i-1,j+1),magnitude(i+1,j-1)]));
        elseif angle(i,j) == 90
            img_edge(i,j) = (magnitude(i,j) == max([magnitude(i,j),magnitude(i-1,j),magnitude(i+1,j)]));
        elseif angle(i,j) == 135
            img_edge(i,j) = (magnitude(i,j) == max([magnitude(i,j),magnitude(i-1,j-1),magnitude(i+1,j+1)]));
        end
    end
end
img_edge = img_edge.*magnitude;
% hysteresis th
TH_low = 0.001*max(img_edge(:));
TH_high = 0.2*max(img_edge(:));
im_canny = zeros(size(img_edge));
for i=1:size(img_edge,1)
    for j=1:size(img_edge,2)
        if img_edge(i,j) < TH_low
            im_canny(i,j) = 0;
        elseif img_edge(i,j) >= TH_high
            im_canny(i,j) = 1;
        elseif ( img_edge(i+1,j)>TH_high|| img_edge(i-1,j)>TH_high || img_edge(i,j+1)>TH_high || img_edge(i,j-1)>TH_high || img_edge(i-1, j-1)>TH_high || img_edge(i-1, j+1)>TH_high || img_edge(i+1, j+1)>TH_high || img_edge(i+1, j-1)>TH_high)
            im_canny(i,j) = 1;
        end
    end
end

border_rows = size(im,1)-size(im_canny,1);
border_cols = size(im,2)-size(im_canny,2);
im_contur = zeros(size(im));
im_contur(floor(border_rows/2):floor(border_rows/2)+size(im_canny,1)-1,floor(border_cols/2):floor(border_cols/2)+size(im_canny,2)-1)=im_canny;


end