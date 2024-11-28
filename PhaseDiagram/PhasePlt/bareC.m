function sigma = bareC(K12,K13,K32)
    sigma = 0.0653*(K13+K32)/(K12*K13+K32*K13+K12*K32);
end

