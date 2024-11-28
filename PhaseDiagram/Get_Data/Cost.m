function [p1,p2,p3,k12,k21,k13,k31,k23,k32,Cost,cost] = Cost(pt,p,rt,r,T,t12,t23,t13)%T的长度需要和pt，rt的长度保持相同。
t=linspace(0,T,300);
r12 = interp1(rt,r(1,:),t);
r31 = interp1(rt,r(2,:),t);
r23 = 1./(r12.*r31);
p1 = interp1(pt,p(:,1),t);
p2 = interp1(pt,p(:,2),t);
p3 = interp1(pt,p(:,3),t);
k12 = r12.*t12./(1+r12);
k21 = t12./(1+r12);
k13 = t13./(1+r31);
k31 = r31.*t13./(1+r31);
k23 = r23.*t23./(1+r23);
k32 = t23./(1+r23);
cost =(p1.*k12-p2.*k21).*log((p1.*k12)./(p2.*k21))+(p1.*k13-p3.*k31).*log((p1.*k13)./(p3.*k31))+(p2.*k23-p3.*k32).*log((p2.*k23)./(p3.*k32));
Cost = sum(cost)/30;
end
