function [p1,p2] = Terminal(xf,k12,k21,dt,k)

T=round(0.1/(k*dt));
x=zeros(T,2);
x(1,:)=xf;

for i=1:T
    [x(i+1,1)]=Euler(x(i,1),k12,k21,dt);
end

p1=x(:,1);
p2=0.95-p1;

end

function [y1]=Euler(x1,k12,k21,dt)

y1 =x1+dt*(0.95*k21-(k12+k21)*x1);

end
