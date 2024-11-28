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

clear all;close all;
tau = 5;
para=[0.072 0.9 0.1];
[problem,guess]=twostate(tau,para);          % Fetch the problem definition
options= problem.settings(50);
%options= problem.settings(300);                  % Get options and solver settings 
[solution,MRHistory]=solveMyProblem( problem,guess,options);

%% figures
xm=linspace(solution.T(1,1),solution.tf,10000)';
dxm=xm(2)-xm(1);
xi = linspace(-0.5,0,10)';
dxi = xi(2)-xi(1);
K12i = problem.data.ki(1)+zeros(10,1);
K21i = problem.data.ki(2)+zeros(10,1);
P1i = para(2)+zeros(10,1);
P2i = 1-P1i;

K12m = speval(solution,'U',1,xm);
K21m = speval(solution,'U',2,xm);

P1m=speval(solution,'X',1,xm);
P2m=1-P1m;
Pf = [P1m(end),P2m(end)];
[P1f,P2f] = Terminal(Pf,problem.data.kf(1),problem.data.kf(2),0.001,para(1));
L = length(P1f);
K12f = problem.data.kf(1)+zeros(L,1);
K21f = problem.data.kf(2)+zeros(L,1);
xf = linspace(tau,tau+0.001*(L-1),L)';
dxf = xf(2)-xf(1);

dJ12i=dxi.*(P1i.*K12i-P2i.*K21i);
dJ12m=dxm.*(P1m.*K12m-P2m.*K21m);
dJ12f=dxf.*(P1f.*K12f-P2f.*K21f);

xx = cat(1,xi,xm,xf);
P1 = cat(1,P1i,P1m,P1f);
P2 = cat(1,P2i,P2m,P2f);
K12 = cat(1,K12i,K12m,K12f);
K21 = cat(1,K21i,K21m,K21f);
dJ12 = cat(1,dJ12i,dJ12m,dJ12f);
J12=integra(dJ12);
R12=K12./K21;
r12=P2./P1;
C12 = (P1.*K12-P2.*K21).*log((P1.*K12)./(P2.*K21));
CCost = C12;


p1f = para(3) + zeros(L,1);
pi=para(2);
pf=para(3);
ri=(1-pi)/pi;
rf=(1-pf)/pf;
[p,r] = analyticalsolution(tau,100,ri,rf,para(2));
p1 = cat(1,P1i,p',p1f);
xp = cat(1,xi,linspace(0,tau,length(p))',xf);

R = cat(1,K12i./K21i,r',K12f./K21f);
xr = cat(1,xi,linspace(0,tau,length(p)-1)',xf);

linewidh = 1.2;
subplot(2,2,1);
hold on
plot(xx,P1,'r' ,'LineWidth',linewidh)
plot(xx,P2,'b' ,'LineWidth',linewidh)
xlabel('t')
ylabel('Probability')
legend('P1','P2')

subplot(2,2,2);
hold on
plot(xx,R12,'r','LineWidth',linewidh)
plot(xx,r12,'r','LineWidth',linewidh,'LineStyle','-.')
plot(xr,R,'b','LineWidth',linewidh,'LineStyle',':')
xlabel('t')
legend('r12','p2/p1','r12 in adiabatic limit')

subplot(2,2,3);
hold on
plot(xx,J12,'r','LineWidth',linewidh)
xlabel('t')
legend('Φ12')


subplot(2,2,4);
hold on
plot(xx,CCost,'Color',[0.3 0 0.3],'LineWidth',1);
xlabel('t')
legend('entropy production rate')