function [TC] = TerminalCost(xf,k12,k21,k13,k31,k23,k32,dt)
K12 = k12 + k21;
K13 = k13 + k31;
K32 = k23 + k32;
k = K12 + K13*K32/(K13 + K32);
T=round(100/(k*dt));
x=zeros(T,2);
x(1,:)=xf;
for i=1:T
    [x(i+1,1),x(i+1,2)]=Euler(x(i,1),x(i,2),k12,k21,k13,k31,k23,k32,dt);
end
p1=x(:,1);
p2=x(:,2);
p3=1-(p1+p2);
TC=dt*sum((p1.*k12-p2.*k21).*log((p1.*k12)./(p2.*k21))+(p1.*k13-p3.*k31).*log((p1.*k13)./(p3.*k31))+(p2.*k23-p3.*k32).*log((p2.*k23)./(p3.*k32)));
end
function [y1,y2]=Euler(x1,x2,k12,k21,k13,k31,k23,k32,dt)

y1=x1+dt*(x2*(k21-k31)-x1*(k12+k31+k13)+k31);
y2=x2+dt*(x1*(k12-k32)-x2*(k21+k23+k32)+k32);
end
