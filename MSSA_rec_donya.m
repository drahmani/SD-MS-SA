function [U,error_rec,y_hat]=MSSA_rec_donya(Y,L,r)
[~,M]=size(Y);
%%
%%%run SSA-Reconstruction step to get U and rec_error for Y(1:horizon,:)
XX=[];
CC = zeros(L,L);
for m=1:M
    T(m).X = traj_mat(Y(:,m),L);
    T(m).C = T(m).X*T(m).X';
    CC = CC + T(m).C;
    XX = [XX T(m).X];
end

[Xrecon,~,U,~] = ssa_recon(XX,r);
[L,KM] = size(Xrecon);
for m=1:M
    T(m).Xrecon = Xrecon(:,(KM/M)*(m-1)+1:(KM/M)*(m));
    T(m).Yrecon = hankelisation(T(m).Xrecon);
    y_hat(:,m) = T(m).Yrecon;    
    error_rec(:,m)=Y(:,m)-y_hat(:,m);%reconstruction error
end