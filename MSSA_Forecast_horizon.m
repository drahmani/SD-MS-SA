function [hat_y,error_rec,U,Phi_x]=MSSA_Forecast_horizon(Y,L,h,r,horizon,Phi)
%horizon=train_size
[N,~]=size(Y);
j=1;
for k=horizon:N-h
    X=Y(1:k,:);
    if nargin < 6
    [yy_hat,y_hat,U,~,Phi_xx] = MSSA_Forecast(X,h,L,r);
    Phi_x(j,:)=Phi_xx;
    else
    [yy_hat,y_hat,U,~,~] = MSSA_Forecast(X,h,L,r,Phi(j,1:(L-1),:));
    Phi_x=Phi(j,1:(L-1),:);
    end
    g(k+h,:)=yy_hat(k+h,:); % this saves hth forecast
    j=j+1;
end
hat_y=[y_hat(1:horizon+h-1,:);g(horizon+h:N,:)];
error_rec=Y(1:horizon+h-1,:)-y_hat(1:horizon+h-1,:);%reconstruction error
% figure
% hat_y=[y_hat(1:horizon+h-1,:);g(horizon+h:N,:)]
% plot(Y)
% hold on
% plot(hat_y,'r--');
