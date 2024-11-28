function [TC] = TerminalCost(xf,Uf)
%Uf is terminal parameter chosed.
TC = (-Uf(1)*log(Uf(1))-Uf(2)*log(Uf(2))+Uf(1)*log(-(Uf(1)+Uf(2))*(xf-1))+Uf(2)*log((Uf(1)+Uf(2))*xf)+(-Uf(2)+(Uf(1)+Uf(2))*xf)*log(xf*Uf(1)/(Uf(2)-Uf(2)*xf)))/(Uf(1)+Uf(2));
end

