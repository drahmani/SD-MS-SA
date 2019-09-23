function [Phi]=MBootstrapSSA_Forecast(L,r,Y,iter,horizon)
addpath('/Users/donya/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/SSA codes/ssa-last-2019 June/tools')
addpath('/Users/donya/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/SSA codes/ArXive SSA codes/Github')
Y=Y(1:horizon,:); % phi's should be generated only for those points which have beed observed till now! (horizon) therefore h=1
% use . reconstruction information
[U,error_rec,y_hat]=MSSA_rec_donya(Y,L,r);
%now generate muti_norm random variable from  mean(error_rec) and
%Sigma(error_rec) and find boostrap Phi
hx1=y_hat;
mu1=mean(error_rec);%sd1=std2(error_rec);
cov_e=cov(error_rec);
for i=1:iter
    Phi(:,i) = ssa_phi(U,r,L);
    X1=hx1+mvnrnd(mu1,cov_e,horizon);
    [U,~,~]=MSSA_rec_donya(X1,L,r);
    %[y_hat,~,U]=MSSA_Forecast_horizon(X1,h,L,r,horizon);
end
%%%average bootstrap Phi and find the forecast y by the average boot_phi
% Phi_boot=mean(Phi,2);
% y_hat_boot(1:horizon,:) =y_hat(1:horizon,:);
% for i=1:h
%     y_hat_boot(horizon+i,:) = y_hat_boot((horizon-L+1+i:horizon+i-1),:)'*Phi_boot;
% end

