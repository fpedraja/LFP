clearvars; close all; %addpath(genpath('C:\Users\fedu1\Downloads\sigTOOL'))
load(['Z:\locker\2FISH\20210330\20210330_002.mat']);
EODtime=V20210330_002_Ch2.values;  Data=V20210330_002_Ch3.values; MINVAL1=[]; MINVAL2=[]; events=V20210330_002_Ch31.times;
 
 
 [value3,sample3]=findpeaks(EODtime ,'MINPEAKHEIGHT',0.01,'MINPEAKDISTANCE',200);     
 [value4,sample4]=findpeaks(EODtime ,'MINPEAKHEIGHT',0.043,'MINPEAKDISTANCE',200);
 figure;  plot(EODtime);  hold on; plot(sample3,value3,'or'); hold on; plot(sample4,value4,'ob');

 for t=1:size(sample3,1)
    [~,AUX]=min(Data(sample3(t)+15:sample3(t)+100));
    MINVAL1(t)=AUX+sample3(t)+14;
 end 
  for t=1:size(sample4,1)
    [~,AUX]=min(Data(sample4(t)+15:sample4(t)+100));
    MINVAL2(t)=AUX+sample4(t)+14;
  end
 for k=1:size(sample4,1)
     MINVAL1(sample3(:)==sample4(k))=[];
     sample3(sample3(:)==sample4(k))=[];
 end
 
figure; plot(Data); hold on; plot(MINVAL1,Data(MINVAL1),'or'); hold on; plot(MINVAL2,Data(MINVAL2),'ob');
hold on; plot(sample3,Data(sample3),'oy'); hold on; plot(sample4,Data(sample4),'ok');

timefish2=MINVAL1/20000; peakfish2=Data(MINVAL1); 
timefish1=MINVAL2/20000; peakfish1=Data(MINVAL2);

for p=1:size(timefish1,2)
    if sum(timefish1(p)-timefish2<=0.030 & timefish1(p)-timefish2>=0)==1
        peakfish1(p)=nan;
    end
end

for p=1:size(timefish2,2)
    if sum(timefish2(p)-timefish1<=0.030 & timefish2(p)-timefish1>=0)==1
        peakfish2(p)=nan;
    end
end


for i=1:size(events,1)
    if i<size(events,1)
        fish1(i)=nanmean(peakfish1(timefish1>=events(i)&timefish1<=events(i+1)));
        fish2(i)=nanmean(peakfish2(timefish2>=events(i)&timefish2<=events(i+1)));
    else
        fish1(i)=nanmean(peakfish1(timefish1>=events(i)&timefish1<=size(Data,1)/20000));
        fish2(i)=nanmean(peakfish2(timefish2>=events(i)&timefish2<=size(Data,1)/20000));
    end
end


%% 2021_03_30_006
figure; plot([0 1 2 4],[fish1(1)-fish1(3) fish1(5)-fish1(6) fish1(2)-fish1(3) fish1(4)-fish1(3)],'-ob');
hold on; plot([0 1 2 4],[fish2(1)-fish2(3) fish2(5)-fish2(6) fish2(2)-fish2(3) fish2(4)-fish2(3)],'-or');

x=[0.1 1 2 4]; y1=[fish1(1)-fish1(3) fish1(5)-fish1(6) fish1(2)-fish1(3) fish1(4)-fish1(3)]; 
y2=[fish2(1)-fish2(3) fish2(5)-fish2(6) fish2(2)-fish2(3) fish2(4)-fish2(3)];
%% 2021_03_30_005
figure; plot([0 2],[fish1(3)-fish1(1) fish1(4)-fish1(5)],'-ob');
hold on; plot([0 2],[fish2(3)-fish2(1) fish2(4)-fish2(5)],'-or');
%% 2021_03_30_004
figure; plot([0 2],[mean([fish1(3)-fish1(1) fish1(7)-fish1(5)]) mean([fish1(4)-fish1(5)  fish1(8)-fish1(5)])],'-ob');
hold on; plot([0 2],[mean([fish2(3)-fish2(1) fish2(7)-fish2(5)]) mean([fish2(4)-fish2(5)  fish2(8)-fish2(5)])],'-or');
%% 2021_03_30_003
figure; plot([5 10 15],[fish1(2)-fish1(1) fish1(3)-fish1(1) fish1(5)-fish1(4) ],'-ob');
hold on; plot([5 10 15],[fish2(2)-fish2(1) fish2(3)-fish2(1) fish2(5)-fish2(4)],'-or');
%% 2021_03_30_002
figure; plot([5 10 15 20],[fish1(4)-fish1(1) fish1(5)-fish1(6) fish1(9)-fish1(6) fish1(10)-fish1(11)],'-ob');
hold on; plot([5 10 15 20],[fish2(4)-fish2(1) fish2(5)-fish2(6) fish2(9)-fish2(6) fish2(10)-fish2(11)],'-or');
x=[5 10 15 20]; y1=[fish1(4)-fish1(1) fish1(5)-fish1(6) fish1(9)-fish1(6) fish1(10)-fish1(11)];
y2=[fish2(4)-fish2(1) fish2(5)-fish2(6) fish2(9)-fish2(6) fish2(10)-fish2(11)];