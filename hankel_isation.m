function y = hankel_isation(X)

% hold on! why no delay X the whole way along and then just average the
% columns!. 

[L,N] = size(X);
for i=1:L
    dd(i,1:N+i-1) = delaa(X(i,:),i-1);
end
mask = dd~=0;
S=sum(mask);
y=L*mean(dd)./(S);

return

