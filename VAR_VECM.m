close all
clc
load IPI
[N,M]=size(Y);
horizon=50;
j=1;
h=1;
for i=horizon:N-h
Mdl1 = vecm(M,1,0);
EstMdl1 = estimate(Mdl1,Y(1:i,:));%summarize(EstMdl);
i
YF1= forecast(EstMdl1,h,Y(1:i,:));
YF_vecm(j,:) = YF1(h,:);
Mdl2=varm(M,1);
EstMdl2 = estimate(Mdl2,Y(1:i,:));
YF2= forecast(EstMdl2,h,Y(1:i,:));
YF_var(j,:) = YF2(h,:);
j=j+1;
end

% Mdl = varm('AR',{NaN(8)});
% Mdl.Trend = NaN;
% close all
% for m=1:8
%     subplot(4,2,m);
%     %figure
%     hold on; plot((Y(:,m)),'k-');
%     plot([Y(1:125,m);YF(:,m)],'r-');
% end
for m=1:M
rmse(m,1) = sqrt(mean((YF_var(:,m)-Y(horizon+h:N,m)).^2));
rmse(m,2) = sqrt(mean((YF_vecm(:,m)-Y(horizon+h:N,m)).^2));
end

Y_hat{1,1}=YF_var;
Y_hat{2,1}=YF_vecm;
Y_hat{3,1}=rmse;


p = [ 1 2 3 4 5 6 7 8];
estMdlResults = cell(numel(p),1); % Preallocation
Y0 = Y(1:horizon,:);
X = Y(horizon+1:end,:);
for j = 1:numel(p)
    Mdl = varm(M,p(j));
    %Mdl = vecm(M,p(j),0);
    EstMdl = estimate(Mdl,Y0,'Y0',X);
    estMdlResults{j} = summarize(EstMdl);
end

BIC=cellfun(@(x)x.BIC,estMdlResults)
