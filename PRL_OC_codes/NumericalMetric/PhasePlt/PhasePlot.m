clear; close all;
load('Phasedata.mat');
load('K23s.mat');
load('K13s.mat');
[x,y]=meshgrid(log10(K13s/5));
P=zeros(length(K13s));
for i=1:1:length(K13s)
    for j=1:1:length(K13s)
        a=sort(Phasedata.P1Dat{i,j});
        p1min=a(1);
        p1max=a(end);
        b=sort(Phasedata.P2Dat{i,j});
        p2min=b(1);
        p2max=b(end);
        c=sort(Phasedata.P3Dat{i,j});
        p3min=c(1);
        p3max=c(end);
        p3average = mean(c);
        P(i,j)=1;%(p3average-0.1)/0.1;
        if (p1min<0.098)
            P(i,j)=2;%1*(0.1-p1min)/0.1;
        elseif (p2min<0.098)
            P(i,j)=2;%1*(0.1-p2min)/0.1;
        elseif (p3min<0.099)
                P(i,j)=3;%1*(0.1-p3average)/0.1;
                if (p3min<0.099&&p3max>0.105)
                    P(i,j)=4;%1*mean(abs(c-0.1))/0.1;
                end
        end                
    end
end
imagesc([x(1) x(end)],[x(1) x(end)],P)
X = K13s(33:end)./5;
Y = X./(X-1);
hold on 
plot(log10(X),log10(Y),'k',LineWidth=2)
xlim();
ylim();
xlabel('log(C_{23}/C_{12})')
ylabel('log(C_{13}/C_{12})')
colormap(othercolor('RdGy6'))