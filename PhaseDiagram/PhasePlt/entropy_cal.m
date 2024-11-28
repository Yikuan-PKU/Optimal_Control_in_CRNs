function cost = entropy_cal(p1,p2,k12,k21,k13,k31,k23,k32,T)

cost = T*sum((p1.*k12-p2.*k21).*log((p1.*k12)./(p2.*k21))+(p1.*k13-(1-p1-p2).*k31).*log((p1.*k13)./((1-p1-p2).*k31))+(p2.*k23-(1-p1-p2).*k32).*log((p2.*k23)./((1-p1-p2).*k32)))/length(p1);

end

