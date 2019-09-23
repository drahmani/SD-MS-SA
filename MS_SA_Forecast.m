function [yy_hat,y_hat,U,lambda,Phi] = MS_SA_Forecast(Y,h,L,r,Phi_sdm)
[N,M]=size(Y);
if nargin < 4
    error('requires at most 4 inputs: Y,h,L,r');
end
 y_hat=zeros(N+h,M);
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
        T(m).Yrecon = hankel_isation(T(m).Xrecon);
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
 
