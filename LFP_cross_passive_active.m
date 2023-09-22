clearvars; close all; %addpath(genpath('C:\Users\fedu1\Downloads\sigTOOL'))
load(['Z:\locker\2FISH\20210330\20210330_002.mat']);
EODtime=V20210330_002_Ch2.values;  Data=V20210330_002_Ch3.values; MINVAL1=[]; MINVAL2=[]; events=V20210330_002_Ch31.times;
 
 
 [value3,sample3]=findpeaks(EODtime ,'MINPEAKHEIGHT',0.01,'MINPEAKDISTANCE',20);     
 [value4,sample4]=findpeaks(EODtime ,'MINPEAKHEIGHT',0.043,'MINPEAKDISTANCE',20);
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
timeEOD1=sample4/20000; timeEOD2=sample3/20000; 

for p=1:size(timefish1,2)
    [idx2,idx]=min(abs(timefish2-timefish1(p)));
    if timefish2(idx)<timefish1(p)
        if timefish2(idx+1)<timefish1(p)
            minval1(p)=peakfish2(idx+2);
            timeval1(p)=timefish2(idx+2)-timefish1(p);
        else
            minval1(p)=peakfish2(idx+1);
            timeval1(p)=timefish2(idx+1)-timefish1(p);
        end
    else
        minval1(p)=peakfish2(idx);
        timeval1(p)=timefish2(idx)-timefish1(p);
    end
end

for p=1:size(timefish2,2)
    [idx2,idx]=min(abs(timefish1-timefish2(p)));
    if timefish1(idx)<timefish2(p)
        if timefish1(idx+1)<timefish2(p)
            minval2(p)=peakfish1(idx+2);
            timeval2(p)=timefish1(idx+2)-timefish2(p);
        else
            minval2(p)=peakfish1(idx+1);
            timeval2(p)=timefish1(idx+1)-timefish2(p);
        end
    else
        minval2(p)=peakfish1(idx);
        timeval2(p)=timefish1(idx)-timefish2(p);
    end
end
figure; plot(timeval1,minval1,'.r'); figure; plot(timeval2,minval2,'.b')
%%
timefish1=timeEOD1; timefish2=timeEOD2; 
for p=1:size(timefish1,2)
    [idx2,idx]=min(abs(timefish2-timefish1(p)));
    if timefish2(idx)<timefish1(p)
        if timefish2(idx+1)<timefish1(p)
            minval1(p)=peakfish2(idx+2);
            timeval1(p)=timefish2(idx+2)-timefish1(p);
        else
            minval1(p)=peakfish2(idx+1);
            timeval1(p)=timefish2(idx+1)-timefish1(p);
        end
    else
        minval1(p)=peakfish2(idx);
        timeval1(p)=timefish2(idx)-timefish1(p);
    end
end

for p=1:size(timefish2,2)
    [idx2,idx]=min(abs(timefish1-timefish2(p)));
    if timefish1(idx)<timefish2(p)
        if timefish1(idx+1)<timefish2(p)
            minval2(p)=peakfish1(idx+2);
            timeval2(p)=timefish1(idx+2)-timefish2(p);
        else
            minval2(p)=peakfish1(idx+1);
            timeval2(p)=timefish1(idx+1)-timefish2(p);
        end
    else
        minval2(p)=peakfish1(idx);
        timeval2(p)=timefish1(idx)-timefish2(p);
    end
end
figure; plot(timeval1,minval1,'.r'); figure; plot(timeval2,minval2,'.b')