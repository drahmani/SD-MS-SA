function [Phi] = ssa_phi(U,r,L)
v2 = sum(U(end,1:r).^2);
Udelta = U(1:end-1,1:r);  
Phi = zeros(L-1,1);
for i=1:r
    Phi = Phi + U(end,i)*Udelta(:,i)/(1-v2);
end
