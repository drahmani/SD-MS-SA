clc
clear all
close all;
%cd('/Users/donya/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/IPI time series')
%cd('/Users/Donya/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/SSA codes/ssa-last-2019 June 2')
addpath('/Users/donya/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/SSA codes/ssa-last-2019 June/tools')
load Francead.csv
load Germanyad.csv
load UKad.csv
cd('/Users/donya/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/SSA codes/ssa-last-2019 June')
%addpath('/Users/donya/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/SSA codes/ssa-last-2019 June/tools')
Y = Francead;
%Y =Germanyad;
%Y =UKad;
load data.mat;
Y=Yf';
[N,M]=size(Y);

%L = 5; r=4; France
%L=4;r=3; Germany
L=2;r=1; %UK 4,3 oh (both L=5;r=3) sdm better 6,3
%horizon=220; France
%horizon=220; Germany
%horizon=125; %UK

h=1;iter=2000;alpha=.00001;beta=100;% 0.0001
[y_hat_ssa,~,~,Phi_ssa]=MSSA_Forecast_horizon(Y,2,h,1,horizon); %15, 4 France %15 3 Germany   %%%MSSA Forecast
[Phi_sdm]= BHSDM_SSA(alpha,beta,horizon,Y,L,r,iter,h);         %%% Phi_SDM_MSSA
[y_hat_sdm,~,~,~]=MSSA_Forecast_horizon(Y,L,h,r,horizon,Phi_sdm);                %%%%%SDM-MSSA Forecast
%subplot(2,2,1);
close all
for m=1:M
    subplot(8,4,m);
    %figure
    hold on; plot((Y(:,m)),'k-');
    plot(y_hat_ssa(:,m),'b-');
    plot(y_hat_sdm(:,m),'r-');

end
% figure
% for i=1:N-horizon
%     ssdm=reshape(Phi_sdm(i,:,:),L-1,M);
%     subplot(15,2,i);
%     %figure
%     hold on; plot((Phi_ssa(i,:)),'k-');
%     plot(ssdm,'r--');
%     %plot(y_hat_sdm(:,m),'m--');
% 
% end

for m=1:M
rmse_sdm(m) = sqrt(mean((y_hat_sdm(horizon+h:N,m)-Y(horizon+h:N,m)).^2));
rmse_ssa(m) = sqrt(mean((y_hat_ssa(horizon+h:N,m)-Y(horizon+h:N,m)).^2));
end
[rmse_sdm;rmse_ssa]'
figure
plot(rmse_sdm,'r-')
hold on; plot(rmse_ssa,'b-')

% close all  
% plot(T(m).y_hat(1+1,test_ind))
% hold on 
% plot(Y(test_ind,m),'r--')
%     plot(y_hat(:,m),'cx');
%     plot(y_hat(1+1,:),'r--');
%     plot(T(m).y_hat(1+3,:),'g--');
%     plot(T(m).y_hat(1+6,:),'b--');
%     plot(T(m).y_hat(1+12,:),'m--');
%     test_ind = [290-85:290];
%     for step =1:12
%         indy = test_ind(1+step-1:end);
%         rmse(m,step) = sqrt(mean((y_hat(1+step,indy)-Y(indy,m)').^2));
%     end 