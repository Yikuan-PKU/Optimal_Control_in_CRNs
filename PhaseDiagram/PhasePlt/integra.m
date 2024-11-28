function [y] = integra(x)
N=length(x);
y=zeros(1,N);
y(1)=x(1);
for i=1:N-1
     y(i+1)=x(i+1)+y(i);
end

