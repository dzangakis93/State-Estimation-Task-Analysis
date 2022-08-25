
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ ME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% A.S. Therrien, 10/2021
%
% This script will run the initial data mining for the SSE task, as tested 
% on the Kinarm. The script should be located one level up from the 
% 'StudyData'folder. It calls the custom function(s) listed below. Make 
% sure the file path to the 'Resources-Matlab' folder on the lab OneDrive 
% is saved in your MATLAB path.
%
% CUSTOM FUNCTION(S) CALLED:
%   FitPsycheCurveLogit
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% GET SET-UP 
tic
clearvars; clc; close all;
genpath='/Users/amandatherrien/Library/CloudStorage/OneDrive-ThomasJeffersonUniversityanditsAffiliates/Documents - MRRI Sensorimotor Learning Lab/Studies/Ataxia_Kinarm_SSEandRL/';
subj ={'CB14'}; %studyID for subject(s) you wish to analyze
dataFolder = 'StudyData'; %name of folder that contains study data
condFolder = {'SSE_Dynamic' 'SSE_Endpoint'}; %task condition(s) you wish to analyze
taskName =  {'Pas' 'Act'}; %task(s) you wish to analyze 

% START LOOPING THROUGH SUBJECTS, CONDITIONS, AND TASKS 

for ns=1:length(subj) %loop through each subject
    
    close all %close any figures between subjects
    
    for nc=1:length(condFolder) %loop through each condition        
        
       for nt=1:length(taskName) %loop through each task, within condition

            %pull first data structure based on current condition
            d=dir(strcat(genpath,'StudyData/',condFolder{nc},'/',subj{ns},'/170/data*')); 
            kd=load(strcat(genpath,'StudyData/',condFolder{nc},'/',subj{ns},'/170/',d.name));
            k=fieldnames(kd);
            kd=kd.(k{1});
            for nkd=1:length(kd) %extract desired structure field based on current task

                if (strncmp(taskName{nt},kd(nkd).c3d(1).EXPERIMENT.TASK_PROTOCOL,3))
                    data=kd(nkd).c3d;
                end

            end %loop nkd
            
            clear d kd nkd %clear vars to save memory

            %initialize variables for memory 
            mdm=zeros(170,17);
            handvel=cell(170,2);
            handpos=cell(170,2);
            log=[];

            for n=1:length(data) %loop through each trial, within task

                %for mdm, each trial is a row and values are assigned to each column
                mdm(n,1)=data(n).TRIAL.TRIAL_NUM(1); %trial number (need b/c Dex doesn't save in order)
                mdm(n,2)=data(n).TRIAL.TP(1); holdVar=data(n).TRIAL.TP(1); %TP number, for sanity checking
                mdm(n,3)=data(n).AorP(end); %active or passive, for sanity checking
                mdm(n,4)=data(n).DorE(end); %dynamic or endpont, for sanity checking
                mdm(n,5)=data(n).TP_TABLE.Start_Target(1); %start target on this trial
                mdm(n,6)=data(n).TARGET_TABLE.X_GLOBAL(mdm(n,5));%start x coord (global)
                mdm(n,7)=data(n).TARGET_TABLE.Y_GLOBAL(mdm(n,5));%start y coord (global)
                mdm(n,8)=data(n).TP_TABLE.End_Target(1); %end target on this trial
                mdm(n,9)=data(n).TARGET_TABLE.X_GLOBAL(mdm(n,8)); %end x coord (global)
                mdm(n,10)=data(n).TARGET_TABLE.Y_GLOBAL(mdm(n,8));%end y coord (global)
                mdm(n,11)=data(n).TP_TABLE.Probe(holdVar); %Proble location on this trial
                mdm(n,12)=data(n).randShift(end); %Shift applied on this trial

                a = strfind(data(n).EVENTS.LABELS,'TASK_BUTTON_4_CLICKED'); %subject response and if correct 
                b = strfind(data(n).EVENTS.LABELS,'TASK_BUTTON_5_CLICKED'); 
                idxa=find(not(cellfun('isempty',a)));
                idxb=find(not(cellfun('isempty',b)));
                if ~isempty(idxa) 
                    mdm(n,13)=4; %subject responded ahead
                elseif ~isempty(idxb) 
                    mdm(n,13)=5; %subject responded behind
                end
                if isempty(idxa) && isempty(idxb)
                    error('Task Button Event Code Not Found')
                    %log=cat(1,log,mdm(n,1));
                end

                if strcmp(taskName{nt},'Act') %if active task, pull movement speed and if within desired range.
                    idxHoldA=strfind(data(n).EVENTS.LABELS,'Move to End'); 
                    idxa=find(not(cellfun('isempty',idxHoldA)));
                    idxHoldB=strfind(data(n).EVENTS.LABELS,'Robot Hold at End'); 
                    idxb=find(not(cellfun('isempty',idxHoldB)));
                    if isempty(idxa)|| isempty(idxb)
                        error('Start or Stop Event Code(s) Not Found')
                    end
                    idxStart=round(1000*data(n).EVENTS.TIMES(idxa));
                    idxStop = round(1000*data(n).EVENTS.TIMES(idxb));
                    hvx=data(n).HandVelocityX(idxStart:idxStop);%crop hand velocity vector to segment of interest
                    hvy=data(n).HandVelocityY(idxStart:idxStop);
                    mdm(n,14)= max(sqrt(hvx.^2 +hvy.^2)); %peak velocity, in m/s
                    mdm(n,15)= mean(sqrt(hvx.^2 + hvy.^2)); %mean velocity, in m/s 
                    a = strfind(data(n).EVENTS.LABELS,'Too Fast'); 
                    b = strfind(data(n).EVENTS.LABELS,'Too Slow'); 
                    c = strfind(data(n).EVENTS.LABELS,'Just Right');
                    idxa = find(not(cellfun('isempty',a)));
                    idxb = find(not(cellfun('isempty',b)));
                    idxc = find(not(cellfun('isempty',c)));
                    if (~isempty(idxc))   
                        mdm(n,16) = 1; %speed was just right
                    elseif (~isempty(idxa))
                        mdm(n,16) = 2; %speed was too fast
                    elseif (~isempty(idxb))
                        mdm(n,16) = 3; %speed was too slow
                    end
                    
                    %Accuracy 1 = accurate 0 inaccurate
                    if (mdm(n,12)>0 && mdm(n,13) ==4)
                        mdm(n,17) = 1;
                    elseif (mdm(n,12)>0 && mdm(n,13) ==5)
                        mdm(n,17) = 0;
                    end
                    
                     if (mdm(n,12)<0 && mdm(n,13) ==5)
                        mdm(n,17) = 1;
                    elseif (mdm(n,12)<0 && mdm(n,13) ==4)
                        mdm(n,17) = 0;
                    end

                    %cropped velocity and cropped hand postion for plotting later
                    handvel{mdm(n,1),1}=hvx;
                    handvel{mdm(n,1),2}=hvy;
                    handpos{mdm(n,1),1}=data(n).HandPositionX(idxStart:idxStop);
                    handpos{mdm(n,1),2}=data(n).HandPositionY(idxStart:idxStop);
                end %for passive task, values remain at zero b/c speed and position are controlled

            end %loop n

            %sort mdm by trial number in case out of order
            mdm=sortrows(mdm,1);

            %compile information for psychometric curve
            p=mdm(:,[12,13]); %pull out shift and responses from mdm
            p=sortrows(p,1); %group by shift value
            shifts=zeros(1,17);
            for np=1:17 %loop through number of shift values
                count=find(p(np*10-9:np*10,2)==4); %find 'ahead' responses
                pahead(1,np)=length(count)/10; %number of ahead resonses / total in bin [10]
                shifts(np)=p(np*10,1);
            end %loop x
            %fit psychometric curve            
            [coeffs, curve, stats] = FitPsycheCurveLogit(shifts, pahead, ones(17,1));
            
            %get info for probe/prahead scatter
            o=mdm(:,[11,13]);%pull out probe location and responses
            o=sortrows(o,[1,2]);%sort by probe location
            probe=zeros(1,5);
            for no=1:5 %loop through number of probe locations
                 count=find(o(no*34-33:no*34,2)==4);%Will need to change to (no*34-33:no*34,2)
                 prahead(1,no)=length(count)/34; %change 22 to 34
                 probe(no)=o(no*34,1); %change 22 to 34
            end 
            
            %structure for saving
            if (strcmp(taskName{nt},'Pas'))
                passive.mdm=mdm;
                passive.handvel=handvel;
                passive.handpos=handpos;
                passive.psycurve={coeffs,curve,stats,shifts',pahead'};
                passive.prahead=prahead;
                passive.probe=probe;
            else
                active.mdm=mdm;
                active.handvel=handvel;
                active.handpos=handpos;
                active.psycurve={coeffs,curve,stats,shifts',pahead'};
                active.prahead=prahead;
                active.probe=probe;
            end
            
            clear data mdm handvel handpos p coeffs curve stats probe prahead o 
        
        end %loop nt

        %structure for saving (need to build in some checks)
        if (strcmp(condFolder{nc},'SSE_Dynamic'))
            dynamic.passive=passive;
            dynamic.active=active;
        else
            endpoint.passive=passive;
            endpoint.active=active;
        end
        
        clear passive active
    
    end %loop nc
    
    %final structure for saving
    sse.dynamic=dynamic;
    sse.endpoint=endpoint;
    
    clear dynamic endpoint
    
    %generate figures
    figure(1) %figure of passive endpoint
    hold on
    plot(sse.endpoint.passive.psycurve{1,2}(:,1),sse.endpoint.passive.psycurve{1,2}(:,2),'b','LineWidth',1)
    scatter(sse.endpoint.passive.psycurve{1,4},sse.endpoint.passive.psycurve{1,5},50,'b','filled')
    ylim([0 1])
    ylabel('probability of ahead')
    xlim([-100 100])
    xlabel('shift (mm)')
    title('Endpoint - Passive')
    
    figure(2) %figure of passive dynamic
    hold on
    plot(sse.dynamic.passive.psycurve{1,2}(:,1),sse.dynamic.passive.psycurve{1,2}(:,2),'b','LineWidth',1)
    scatter(sse.dynamic.passive.psycurve{1,4},sse.dynamic.passive.psycurve{1,5},50,'b','filled')
    ylim([0 1])
    ylabel('probability of ahead')
    xlim([-100 100])
    xlabel('shift (mm)')
    title('Dynamic - Passive')
    
    figure(3) %figure of active endpoint
    hold on
    plot(sse.endpoint.active.psycurve{1,2}(:,1),sse.endpoint.active.psycurve{1,2}(:,2),'b','LineWidth',1)
    scatter(sse.endpoint.active.psycurve{1,4},sse.endpoint.active.psycurve{1,5},50,'b','filled')
    ylim([0 1])
    ylabel('probability of ahead')
    xlim([-100 100])
    xlabel('shift (mm)')
    title('Endpoint - Active')
    
    figure(4) %figure of active dynamic
    hold on
    plot(sse.dynamic.active.psycurve{1,2}(:,1),sse.dynamic.active.psycurve{1,2}(:,2),'b','LineWidth',1)
    scatter(sse.dynamic.active.psycurve{1,4},sse.dynamic.active.psycurve{1,5},50,'b','filled')
    ylim([0 1])
    ylabel('probability of ahead')
    xlim([-100 100])
    xlabel('shift (mm)')
    title('Dynamic - Active')
    
    figure(5) %figure of hand trajecotries in active tasks
    subplot(1,2,1)
    hold on
    for nf=1:170
        plot(sse.endpoint.active.handpos{nf,1}*100-sse.endpoint.active.mdm(nf,6),...
            sse.endpoint.active.handpos{nf,2}*100-sse.endpoint.active.mdm(nf,7),'k')
    end
    xlim([-3 3])
    ylim([-5 25])
    title('Endpoint-Active')
    subplot(1,2,2)
    hold on
    for nf=1:170
        plot(sse.dynamic.active.handpos{nf,1}*100-sse.dynamic.active.mdm(nf,6),...
            sse.dynamic.active.handpos{nf,2}*100-sse.dynamic.active.mdm(nf,7),'k')
    end
    xlim([-3 3])
    ylim([-5 25])
    title('Dynamic-Active')
    
    figure(6)%scatter of probes vs probability ahead
    hold on
    scatter(sse.dynamic.active.probe,sse.dynamic.active.prahead,60,'b','filled');
    scatter(sse.dynamic.passive.probe,sse.dynamic.passive.prahead,60,'b');
    scatter(sse.endpoint.active.probe,sse.endpoint.active.prahead,30,'r','filled');
    scatter(sse.endpoint.passive.probe,sse.endpoint.passive.prahead,30,'r');
    ylim([0,1])
    xlim([5,9])
    title('Probability of Ahead by Probe Location')
    xlabel('Probe Location')
    ylabel('Probability of Ahead')
    
    figure(7)
    hold on
    scatter(sse.endpoint.active.mdm(:,15),sse.endpoint.active.mdm(:,17))
    xlabel('Mean Vel (m/s)')
    ylabel('Accuracy')
    title('Endpoint Mean Vel vs Accuracy')
    ylim([-2,2])
    xlim([0,0.5])
    
    figure(8)
    hold on
    scatter(sse.endpoint.active.mdm(:,14),sse.endpoint.active.mdm(:,17))
    xlabel('Peak Vel (m/s)')
    ylabel('Accuracy')
    title('Endpoint Peak Vel vs Accuracy')
    ylim([-2,2])
    xlim([0,0.5])
    
    figure(9)
    hold on
    scatter(sse.dynamic.active.mdm(:,15),sse.dynamic.active.mdm(:,17))
    xlabel('Mean Vel (m/s)')
    ylabel('Accuracy')
    title('Endpoint Mean Vel vs Accuracy')
    ylim([-2,2])
    xlim([0,0.5])
    
    figure(10)
    hold on
    scatter(sse.dynamic.active.mdm(:,14),sse.dynamic.active.mdm(:,17))
    xlabel('Peak Vel (m/s)')
    ylabel('Accuracy')
    title('Endpoint Peak Vel vs Accuracy')
    ylim([-2,2])
    xlim([0,0.5])
    
    %save all the things
    path=strcat(genpath,'AnalysisOutputs/',subj{ns}); %set path for saving 
    figpath=strcat(genpath,'AnalysisOutputs/',subj{ns},'/Figures');
    if (~isfolder(path)) %check if path exists
        mkdir(path); %if not,  make the necessary folders
    end
    if(~isfolder(figpath))
        mkdir(figpath);
    end
    save(strcat(path,'/sse170.mat'),'sse') %save final structure
    saveas(figure(1),strcat(figpath,'/SSE_psychPE_170.fig'))
    saveas(figure(1),strcat(figpath,'/SSE_psychPE_170.pdf'))
    saveas(figure(2),strcat(figpath,'/SSE_psychPD_170.fig'))
    saveas(figure(2),strcat(figpath,'/SSE_psychPD_170.pdf'))
    saveas(figure(3),strcat(figpath,'/SSE_psychAE_170.fig'))
    saveas(figure(3),strcat(figpath,'/SSE_psychAE_170.pdf'))
    saveas(figure(4),strcat(figpath,'/SSE_psychAD_170.fig'))
    saveas(figure(4),strcat(figpath,'/SSE_psychAD_170.pdf'))
    saveas(figure(5),strcat(figpath,'/SSE_trajsADAE_170.fig'))
    saveas(figure(5),strcat(figpath,'/SSE_trajsADAE_170.pdf'))
    saveas(figure(6),strcat(figpath,'/SSE_probevsahead_170.fig'))
    saveas(figure(6),strcat(figpath,'/SSE_probevsahead_170.pdf'))
    saveas(figure(7),strcat(figpath,'/SSE_EndMeanVelAcc_170.fig'))
    saveas(figure(7),strcat(figpath,'/SSE_EndMeanVelAcc_170.pdf'))
    saveas(figure(8),strcat(figpath,'/SSE_EndPeakVelAcc_170.fig'))
    saveas(figure(8),strcat(figpath,'/SSE_EndPeakVelAcc_170.pdf'))
    saveas(figure(9),strcat(figpath,'/SSE_DynMeanVelAcc_170.fig'))
    saveas(figure(9),strcat(figpath,'/SSE_DynMeanVelAcc_170.pdf'))
    saveas(figure(10),strcat(figpath,'/SSE_DynPeakVelAcc_170.fig'))
    saveas(figure(10),strcat(figpath,'/SSE_DynPeakVelAcc_170.pdf'))
    
end %loop ns
toc







    

