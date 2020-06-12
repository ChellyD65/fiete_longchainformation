% DetectAssemblies.m
% Marcello DiStasio
% April, 2020

function y = DetectAssemblies(xrec)
%xrec is a m x n matrix with m neurons and n timepoints
xin = double(xrec);
xnorm = ((xin'-mean(xin')) ./ std(xin'))';
xnorm(isnan(xnorm)) = min(min(xnorm));
x = xnorm;

N=size(xrec, 1);
T=size(xrec, 2);
c=N/T;

s=std(x(:)); 
r=x*x'/T; % spectral matrix
l=eig(r); %eigenvalues

% Probability Density Function 
% number of points for measurement.
n=50;
% Boundaries 
a=(s^2)*(1-sqrt(c))^2;
b=(s^2)*(1+sqrt(c))^2;




[f,lambda]=hist(l,linspace(a,b,n));
% Normalization
f=f/sum(f);
% Theoretical pdf
ft=@(lambda,a,b,c) (1./(2*pi*lambda*c*s^(2))).*sqrt((b-lambda).*(lambda-a));
F=ft(lambda,a,b,c);
% Processing numerical pdf
F=F/sum(F);
F(isnan(F))=0;
% Results
figure;
h=bar(lambda,f);
set(h,'FaceColor',[.75 .75 .8]);
set(h,'LineWidth',0.25);
xlabel('Eigenvalue \lambda');
ylabel('Probability Density Function f(\lambda)');
title('Marchenko-Pastur distribution');
lmin=min(l);
lmax=max(l);
%axis([-1 2*lmax 0 max(f)+max(f)/4]);
hold on;
plot(lambda,F,'g','LineWidth',2);
hold off;



y = 0;



end