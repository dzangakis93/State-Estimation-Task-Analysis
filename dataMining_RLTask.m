
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ ME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A.S. Therrien, 10/2021
%
% This script will run the initial data mining for the center out shooting
% task, with closed loop reinforcement feedback reinforcing a change in
% endpoint angle, as tested on the Kinarm.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GET SET-UP

tic
clear all; clc; close all;
genpath='/Users/amandatherrien/Library/CloudStorage/OneDrive-ThomasJeffersonUniversityanditsAffiliates/Documents - MRRI Sensorimotor Learning Lab/Studies/Ataxia_Kinarm_SSEandRL/';
subj ={'CN16'}; %studyID for subject(s) you wish to analyze
dataFolder = 'StudyData'; %name of folder that contains study data
taskName = {'CLR_BL_&_Pert' 'CLR_Retention'}; %task blocks of interest

% START LOOPING THROUGH SUBJECTS AND TASKS

for ns=1:length(subj)
    
    close all; %close any open figures from previous subject
    
    for nt = 1:length(taskName)
        
        %pull first data structure based on current condition (N.B. may need to
        %edit / direction for Windows
        d=dir(strcat(genpath,'StudyData/RL/',subj{ns},'/data*')); 
        kd=load(strcat(genpath,'StudyData/RL/',subj{ns},'/',d.name));
        k=fieldnames(kd);
        kd=kd.(k{1});
        
        for nkd=1:length(kd)
            
            if (strcmp(taskName{nt},kd(nkd).c3d(1).EXPERIMENT.TASK_PROTOCOL) && length(kd(nkd).c3d)>=100)
                data=kd(nkd).c3d;
            end
            
        end %loop nkd
        
        clear d kd nkd %clear vars to save memory
        
        %initialize variables for memory 
        mdm=zeros(length(data),16);
        handvel=cell(length(data),2);
        handpos=cell(length(data),2);
        flag=[];
        
        for n=1:length(data)
            
            if (length(data(n).EVENTS.LABELS) <3)
                flag=cat(1,flag,n);
                continue
            end

            
            mdm(n,1)=data(n).TRIAL.TRIAL_NUM; %trial number (need b/c Dex doesn't save in order)
            mdm(n,2)=data(n).TRIAL.TP; holdVar=data(n).TRIAL.TP; %TP number, for sanity checking
            mdm(n,3)=data(n).TP_TABLE.Closed_Loop_Reinforcement(holdVar); %was it a CLR trial (1=yes,0=no)
            mdm(n,4)=data(n).TP_TABLE.Start_Target(1); %start target on this trial
            mdm(n,5)=data(n).TARGET_TABLE.X_GLOBAL(mdm(n,4));%start x coord (global)
            mdm(n,6)=data(n).TARGET_TABLE.Y_GLOBAL(mdm(n,4));%start y coord (global)
            mdm(n,7)=data(n).TP_TABLE.End_Target(1); %end target on this trial
            mdm(n,8)=data(n).TARGET_TABLE.X_GLOBAL(mdm(n,7)); %end x coord (global)
            mdm(n,9)=data(n).TARGET_TABLE.Y_GLOBAL(mdm(n,7));%end y coord (global)
            mdm(n,10)=data(n).TP_TABLE.Rotation(holdVar); %target rotation on this trial
            mdm(n,11)=data(n).thetaMean(1); %running avg for CLR on this trial
            mdm(n,12)=data(n).rTheta(end); %reach angle on that trial, recorded through Dex.
            idxaHold=strfind(data(n).EVENTS.LABELS,'HIT_TGT'); 
            idxa=find(not(cellfun('isempty',idxaHold)));
            mdm(n,13)=1; %positive reinforcement
            if isempty(idxa)
                idxHolda=strfind(data(n).EVENTS.LABELS,'MISS_TGT'); 
                idxa=find(not(cellfun('isempty',idxHolda)));
                mdm(n,13)=0; %negative reinforcement
            end
            idxHolda=strfind(data(n).EVENTS.LABELS,'RT'); 
            idxa=find(not(cellfun('isempty',idxHolda)));
            idxStart=round(1000*data(n).EVENTS.TIMES(idxa));
            if mdm(n,13)==1
                idxHoldb=strfind(data(n).EVENTS.LABELS,'HIT_TGT'); 
                idxb=find(not(cellfun('isempty',idxHoldb)));
                idxStop = round(1000*data(n).EVENTS.TIMES(idxb));
            else
                idxHoldb=strfind(data(n).EVENTS.LABELS,'MISS_TGT'); 
                idxb=find(not(cellfun('isempty',idxHoldb)));
                idxStop = round(1000*data(n).EVENTS.TIMES(idxb));
            end
            hvx=data(n).HandVelX2(idxStart:idxStop);%crop hand velocity vector to segment of interest
            hvy=data(n).HandVelY2(idxStart:idxStop);
            mdm(n,14)= max(sqrt(hvx.^2 +hvy.^2)); %peak velocity, in m/s
            mdm(n,15)= mean(sqrt(hvx.^2 + hvy.^2)); %mean velocity, in m/s
            idxHolda = strfind(data(n).EVENTS.LABELS,'TOO_FAST'); 
            idxHoldb = strfind(data(n).EVENTS.LABELS,'TOO_SLOW');
            idxa = find(not(cellfun('isempty',idxHolda)));
            idxb = find(not(cellfun('isempty',idxHoldb)));
            if (~isempty(idxa))   
                mdm(n,16) = 2; %speed was too fast
            elseif (~isempty(idxb))
                mdm(n,16) = 3; %speed was too slow
            else
                mdm(n,16) = 1; %speed was just right
            end
            
            %cropped velocity and cropped hand postion for plotting later
            handvel{mdm(n,1),1}=hvx;
            handvel{mdm(n,1),2}=hvy;
            handpos{mdm(n,1),1}=data(n).HandX(idxStart:idxStop);
            handpos{mdm(n,1),2}=data(n).HandY(idxStart:idxStop);
            
        end %loop n
        
        %delete trials that were repeated
        mdm(flag,:)=[];
        handvel(flag,:)=[];
        handpos(flag,:)=[];        
        
        %sort mdm by trial number in case out of order
        mdm=sortrows(mdm,1);
        
        %structure for saving
        if (strcmp(taskName{nt},'CLR_BL_&_Pert'))
            BLandPert.mdm=mdm;
            BLandPert.handpos=handpos;
            BLandPert.handvel=handvel;
        else %retention
            Retention.mdm=mdm;
            Retention.handpos=handpos;
            Retention.handvel=handvel;
        end 
        
        clear data mdm handvel handpos
        
    end %loop nt
    
    %structure for saving
    RL.BLandPert=BLandPert;
    RL.Retention=Retention;
    
    clear Practice BLandPert Retention

    %generate figures
    c1=colormap(jet(10));
    c2=colormap(jet(60));
    c3=colormap(jet(180));
    c4=colormap(jet(100));
    numvf=10;
    numbl=numvf+60;
    numpert=numbl+180;
    acc=5.75;
    
    figure(1) %hand trajectories
    subplot(1,4,1); xlim([-5 5]); ylim([-5 15]); title('Visual Fdbk')
    subplot(1,4,2); xlim([-5 5]); ylim([-5 15]); title('Baseline')
    subplot(1,4,3); xlim([-5 5]); ylim([-5 15]); title('CLR')
    subplot(1,4,4); xlim([-5 5]); ylim([-5 15]); title('Retention')
    for nf=1:(length(RL.BLandPert.handpos))+(length(RL.Retention.handpos))
        if nf<=numvf
            subplot(1,4,1) 
            hold on
            plot(RL.BLandPert.handpos{nf,1}.*100-RL.BLandPert.mdm(nf,5),...
                RL.BLandPert.handpos{nf,2}.*100-RL.BLandPert.mdm(nf,6),...
                'LineWidth',1,...
                'Color',c1(nf,:))
        elseif nf>numvf && nf<=numbl
            subplot(1,4,2)
            hold on
            plot(RL.BLandPert.handpos{nf,1}.*100-RL.BLandPert.mdm(nf,5),...
                RL.BLandPert.handpos{nf,2}.*100-RL.BLandPert.mdm(nf,6),...
                'LineWidth',1,...
                'Color',c2(nf-numvf,:))
        elseif nf>numbl && nf<=numpert
            subplot(1,4,3)
            hold on
            plot(RL.BLandPert.handpos{nf,1}.*100-RL.BLandPert.mdm(nf,5),...
                RL.BLandPert.handpos{nf,2}.*100-RL.BLandPert.mdm(nf,6),...
                'LineWidth',1,...
                'Color',c3(nf-numbl,:))
        elseif  nf>numpert
            subplot(1,4,4)
            hold on
            plot(RL.Retention.handpos{nf-numpert,1}.*100-RL.Retention.mdm(nf-numpert,5),...
                RL.Retention.handpos{nf-numpert,2}.*100-RL.Retention.mdm(nf-numpert,6),...
                'LineWidth',1,...
                'Color',c4(nf-numpert,:))
        end
    end %loop nf
    
    figure(2) %reach angle with feedback
    hold on
    xlim([0 350])
    xlabel('trial')
    ylim([-30 30])
    ylabel('reach angle (deg)')
    plot(RL.BLandPert.mdm(:,1),RL.BLandPert.mdm(:,10)+acc,'k-','LineWidth',1)
    plot(RL.BLandPert.mdm(:,1),RL.BLandPert.mdm(:,10)-acc,'k-','LineWidth',1)
    plot(RL.Retention.mdm(:,1)+numpert,RL.Retention.mdm(:,10)+acc,'k-','LineWidth',1)
    plot(RL.Retention.mdm(:,1)+numpert,RL.Retention.mdm(:,10)-acc,'k-','LineWidth',1)
    g=find(RL.BLandPert.mdm(:,13)==1);
    r=find(RL.BLandPert.mdm(:,13)==0);
    scatter(RL.BLandPert.mdm(g,1),RL.BLandPert.mdm(g,12),50,'g')
    scatter(RL.BLandPert.mdm(r,1),RL.BLandPert.mdm(r,12),50,'r')
    scatter(RL.Retention.mdm(:,1)+numpert,RL.Retention.mdm(:,12),50,'k')
    plot(RL.BLandPert.mdm(70:end,1),RL.BLandPert.mdm(70:end,11),'b','LineWidth',2)
    plot([numbl numbl],[-30 30],'k--','LineWidth',1)
    plot([numpert numpert],[-30 30],'k--','LineWidth',1)
    
    figure(3) %peak velocity
    hold on
    xlim([0 350])
    xlabel('trial')
    ylim([0 0.6])
    ylabel('peak velocity (m/s)')
    k=find(RL.BLandPert.mdm(:,16)==1);
    kr=find(RL.Retention.mdm(:,16)==1);
    b=find(RL.BLandPert.mdm(:,16)==2);
    br=find(RL.Retention.mdm(:,16)==2);
    m=find(RL.BLandPert.mdm(:,16)==3);
    mr=find(RL.Retention.mdm(:,16)==3);
    scatter(RL.BLandPert.mdm(k,1),RL.BLandPert.mdm(k,14),50,'k')
    scatter(RL.Retention.mdm(kr,1)+numpert,RL.Retention.mdm(kr,14),50,'k')
    scatter(RL.BLandPert.mdm(b,1),RL.BLandPert.mdm(b,14),50,'k')
    scatter(RL.Retention.mdm(br,1)+numpert,RL.Retention.mdm(br,14),50,'k')
    scatter(RL.BLandPert.mdm(m,1),RL.BLandPert.mdm(m,14),50,'k')
    scatter(RL.Retention.mdm(mr,1)+numpert,RL.Retention.mdm(mr,14),50,'k')
    
     %save all the things
    path=strcat(genpath,'AnalysisOutputs/',subj{ns}); %set path for saving 
    figpath=strcat(genpath,'AnalysisOutputs/',subj{ns},'/Figures');
    if (~isfolder(path)) %check if path exists
        mkdir(path); %if not,  make the necessary folders
    end
     if(~isfolder(figpath))
        mkdir(figpath);
    end
    save(strcat(path,'/RL.mat'),'RL') %save final structure
    saveas(figure(1),strcat(figpath,'/RL_handtrajs.fig'))
    saveas(figure(1),strcat(figpath,'/RL_handtrajs.pdf'))
    saveas(figure(2),strcat(figpath,'/RL_rtheta.fig'))
    saveas(figure(2),strcat(figpath,'/RL_rtheta.pdf'))
    saveas(figure(3),strcat(figpath,'/RL_hand_peakvel.fig'))
    saveas(figure(3),strcat(figpath,'/RL_hand_peakvel.pdf'))
    
end %loop ns
toc