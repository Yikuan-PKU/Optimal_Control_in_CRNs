function [p,r] = analyticalsolution(t,K,ri,rf,pi)


T = linspace(0,t,1000);

r = tan((1-T./t).*atan(sqrt(ri))+(T./t).*atan(sqrt(rf))).^2;
k12=r.*K./(1+r);
k21=K./(1+r);
p = zeros(1,length(T)+1);
p(1,1) = pi;

for i=1:length(T)
    [p(1,1+i)]=Euler(p(1,i),k12(i),k21(i),T(2)-T(1));
end


end

function [y1]=Euler(x1,k12,k21,dt)

y1 =x1+dt*(k21-(k12+k21)*x1);

end