function [solution,problem] = OCt(para,tau,settings)
    
    [problem,guess]=twostate(tau,para);  
    if length(settings)==2% Fetch the problem definition
        options= problem.settings(settings(1),settings(2)); 
    else
        options= problem.settings(settings); 
    end% Get options and solver settings 
    [solution,MRHistory]=solveMyProblem(problem,guess,options);
%     %% figures
%     xm=linspace(solution.T(1,1),solution.tf,10000)';
%     dxm=xm(2)-xm(1);
%     
%     xi = linspace(-0.5,0,10)';
%     dxi = xi(2)-xi(1);
%     K12i = problem.data.ki(1)+zeros(10,1);
%     K21i = problem.data.ki(2)+zeros(10,1);
%     K13i = problem.data.ki(3)+zeros(10,1);
%     K31i = problem.data.ki(4)+zeros(10,1);
%     K23i = problem.data.ki(5)+zeros(10,1);
%     K32i = problem.data.ki(6)+zeros(10,1);
%     P1i = para(4)+zeros(10,1);
%     P2i = para(5)+zeros(10,1);
%     P3i = 1-(P1i+P2i);
%     
%     K12m = speval(solution,'U',1,xm);
%     K21m = speval(solution,'U',2,xm);
%     K13m = speval(solution,'U',3,xm);
%     K31m = speval(solution,'U',4,xm);
%     K23m = speval(solution,'U',5,xm);
%     K32m = speval(solution,'U',6,xm);
%     
%     P1m=speval(solution,'X',1,xm);
%     P2m=speval(solution,'X',2,xm);
%     P3m=1-(speval(solution,'X',2,xm)+speval(solution,'X',1,xm));
%     
%     k = para(1) + para(2)*para(3)/(para(2)+para(3));
%     Pf = [P1m(end),P2m(end)];
%     [P1f,P2f,P3f]=Terminal(Pf,problem.data.kf(1),problem.data.kf(2),problem.data.kf(3),problem.data.kf(4),problem.data.kf(5),problem.data.kf(6),0.001,k);
%     L = length(P1f);
%     K12f = problem.data.kf(1)+zeros(L,1);
%     K21f = problem.data.kf(2)+zeros(L,1);
%     K13f = problem.data.kf(3)+zeros(L,1);
%     K31f = problem.data.kf(4)+zeros(L,1);
%     K23f = problem.data.kf(5)+zeros(L,1);
%     K32f = problem.data.kf(6)+zeros(L,1);
%     xf = linspace(tau,tau+0.001*(L-1),L)';
%     dxf = xf(2)-xf(1);
%     
%     
%     
%     dJ12i=dxi.*(P1i.*K12i-P2i.*K21i);
%     dJ13i=dxi.*(P1i.*K13i-P3i.*K31i);
%     dJ32i=dxi.*(P3i.*K32i-P2i.*K23i);
%     dJ12m=dxm.*(P1m.*K12m-P2m.*K21m);
%     dJ13m=dxm.*(P1m.*K13m-P3m.*K31m);
%     dJ32m=dxm.*(P3m.*K32m-P2m.*K23m);
%     dJ12f=dxf.*(P1f.*K12f-P2f.*K21f);
%     dJ13f=dxf.*(P1f.*K13f-P3f.*K31f);
%     dJ32f=dxf.*(P3f.*K32f-P2f.*K23f);
%     
%     
%     
%     xx = cat(1,xi,xm,xf);
%     P1 = cat(1,P1i,P1m,P1f);
%     P2 = cat(1,P2i,P2m,P2f);
%     P3 = 1-(P1+P2);
%     K12 = cat(1,K12i,K12m,K12f);
%     K21 = cat(1,K21i,K21m,K21f);
%     K13 = cat(1,K13i,K13m,K13f);
%     K31 = cat(1,K31i,K31m,K31f);
%     K23 = cat(1,K23i,K23m,K23f);
%     K32 = cat(1,K32i,K32m,K32f);
%     dJ12 = cat(1,dJ12i,dJ12m,dJ12f);
%     dJ13 = cat(1,dJ13i,dJ13m,dJ13f);
%     dJ32 = cat(1,dJ32i,dJ32m,dJ32f);
%     
%     J12=integra(dJ12);
%     J13=integra(dJ13);
%     J32=integra(dJ32);
%     R12=K12./K21;
%     R13=K13./K31;
%     R32=K32./K23;
%     r12=P2./P1;
%     r13=P3./P1;
%     r32=P2./P3;
%     C12 = (P1.*K12-P2.*K21).*log((P1.*K12)./(P2.*K21));
%     C13 = (P1.*K13-P3.*K31).*log((P1.*K13)./(P3.*K31));
%     C32 = (P3.*K32-P2.*K23).*log((P3.*K32)./(P2.*K23));
%     CCost = C12 + C13 + C32;
%     
%     
%     
%     linewidh = 1.2;
%     figure
%     hold on
%     plot(xx,P1,'r' ,'LineWidth',linewidh)
%     plot(xx,P2,'b' ,'LineWidth',linewidh)
%     plot(xx,P3,'k' ,'LineWidth',linewidh)
%     xlabel('time t')
%     ylabel('Probability')
%     legend('P1','P2','P3')
%     
%     figure
%     hold on
%     plot(xx,R12,'r','LineWidth',linewidh)
%     plot(xx,r12,'r','LineWidth',linewidh,'LineStyle','-.')
%     plot(xx,R13,'b','LineWidth',linewidh)
%     plot(xx,r13,'b','LineWidth',linewidh,'LineStyle','-.')
%     plot(xx,R32,'k','LineWidth',linewidh)
%     plot(xx,r32,'k','LineWidth',linewidh,'LineStyle','-.')
%     xlabel('time t')
%     legend('r12','p2/p1','r13','p3/p1','r32','p2/p3')
%     
%     figure
%     hold on
%     plot(xx,J12,'r','LineWidth',linewidh)
%     plot(xx,J13,'b','LineWidth',linewidh)
%     plot(xx,J32,'k','LineWidth',linewidh)
%     xlabel('time t')
%     legend('Φ12','Φ13','Φ32')
%     
%     figure
%     hold on
%     plot(xx,C12,'r','LineWidth',linewidh);
%     plot(xx,C13,'b','LineWidth',linewidh);
%     plot(xx,C32,'k','LineWidth',linewidh);
%     plot(xx,CCost,'Color',[0.3 0 0.3],'LineWidth',1);
%     xlabel('time t')
%     ylabel('entropy production [k_BT]')
%     legend('channel 12','channel 13','channel 23','total')
end

