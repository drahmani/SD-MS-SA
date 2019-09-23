clc
clear all
close all;
%load time series IPI, EUUR and USUR 
load IPI 
%load USUR
%load EUUR
[N,M]=size(Y);
%select L and r
L=12;r=5;
h=1;iter=2000;alpha=.00001;beta=100;% 0.0001
[y_hat_ssa,~,~,Phi_ssa]=MSSA_Forecast_horizon(Y,2,h,1,horizon); 
[Phi_sdm]= BHSDM_SSA(alpha,beta,horizon,Y,L,r,iter,h);        
[y_hat_sdm,~,~,~]=MSSA_Forecast_horizon(Y,L,h,r,horizon,Phi_sdm);                
%subplot(2,2,1);
close all
for m=1:M
    subplot(8,4,m);
    %figure
    hold on; plot((Y(:,m)),'k-');
    plot(y_hat_ssa(:,m),'b-');
    plot(y_hat_sdm(:,m),'r-');

end
for m=1:M
rmse_sdm(m) = sqrt(mean((y_hat_sdm(horizon+h:N,m)-Y(horizon+h:N,m)).^2));
rmse_ssa(m) = sqrt(mean((y_hat_ssa(horizon+h:N,m)-Y(horizon+h:N,m)).^2));
end
[rmse_sdm;rmse_ssa]'
figure
plot(rmse_sdm,'r-')
hold on; plot(rmse_ssa,'b-')
