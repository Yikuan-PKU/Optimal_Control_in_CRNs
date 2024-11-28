close all;
clear all;
T=30;
global X Y t12 t23 t13;
K12s=[5];
index=0:0.05:6;
K13s=exp(index);
K23s=exp(index);
K12Lth=length(K12s);
K13Lth=length(K13s);
K23Lth=length(K23s);
Ks=zeros(K12Lth*K13Lth*K12Lth,3);
totalCost=zeros(K12Lth*K13Lth*K23Lth,1);
Phasedata.P1Dat=cell(K13Lth,K23Lth);
Phasedata.P2Dat=cell(K13Lth,K23Lth);
Phasedata.P3Dat=cell(K13Lth,K23Lth);
Phasedata.K12Dat=cell(K13Lth,K23Lth);
Phasedata.K21Dat=cell(K13Lth,K23Lth);
Phasedata.K13Dat=cell(K13Lth,K23Lth);
Phasedata.K31Dat=cell(K13Lth,K23Lth);
Phasedata.K23Dat=cell(K13Lth,K23Lth);
Phasedata.K32Dat=cell(K13Lth,K23Lth);
rcd=zeros(K12Lth,K13Lth,K23Lth);
for i=1:1:K12Lth
    for j=1:1:K13Lth
        for k=1:1:K23Lth
            try
                X=linspace(0,T,10);Y=[1+zeros(1,10);1+zeros(1,10);zeros(1,10);zeros(1,10)];
                t12=K12s(i);t13=K13s(j);t23=K23s(k);
                Ks((i-1)*K13Lth*K23Lth+(j-1)*K23Lth+k,1)=K12s(i);
                Ks((i-1)*K13Lth*K23Lth+(j-1)*K23Lth+k,2)=K13s(j);
                Ks((i-1)*K13Lth*K23Lth+(j-1)*K23Lth+k,3)=K23s(k);
                L=fix(t12/10);M=fix(t13/10);N=fix(t23/10);
                if (L>=1) && (M>=1) && (N>=1)
                    mL=mod(t12,10);mM=mod(t13,10);mN=mod(t23,10);
                    t12=10+mL;t13=10+mM;t23=10+mN;
                    for l=1:1:L
                        t12=10*l+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for m=1:1:M
                        t13=10*m+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:N
                        t23=10*n+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                elseif (L>=1) && (M>=1) && (N<1)
                    mL=mod(t12,10);mM=mod(t13,10);mN=mod(t23,1);
                    t12=10;t13=10;t23a=t23;
                    for l=1:1:t23a
                        t23=l+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for m=1:1:L
                        t12=10*m+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:M
                        t13=10*n+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                elseif (L>=1) && (M<1) && (N>=1)
                    mL=mod(t12,10);mM=mod(t13,1);mN=mod(t23,10);
                    t12=10;t23=10;t13b=t13;
                    for l=1:1:t13b
                        t13=l+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for m=1:1:L
                        t12=10*m+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:N
                        t23=10*n+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                elseif (L>=1) && (M<1) && (N<1)
                    mL=mod(t12,10);mM=mod(t13,1);mN=mod(t23,1);
                    t12=10;t13c=t13;t23d=t23;t13=1;t23=1;
                    for l=1:1:t23d
                      t23=l+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for m=1:1:t13c
                       t13=m+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:L
                        t12=10*n+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                elseif (L<1) && (M>=1) && (N>=1)
                    mL=mod(t12,1);mM=mod(t13,10);mN=mod(t23,10);
                    t13=10;t23=10;t12e=t12;
                    for l=1:1:t12e
                      t12=l+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:N
                        t23=10*n+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for m=1:1:M
                        t13=10*m+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                elseif (L<1) && (M>=1) && (N<1)
                    mL=mod(t12,1);mM=mod(t13,10);mN=mod(t23,1);
                    t13=10;t12f=t12;t23g=t23;t12=1;t23=1;
                    for l=1:1:t12f
                        t12=l+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end 
                    for m=1:1:t23g
                        t23=m+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:M
                        t13=10*n+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                elseif (L<1) && (M<1) && (N>=1)
                    mL=mod(t12,1);mM=mod(t13,1);mN=mod(t23,10);
                    t23=10;t12h=t12;t13i=t13;t12=1;t13=1;
                    for l=1:1:t12h
                        t12=l+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end  
                    for m=1:1:t13i
                        t13=m+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:N
                        t23=10*n+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                else
                     mL=mod(t12,1);mM=mod(t13,1);mN=mod(t23,1);
                     t23k=t23;t12h=t12;t13i=t13;t12=1;t13=1;t23=1;
                    for l=1:1:t12h
                        t12=l+mL;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end  
                    for m=1:1:t13i
                        t13=m+mM;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                    for n=1:1:t23k
                        t23=n+mN;
                      sol=NMetric;
                      X=sol.x;
                      Y=sol.y;
                    end
                end
                [t,p] = Ptrajectory(X,Y,T);
                [p1,p2,p3,k12,k21,k13,k31,k23,k32,totalCost((i-1)*K13Lth*K23Lth+(j-1)*K23Lth+k),cost] = Cost(t,p,X,Y,T,t12,t23,t13);
                Phasedata.P1Dat{j,k}=p1;
                Phasedata.P2Dat{j,k}=p2;
                Phasedata.P3Dat{j,k}=p3;
                Phasedata.K12Dat{j,k}=k12;
                Phasedata.K21Dat{j,k}=k21;
                Phasedata.K13Dat{j,k}=k13;
                Phasedata.K31Dat{j,k}=k31;
                Phasedata.K23Dat{j,k}=k23;
                Phasedata.K32Dat{j,k}=k32;
            catch
                rcd(i,j,k)=1;  
            end
       end
   end
end
save('K13s.mat','K13s')
save('K23s.mat','K23s')
save('Phasedata.mat','Phasedata')
save('rcd.mat','rcd')