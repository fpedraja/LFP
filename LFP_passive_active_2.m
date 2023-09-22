clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3]; j=2;
%%
clearvars; cd('D:\KIT'); addpath('D:\KIT3'); addpath('D:\KIT2');
direfinal=uigetdir('Z:\locker\2FISH\'); %3D data
files2=dir([direfinal, '\*.mat']);
vidnum=[1 2 3 4]; j=2;
%%


load([direfinal, '\', files2(vidnum(j)).name])
EODtime=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch2.values']);
CMDtrig=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch1.times']);
Spikes=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch3.values']);
Events=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch31.times']);
Events_Name=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch31.codes']);
Stim=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch4.values']);
interval=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch3.interval']);
len=eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch3.length']);
time=0:interval:len*interval-interval;

clearvars -except  EODtime CMDtrig Spikes Events Events_Name Stim time

%     figure; plot(time,Spikes,'-b')

% secondfish=1/eval(['V',files2(vidnum(j)).name(1:end-4),'_Ch5.interval']);

[value2,sample2]=findpeaks(Stim ,'MINPEAKHEIGHT',1,'MINPEAKDISTANCE',50);
figure; plot(time,Stim,'-b'); hold on; plot(time(sample2),Stim(sample2),'ok')

Stim_time=time(sample2); Stim_val=Stim(sample2);

STIMname=[66 67 68 84 85 86 71 74 78 79];
%%
for t=1:size(STIMname,2)
    %%
    [b,~]=find(Events_Name(:,1)==STIMname(t));
    AUX2=[];
    for i=1:size(b,1)
        AUX=[];
        if b(i)<size(Events,1)
            AUX=CMDtrig(CMDtrig>=Events(b(i))&CMDtrig<Events(b(i)+1));
        else
            AUX=CMDtrig(CMDtrig>=Events(b(i)));
        end
        AUX2=[AUX2;AUX]; %time of each cmd triger for the condition STIMname(t)
    end
    clear AUX
    
    if t==1
        for k=1:size(AUX2,1)-1
            Spike_CMD(1,k)=size(Spike_time(Spike_time>AUX2(k)&Spike_time<AUX2(k)+0.1),2); % count spikes after last Stim and before 100ms
        end
        Spike_justCMD=mean(Spike_CMD);
    end
        
        a=1; AUX3=[]; AUX4=[];
        for k=1:size(AUX2,1)
            try
                AUX3(a,1:2)=Stim_time(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05); %check the time for first, second or both Stims
                AUX4(a,1:2)=Stim_val(Stim_time>=AUX2(k)&Stim_time<=AUX2(k)+0.05);  %check the amplitude for first, second or both Stims
                a=a+1;
            end
        end
        Delay=diff(AUX3')'; DelayCMD=diff([AUX2, AUX3(:,1)]')';  LFP_num=[];
        
        for k=1:size(AUX3,1)
            LFP_num(k,1)=min(Spikes(time>AUX3(k,1)+0.00258&time<AUX3(k,1)+0.0048));
            LFP_num(k,2)=min(Spikes(time>AUX3(k,2)&time<AUX3(k,2)+0.0055));% count spikes after last Stim and before 100ms
        end
        
        
        
        %             figure; plot(AUX4(:,2),Spike_num,'.r'); hold on; plot(AUX4(:,1),Spike_num,'.b');
        figure; hist3([AUX4(:,2), LFP_num(:,2)],'Nbins',[15 15],'CDataMode','auto','FaceColor','interp'); % for second stim if exist
        figure; hist3([AUX4(:,1), LFP_num(:,1)],'Nbins',[15 15],'CDataMode','auto','FaceColor','interp'); % for first stim if exist (first stim, just second stim or both)
        
                
       
        if t==10
            xbins=2:0.1:5.1;  % BinBorders for xDimension
            ybins=[0.004 0.005 0.012 0.014 0.025 0.035];
            sds=[]; sds2=[];
            for x=1:size(xbins,2)-1
                for y=1:size(ybins,2)
                    temp=LFP_num(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x+1) & Delay>=ybins(y) & Delay<=ybins(y)+0.0008 & DelayCMD<0.01,2);
                    if length(temp)>=5
                        sds(x,y)= nanmean(temp);
                    else
                        sds(x,y)=NaN;
                    end
                    temp2=LFP_num(AUX4(:,1)>=xbins(x) & AUX4(:,1)<xbins(x+1) & Delay>=ybins(y) & Delay<=ybins(y)+0.0008 & DelayCMD<0.01,1);
                    if length(temp2)>=5
                        sds2(x,y)=nanmean(temp2);
                    else
                        sds2(x,y)=NaN;
                    end
                end
            end
            Data_04=sds(1:end-1,1); Data_05=sds(1:end-1,2); Data_12=sds(1:end-1,3);
            Data_14=sds(1:end-1,4); Data_25=sds(1:end-1,5); Data_35=sds(1:end-1,6);
            tbins=xbins(1:end-2);
            figure;
            for i=1:6
                try
                    [xData, yData] = prepareCurveData( tbins, sds(1:end-1,i) );
                    
                    % Set up fittype and options.
                    ft = fittype( 'poly2' );
                    opts = fitoptions( 'Method', 'LinearLeastSquares' );
                    opts.Robust = 'Bisquare';
                    
                    % Fit model to data.
                    [fitresult, gof] = fit( xData, yData, ft, opts );
                    
                    % Plot fit with data.
%                     figure( 'Name', 'untitled fit 1' );
                    h = plot( fitresult,'-k'); hold on; plot(xData, yData,'ok','MarkerFaceColor',[i/6,i/6,0])
                end
            end
        else
            xbins=2:0.1:5.1;  % BinBorders for xDimension
            sds=[]; sds2=[];
            for x=1:size(xbins,2)-1
                temp= LFP_num(AUX4(:,2)>=xbins(x) & AUX4(:,2)<xbins(x+1),2);
                if length(temp)>=5
                    sds(x)= nanmean(temp);
                else
                    sds(x)=NaN;
                end
                temp2= LFP_num(AUX4(:,1)>=xbins(x) & AUX4(:,1)<xbins(x+1),1);
                if length(temp2)>=5
                    sds2(x)=nanmean(temp2);
                else
                    sds2(x)=NaN;
                end
            end
            tbins=xbins(1:end-2);
            Data_1=sds2(1:end-1); Data_2=sds(1:end-1);
            figure; plot(tbins,Data_2,'or'); hold on; plot(tbins,Data_1,'ob');
            
        end
end