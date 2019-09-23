function [yy_hat,y_hat,U,lambda,Phi] = MSSA_Forecast(Y,h,L,r,Phi_sdm)
%function [yyy_hat,yy_hat,y_hat,U,lambda,error_rec] = MSSA_Forecast(Y,h,L,r,train_size)
% h step ahead 
% train_size= cut point
% T gives X, C, Xrecon, Yrecon, y_hat
addpath('/Users/donya/Library/Mobile Documents/com~apple~CloudDocs/Documents/Documents-Donya-Mac/SOEM/SOEM-SSA/SSA codes/ssa-last-2019 June/tools')
[N,M]=size(Y);
if nargin < 4
    error('requires at most 4 inputs: Y,h,L,r');
end
% if nargin
%    train_size = N-h;
% end
 y_hat=zeros(N+h,M);
%B=zeros(8,N-train_size);
%for horizon = train_size:(N-h)   
    XX=[];
    CC = zeros(L,L);
    for m=1:M
        T(m).X = traj_mat(Y(:,m),L);
        T(m).C = T(m).X*T(m).X';
        CC = CC + T(m).C;
        XX = [XX T(m).X];
    end
    
    [Xrecon,~,U,lambda] = ssa_recon(XX,r);
    [L,KM] = size(Xrecon);
    for m=1:M
        T(m).Xrecon = Xrecon(:,(KM/M)*(m-1)+1:(KM/M)*(m));
        T(m).Yrecon = hankelisation(T(m).Xrecon);
        y_hat(1:N,m) = T(m).Yrecon;
        if nargin <5 
    [Phi] = ssa_phi(U,r,L);
        else
    [Phi]=Phi_sdm(:,:,m)';        
        end 
        for i=1:h 
            y_hat(N+i,m) = y_hat(N-L+1+i:N+i-1,m)'*Phi;
        end    
    end
    yy_hat(N+h,:)=y_hat(N+h,:);
    %this was supposed to save each forecast at step 12th from horizon to N but it overwrites!         
     
%yy_hat(1:train_size+h-1,:)=y_hat(horizon+h,:);
%  for m=1:M
%      yyy_hat(:,m)=[y_hat(1:train_size+h-1,m); yy_hat(train_size+h:N,m)];
%    %f_y_hat(1:(train_size+h-1),m)=T(m).y_hat(1:train_size)';
%    error_rec(:,m)=Y(1:train_size,m)-y_hat(1:train_size,m);%reconstruction error
%    %y_hat_recon(:,m)=T(m).y_hat;
%  end
