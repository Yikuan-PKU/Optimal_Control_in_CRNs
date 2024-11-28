function cost = GraphW_cal(p1,p2,k12,k21,k13,k31,k23,k32,T)

m = mobility(p1,p2,k12,k21,k13,k31,k23,k32);
W = wasserstein(p1,p2,1-p1-p2);
cost = W^2/(m*T);


end

function m = mobility(p1,p2,k12,k21,k13,k31,k23,k32)

ms = (p1.*k12-p2.*k21)./log((p1.*k12)./(p2.*k21))+(p1.*k13-(1-p1-p2).*k31)./log((p1.*k13)./((1-p1-p2).*k31))+(p2.*k23-(1-p1-p2).*k32)./log((p2.*k23)./((1-p1-p2).*k32));
ms(1)=0;
m = sum(ms)/(length(ms)-1);

end

function W = wasserstein(p1,p2,p3)

W = abs(p1(1)-p1(end))/2+abs(p2(1)-p2(end))/2 +abs(p3(1)-p3(end))/2;

end