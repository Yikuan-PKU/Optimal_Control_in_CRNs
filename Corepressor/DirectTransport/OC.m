function solution = OC(para,tau,settings)
    [problem,guess]=twostate(tau,para);          % Fetch the problem definition
    options= problem.settings(settings);
                  % Get options and solver settings 
    [solution,MRHistory]=solveMyProblem( problem,guess,options);


    figure
    xm=linspace(solution.T(1,1),solution.tf,10000)';
    dxm=xm(2)-xm(1);
    xi = linspace(-0.5,0,10)';
    dxi = xi(2)-xi(1);
    K12i = problem.data.ki(1)+zeros(10,1);
    K21i = problem.data.ki(2)+zeros(10,1);
    P1i = para(2)+zeros(10,1);
    P2i = 0.95-P1i;
    
    K12m = speval(solution,'U',1,xm);
    K21m = speval(solution,'U',2,xm);
    
    P1m=speval(solution,'X',1,xm);
    P2m=0.95-P1m;
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
    
end

