function [Phi]=MBootstrap_SS_A_Forecast(L,r,Y,iter,horizon)
Y=Y(1:horizon,:); % phi's should be generated only for those points which have beed observed till now! (horizon) therefore h=1
% use . reconstruction information
[U,error_rec,y_hat]=MS_SA_rec(Y,L,r);
%now generate muti_norm random variable from  mean(error_rec) and
%Sigma(error_rec) and find boostrap Phi
hx1=y_hat;
mu1=mean(error_rec);%sd1=std2(error_rec);
cov_e=cov(error_rec);
for i=1:iter
    Phi(:,i) = ssa_phi(U,r,L);
    X1=hx1+mvnrnd(mu1,cov_e,horizon);
    [U,~,~]=MS_SA_rec(X1,L,r);
    %[y_hat,~,U]=MSSA_Forecast_horizon(X1,h,L,r,horizon);
end


