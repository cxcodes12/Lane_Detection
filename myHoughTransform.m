function [H, theta_range, rho_range] = myHoughTransform(im)
theta_res = 1;
rho_res = 1;

theta_range = -90:theta_res:89;
[M,N] = size(im);
diagonal = sqrt(M^2+N^2);
rho_range = -diagonal:rho_res:diagonal;
H = zeros(length(rho_range),length(theta_range));

[y,x] = find(im==1);
for i=1:length(x)
    for theta_idx = 1:length(theta_range)
        theta = theta_range(theta_idx);
        rho = x(i)*cosd(theta)+y(i)*sind(theta);
        rho_idx = round((rho+diagonal)/rho_res);
        H(rho_idx,theta_idx) = H(rho_idx,theta_idx)+1;
    end
end
