% main_h_MeshRefinement - Main script to solve the Optimal Control Problem
%
% Fed-batch fermentor optimal control problem
%
% The problem was adapted from Example 2, Section 12.4.2 of
% J.E. Cuthrell and L. T. Biegler. Simultaneous optimization and solution methods for batch reactor control profiles. Computers and Chemical Engineering, 13:49-62, 1989.
%
% Copyright (C) 2019 Yuanbo Nie, Omar Faqir, and Eric Kerrigan. All Rights Reserved.
% The contribution of Paola Falugi, Eric Kerrigan and Eugene van Wyk for the work on ICLOCS Version 1 (2010) is kindly acknowledged.
% This code is published under the MIT License.
% Department of Aeronautics and Department of Electrical and Electronic Engineering,
% Imperial College London London  England, UK 
% ICLOCS (Imperial College London Optimal Control) Version 2.5 
% 1 Aug 2019
% iclocs@imperial.ac.uk

%--------------------------------------------------------
%constrained 
clear all;close all;format compact;
tau=0.409;%%control time 
para=[5 0.1 50 0.8 0.1 0.1 0.8]; %%[K1 K2 K3 p1i p2i p1f p2f] K1=k12+k21,K2=k13+k31,r1=p2/p1,r2=p1/(1-(p1+p2)).
[problem,guess]=twostate(tau,para);          % Fetch the problem definition
    options= problem.settings(40,4);                 % Get options and solver settings 
    [solution,MRHistory]=solveMyProblem(problem,guess,options);
%% figures
xm=linspace(solution.T(1,1),solution.tf,10000)';
dxm=xm(2)-xm(1);

xi = linspace(-0.5,0,10)';
dxi = xi(2)-xi(1);
K12i = problem.data.ki(1)+zeros(10,1);
K21i = problem.data.ki(2)+zeros(10,1);
K13i = problem.data.ki(3)+zeros(10,1);
K31i = problem.data.ki(4)+zeros(10,1);
K23i = problem.data.ki(5)+zeros(10,1);
K32i = problem.data.ki(6)+zeros(10,1);
P1i = para(4)+zeros(10,1);
P2i = para(5)+zeros(10,1);
P3i = 1-(P1i+P2i);



K12m = speval(solution,'U',1,xm);
K21m = speval(solution,'U',2,xm);
K13m = speval(solution,'U',3,xm);
K31m = speval(solution,'U',4,xm);
K23m = speval(solution,'U',5,xm);
K32m = speval(solution,'U',6,xm);

P1m=speval(solution,'X',1,xm);
P2m=speval(solution,'X',2,xm);
P3m=1-(speval(solution,'X',2,xm)+speval(solution,'X',1,xm));

k = para(1) + para(2)*para(3)/(para(2)+para(3));
Pf = [P1m(end),P2m(end)];
[P1f,P2f,P3f]=Terminal(Pf,problem.data.kf(1),problem.data.kf(2),problem.data.kf(3),problem.data.kf(4),problem.data.kf(5),problem.data.kf(6),0.001,k);
L = length(P1f);
K12f = problem.data.kf(1)+zeros(L,1);
K21f = problem.data.kf(2)+zeros(L,1);
K13f = problem.data.kf(3)+zeros(L,1);
K31f = problem.data.kf(4)+zeros(L,1);
K23f = problem.data.kf(5)+zeros(L,1);
K32f = problem.data.kf(6)+zeros(L,1);
xf = linspace(tau,tau+0.001*(L-1),L)';
dxf = xf(2)-xf(1);



dJ12i=dxi.*(P1i.*K12i-P2i.*K21i);
dJ13i=dxi.*(P1i.*K13i-P3i.*K31i);
dJ32i=dxi.*(P3i.*K32i-P2i.*K23i);
dJ12m=dxm.*(P1m.*K12m-P2m.*K21m);
dJ13m=dxm.*(P1m.*K13m-P3m.*K31m);
dJ32m=dxm.*(P3m.*K32m-P2m.*K23m);
dJ12f=dxf.*(P1f.*K12f-P2f.*K21f);
dJ13f=dxf.*(P1f.*K13f-P3f.*K31f);
dJ32f=dxf.*(P3f.*K32f-P2f.*K23f);



xx = cat(1,xi,xm,xf);
P1 = cat(1,P1i,P1m,P1f);
P2 = cat(1,P2i,P2m,P2f);
P3 = 1-(P1+P2);
K12 = cat(1,K12i,K12m,K12f);
K21 = cat(1,K21i,K21m,K21f);
K13 = cat(1,K13i,K13m,K13f);
K31 = cat(1,K31i,K31m,K31f);
K23 = cat(1,K23i,K23m,K23f);
K32 = cat(1,K32i,K32m,K32f);
dJ12 = cat(1,dJ12i,dJ12m,dJ12f);
dJ13 = cat(1,dJ13i,dJ13m,dJ13f);
dJ32 = cat(1,dJ32i,dJ32m,dJ32f);

J12=integra(dJ12);
J13=integra(dJ13);
J32=integra(dJ32);
R12=K12./K21;
R13=K13./K31;
R32=K32./K23;
r12=P2./P1;
r13=P3./P1;
r32=P2./P3;
C12 = (P1.*K12-P2.*K21).*log((P1.*K12)./(P2.*K21));
C13 = (P1.*K13-P3.*K31).*log((P1.*K13)./(P3.*K31));
C32 = (P3.*K32-P2.*K23).*log((P3.*K32)./(P2.*K23));
CCost = C12 + C13 + C32;



linewidh = 1.2;
subplot(2,2,1);
hold on
plot(xx,P1,'r' ,'LineWidth',linewidh)
plot(xx,P2,'b' ,'LineWidth',linewidh)
plot(xx,P3,'k' ,'LineWidth',linewidh)
xlabel('t')
ylabel('Probability')
legend('P1','P2','P3')

subplot(2,2,2);
hold on
plot(xx,R12,'r','LineWidth',linewidh)
plot(xx,r12,'r','LineWidth',linewidh,'LineStyle','-.')
plot(xx,R13,'b','LineWidth',linewidh)
plot(xx,r13,'b','LineWidth',linewidh,'LineStyle','-.')
plot(xx,R32,'k','LineWidth',linewidh)
plot(xx,r32,'k','LineWidth',linewidh,'LineStyle','-.')
xlabel('t')
legend('r12','p2/p1','r13','p3/p1','r32','p2/p3')

subplot(2,2,3);
hold on
plot(xx,J12,'r','LineWidth',linewidh)
plot(xx,J13,'b','LineWidth',linewidh)
plot(xx,J32,'k','LineWidth',linewidh)
xlabel('t')
legend('Φ12','Φ13','Φ32')


subplot(2,2,4);
hold on
plot(xx,C12,'r','LineWidth',linewidh);
plot(xx,C13,'b','LineWidth',linewidh);
plot(xx,C32,'k','LineWidth',linewidh);
plot(xx,CCost,'Color',[0.3 0 0.3],'LineWidth',1);
xlabel('t')
legend('epr channel 12','epr channel 13','epr channel 23','epr total')




figure;


range=zeros(length(0.01:0.01:1));

for i=1:1:length(range)-1
    for j=1:1:i
        if length(range)-1-i > 0

            range(j,length(range)-1-i)=1;
        end
    end
end

c12 = para(1);
c13 = para(2);
c23 = para(3);


[p1,p2]=meshgrid(0.01:0.01:1,0.01:0.01:1);
p1=p1.*range;
p2=p2.*range;
g11=G11(p1,p2,c12,c13,c23);
g12=G12(p1,p2,c12,c13,c23);
g22=G22(p1,p2,c12,c13,c23);
z1=G11(P1m,P2m,c12,c13,c23);
z2=G12(P1m,P2m,c12,c13,c23);
z3=G22(P1m,P2m,c12,c13,c23);

clim=[0,4];
t=tiledlayout(1,3);
nexttile
mesh(p1,p2,g11)
hold on;
plot3(P1m,P2m,z1,'-k','LineWidth',2)
xlabel('P_1')
ylabel('P_2')
subtitle('\Lambda^*_{11}');
caxis(clim);

nexttile
mesh(p1,p2,g12)
hold on;
plot3(P1m,P2m,z2,'-k','LineWidth',2)
xlabel('P_1')
ylabel('P_2')
subtitle('\Lambda^*_{12}')
caxis(clim);

nexttile
mesh(p1,p2,g22)
hold on;
plot3(P1m,P2m,z3,'-k','LineWidth',2)
xlabel('P_1')
ylabel('P_2')
subtitle('\Lambda^*_{22}')
sgtitle('The metric and geodesic')




caxis(clim);
cb=colorbar;
colormap(othercolor('RdGy11'));



% tatttt=log(8)/(para(1)+para(2)*para(3)/(para(2)+para(3)))
% 
% tauRs = tauR(K12m,K21m,K13m,K31m,K23m,K32m);
% figure
% tau_R = sum(abs(tauRs))/length(tauRs)
% plot(abs(tauRs))






function g11=G11(p1,p2,c12,c13,c23)
p3=1-p1-p2;
R12 = (1./p1+1./p2)./(2*c12);
R13 = (1./p1+1./p3)./(2*c13);
R23 = (1./p3+1./p2)./(2*c23);
g11=2*(R13.*(R12+R23))./(R12+R13+R23);
end

function g12=G12(p1,p2,c12,c13,c23)
p3=1-p1-p2;
R12 = (1./p1+1./p2)./(2*c12);
R13 = (1./p1+1./p3)./(2*c13);
R23 = (1./p3+1./p2)./(2*c23);
g12=2*(R13.*R23)./(R12+R13+R23);

end

function g22=G22(p1,p2,c12,c13,c23)
p3=1-p1-p2;
R12 = (1./p1+1./p2)./(2*c12);
R13 = (1./p1+1./p3)./(2*c13);
R23 = (1./p3+1./p2)./(2*c23); 
g22=2*(R23.*(R12+R13))./(R12+R13+R23);
end

function t = tauR(k12,k21,k13,k31,k23,k32)
lambda = (1/2).*((-1).*k12+(-1).*k13+(-1).*k21+(-1).*k23+(-1).*k31+(-1).* ...
  k32+((k12+k13+k21+k23+k31+k32).^2+(-4).*((k21+k23).*(k13+k31)+( ...
  k13+k21).*k32+k12.*(k23+k31+k32))).^(1/2));
t=1./lambda;
end
