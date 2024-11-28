function [p1,p2,p3] = Terminal(xf,k12,k21,k13,k31,k23,k32,dt,k)

T=round(1/(k*dt));
x=zeros(T,2);
x(1,:)=xf;

for i=1:T
    [x(i+1,1),x(i+1,2)]=Euler(x(i,1),x(i,2),k12,k21,k13,k31,k23,k32,dt);
end
p1=x(:,1);
p2=x(:,2);
p3=1-(p1+p2);
end

function [y1,y2]=Euler(x1,x2,k12,k21,k13,k31,k23,k32,dt)

y1=x1+dt*(x2*(k21-k31)-x1*(k12+k31+k13)+k31);
y2=x2+dt*(x1*(k12-k32)-x2*(k21+k23+k32)+k32);
end
