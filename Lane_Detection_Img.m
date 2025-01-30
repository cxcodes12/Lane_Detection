clc
clearvars
close all

im_rgb = imread('challenge_000.png');
im = rgb2gray(im_rgb);
im = double(im);
% figure, imshow(uint8(im));
%aplicare canny edge detection
im_canny = myCanny(im);
% figure, imshow(im_canny);

%extragere ROI
[M,N] = size(im_canny);
coord = [0.9*M,round(0.1*N); round(0.65*M),round(0.4*N); round(0.65*M),round(0.6*N); 0.9*M, round(0.9*N)];

col = coord(:,2);
row = coord(:,1);
BW = roipoly(im_canny, col, row);
% figure, imshow(BW);
ROI = BW.*im_canny;
% figure, imshow(ROI);

% transformata hough
[H, theta, rho] = myHoughTransform(ROI);
% identificare intersectii - corespunzatoare liniilor identificate
peaks = myHoughPeaks(H, 8); 
lines = [];
% figure, imagesc(H);
% extragere linii din matricea de acumulatori
theta_ok=[];
rho_ok=[];
for i = 1:size(peaks, 1)
    rho_val = rho(peaks(i, 1));
    theta_val = theta(peaks(i, 2));
    if abs(theta_val) <= 70
        [x1, y1, x2, y2] = myHoughLines(ROI, rho_val, theta_val);
        lines = [lines; x1, y1, x2, y2];
        theta_ok = [theta_ok; theta_val];
        rho_ok = [rho_ok; rho_val];
    end
end
% eliminare linii redundante in baza unghiului de inclinatie (una vs celelalte)
[rho_ok_sort,rho_ok_sort_idx] = sort(rho_ok,'descend');
lines = lines(rho_ok_sort_idx,:);
valid_lines = [0 0 0 0];
x = round(N/2);
y = M;
for i = 1:size(lines, 1)
    line1 = lines(i, :);
    is_valid = true;
    for j = 1:size(lines, 1)
        if i ~= j
            line2 = lines(j, :);
            %tg(alpha)=panta=(y2-y1)/(x2-x1) =>
            angle_diff = abs(atand((line1(4)-line1(2))/(line1(3)-line1(1))) - atand((line2(4)-line2(2))/(line2(3)-line2(1))));
            if angle_diff < 10 & sum(ismember(valid_lines,line2,'rows')) %TH = 10 grade
                is_valid = false;
                break;
            end
        end
    end
    if is_valid
        valid_lines = [valid_lines; line1];
    end
end
valid_lines = valid_lines(2:end,:);



% afisare roi peste img
% figure, imshow(im_rgb), hold on;
coord_roi = [M,1; round(0.65*M),round(0.4*N); round(0.65*M),round(0.6*N); M,N; M,1];
% coord_roi = [M,1; round(M/2),round(N/4); round(M/2),round(3*N/4); M,N; M,1];
col = coord_roi(:,2)';
row = coord_roi(:,1)';

%afisare linii pe img originala
hold off
imshow(im_rgb);
hold on;
for i = 1:size(valid_lines, 1)
    [x,y] = polyxpoly([valid_lines(i,[1,3])],[valid_lines(i,[2,4])],col,row);
    if size(x,1)>=1 && size(y,1)>=1
    line([round(x(1)),round(x(2))], [round(y(1)),round(y(2))], 'Color', 'green', 'LineWidth',5);
    end
end
hold on

%determinarea punctului de intersectie a celor doua linii
if size(valid_lines,1)==2
xL1 = [valid_lines(1,1),valid_lines(1,3)];%coordonatele x pentru prima linie
yL1 = [valid_lines(1,2),valid_lines(1,4)];%coordonatele y pentru prima linie
xL2 = [valid_lines(2,1),valid_lines(2,3)];%coordonatele x pentru a doua linie
yL2 = [valid_lines(2,2),valid_lines(2,4)];
[x_int,y_int] = polyxpoly(xL1,yL1,xL2,yL2);

scatter(x_int,y_int,80,'red','filled'); 
end