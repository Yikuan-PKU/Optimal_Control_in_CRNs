clear; close all;
load('Phasedata.mat');
load('K23s.mat');
load('K13s.mat');
[x,y]=meshgrid(log10(K13s/5));
P=zeros(length(K13s));
xc=[];
yc=[];
for i=1:1:length(K13s)
    for j=1:1:length(K13s)
        p1 = Phasedata.P1Dat{i,j};
        p2 = Phasedata.P2Dat{i,j};
        p3 = Phasedata.P3Dat{i,j};
        k12 = Phasedata.K12Dat{i,j};
        k13 = Phasedata.K13Dat{i,j};
        k21 = Phasedata.K21Dat{i,j};
        k31 = Phasedata.K31Dat{i,j};
        k23 = Phasedata.K23Dat{i,j};
        k32 = Phasedata.K32Dat{i,j};
        xx=linspace(0,30,300);
        dxx=xx(2)-xx(1);
        dJ1=dxx.*(p1.*k12-p2.*k21);
        J1=integra(dJ1);     
        P(i,j)=J1(end)/(0.7);
        if P(i,j)<0.507 & P(i,j)>0.499
            xc(end+1) = K13s(i)/5;
            yc(end+1) = K23s(j)/5;
        end
    end

end

imagesc([x(1) x(end)],[x(1) x(end)],P)
X = K13s(33:end)./5;
Y = X./(X-1);
hold on 
plot(log10(X),log10(Y),'k',LineWidth=2)
plot(log10(xc),log10(yc),'r',LineWidth=2)
xlim();
ylim();
xlabel('log(C_{23}/C_{12})')
ylabel('log(C_{13}/C_{12})')
colormap(othercolor('RdGy6'))