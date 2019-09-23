function X = traj_mat(Y,L)
% Create a trajectory matrix from the data in Y of window length L. 
N = length(Y);
K = N-L+1;
X=[];       % Trajectory matrix.
if ~isnumeric(Y)
    X = sym;
end
%    for k=1:K
%        X(1:L,k) = Y(k:k+L-1);
%    end
%end
for k=1:K
    X(1:L,k) = Y(k:k+L-1); % +L+1+1 => +L as thats the size of the delay in the system. +1 for lose one at the start and +1 as the last row is for the next unobseverd data point. 
end

