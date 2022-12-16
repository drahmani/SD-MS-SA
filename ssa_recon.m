function [Xrecon,Xr,U,lambda] = ssa_recon(X,r,vectwise)

if ~exist('vectwise')
    vectwise = 0; 
end

[L,dummy] = size(X);
LC = X*X'; % lag covariance matrix.
LC = LC;
%[V,lambda] = eigs(LC,L);
[U,lambda] = eig(LC);
lambda = diag(lambda);
[lambda,inds]=sort(lambda,'descend');
U = U(:,inds);
for i=1:L
    Xr(i).x = U(:,i)*U(:,i)'*X;
end
Xrecon = zeros(size(Xr(1).x));
if ~vectwise 
    for i=1:r
        Xrecon = Xr(i).x + Xrecon;
    end
else 
    for i=r
        Xrecon = Xr(i).x + Xrecon;
    end
end

return

% This is the alternative way - UX'X == sqrt(lambda)UU'V/sqrt(lambda)

for i=1:L
    Vi = X'*U(:,i)/sqrt(lambda(i));
    Xr(i).x=sqrt(lambda(i))*U(:,i)*Vi';
    if i>1
        Xr(i).S =  Xr(i-1).S + Xr(i).x;
    else
        Xr(i).S =  Xr(i).x;
    end
    
    Xr(i).sse =sum( sum(Xr(i).S-X).^2);
end
a=[ Xr(:).sse];
plot(a)
figure
plot(X(1,:))
hold on 
plot(Xr(1).x(1,:),'r--')
plot(Xr(1).x(1,:)+Xr(2).x(1,:),'g--')
plot(Xr(1).x(1,:)+Xr(2).x(1,:)+Xr(3).x(1,:),'y--')
