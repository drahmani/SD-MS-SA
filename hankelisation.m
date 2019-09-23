function y = hankelisation(X)

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

plot(ff);
hold on
plot(y,'r--');

% returns the anti-diagonal sums of the trajectory matrix X. 
[L,N] = size(X);
N=N-1+L;
for k=1:N
    mask = fliplr(full(spdiags([ones(L,1)], N-L+1-k, L,N-L+1)));
    mask = mask==1;
    y(k) = mean(X(mask));
end
