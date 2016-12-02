function [Serrp,Serrj]=uispecerr(S,J,err,trialave,numsp)
% Function to compute lower and upper confidence intervals on the spectrum 
% Usage: [Serrp,Serrj]=uispecerr(S,J,err,trialave,numsp)
% Outputs: Serrp (Serrp(1,...) - lower confidence level, Serrp(2,...) upper
% confidence level), similarly for Serrj
%
% Inputs:
% S - spectrum
% J - tapered fourier transforms 
% err - [errtype p] (errtype=1 - asymptotic estimates; errchk=2 - Jackknife estimates; 
%                   p - p value for error estimates)
% trialave - 0: no averaging over trials/channels
%            1 : perform trial averaging
% numsp    - number of spikes in each channel. specify only when finite
%            size correction required (and of course, only for point
%            process data)
%
% Outputs:
% Serrp - population error estimates. Only for err(1)>=1. 
% Serrj - jackknife error estimates. Computed only for err(1)>=2, otherwise
% set to zero
if nargin < 4; error('Need at least 4 input arguments'); end;
if err(1)==0; error('Need err=[1 p] or [2 p] for error bar calculation. Make sure you are not asking for the output of Serr'); end;
[nf,K,C]=size(J);
errchk=err(1);
p=err(2);
pp=1-p/2;
qq=1-pp;

if trialave
   dim=K*C;
   C=1;
   dof=2*dim;
   if nargin==5; dof = fix(1/(1/dof + 1/(2*sum(numsp)))); end
   J=reshape(J,nf,dim);
else
   dim=K;
   dof=2*dim*ones(1,C);
   for ch=1:C;
     if nargin==5; dof(ch) = fix(1/(1/dof + 1/(2*numsp(ch)))); end 
   end;
end;
Serrp=zeros(2,nf,C);
Serrj=zeros(2,nf,C);
if errchk>=1
   Qp=chi2inv(pp,dof);
   Qq=chi2inv(qq,dof);
   Serrp(1,:,:)=dof(ones(nf,1),:).*S./Qp(ones(nf,1),:);
   Serrp(2,:,:)=dof(ones(nf,1),:).*S./Qq(ones(nf,1),:);
elseif errchk>=2;
   tcrit=tinv(pp,dim-1);
   for k=1:dim;
       indices=setdiff(1:dim,k);
       Jjk=J(:,indices,:); % 1-drop projection
       eJjk=squeeze(sum(Jjk.*conj(Jjk),2));
       Sjk(k,:,:)=eJjk/(dim-1); % 1-drop spectrum
   end;
   sigma=sqrt(dim-1)*squeeze(std(log(Sjk),1,1)); if C==1; sigma=sigma'; end; 
   conf=repmat(tcrit,nf,C).*sigma;
   conf=squeeze(conf); 
   Serrj(1,:,:)=S.*exp(-conf); Serrj(2,:,:)=S.*exp(conf);
end;
Serrp=squeeze(Serrp);
Serrj=squeeze(Serrj);
