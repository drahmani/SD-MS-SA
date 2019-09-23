function [Phi_sdm]= BHS_DM_SS_A(alpha,beta,horizon,Y,L,r,iter,h)
  %Select 2m observation and Fit AR(k) model to m  the time series X
  %n number of forecasting
  [N,M]=size(Y);
  k=L-1;
  %Multivariate bootstrap 
  [phi]=MBootstrap_SS_A_Forecast(L,r,Y,iter,horizon);
  Phi_boot=mean(phi,2);
  %Rhat=Z*t(Z)
  R_hat=cov(phi')*beta;
  sigma2_e=std(Phi_boot);%mean(apply(Boot_alpha,2,sd))
  Theta=zeros(N-horizon,2*k,M);
  for m=1:M
  H=zeros(N-horizon,2*k);K=H;
  Phi=zeros(2*k,2*k,N-horizon);C=Phi;F=Phi;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  Theta(1,:,m)=[Phi_boot' zeros(1,k)];
  %C0 var-cov matrix%%%%%%%%%%%%%%%%%%
  %Smoothness parameter
  %C_0 is (k+1)^2*(k+1)^2
  %Rhat is a matrix of (k+1)*(k+1)
  dat1=[R_hat;zeros(k, k)];
  dat2=[zeros(k, k);zeros(k, k)];
  C(:,:,1)=[dat1 dat2];
  %W
  SIGMA_V=(alpha*sigma2_e)*eye(k,k);
  col2=[zeros(k, k);SIGMA_V];  
  SIGMA_w=[zeros(2*k,k),col2];
  %Second Step
  %if(is.zeros(X))
  %Forecasting n observations
      j=0;
  for t=2:N-horizon
    X1=Y((horizon+j-k+1):(horizon+j),m);%X[(m+t-2):(m+t-2-k)]
    H(t,:)=[flipud(X1)',zeros(1,k)];
    X3=Y((horizon+j-k-h+1):(horizon+j-h),m);   
    f1=((X1-X3)./X1).*eye(k);%diff(X1)(rho*(1-rho).*((X1-X3)./X1))*eye(k);
    %f1=rho*diff(X1)*diag(k)
    %define F based on Delta_X
    UL=zeros(k, k);
    F(:,:,(t-1))=[[eye(k),f1];[UL,eye(k)]];
    %Kalman gain Matrix
    Phi(:,:,t)=F(:,:,t-1)*C(:,:,t-1)*(F(:,:,t-1)')+SIGMA_w;
    K(t,:)=Phi(:,:,t)*(H(t,:)')*(inv(H(t,:)*Phi(:,:,t)*(H(t,:)')+sigma2_e));
    C(:,:,t)=Phi(:,:,t)-K(t,:)'*(H(t,:)*Phi(:,:,t)*(H(t,:)')+sigma2_e)*(K(t,:));
    %Theta  
    j=j+1;
    Theta(t,:,m)=(F(:,:,t-1)*Theta(t-1,:,m)')'+K(t,:)*(Y(horizon+j,m)-H(t,:)*F(:,:,t-1)*Theta(t-1,:,m)');
%  par$Theta=Theta(-1,1:(k))
  end
  end
  
Phi_sdm=Theta(h:end,1:L-1,:);
