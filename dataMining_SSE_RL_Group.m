clearvars; clc; close all;
genpath='/Users/amandatherrien/Library/CloudStorage/OneDrive-ThomasJeffersonUniversityanditsAffiliates/Documents - MRRI Sensorimotor Learning Lab/Studies/Ataxia_Kinarm_SSEandRL/';

%% 1. SPECIFY THE DESIRED GROUP

%subjects who have completed RL (and CB patient ICARS scores from demo table)
% subj ={'CB02' 'CB03' 'CB04' 'CB05' 'CB06' 'CB07' 'CB08' 'CB09' 'CB11' 'CB14' 'CB15' 'CB16' 'CB17'...
%         'CN01' 'CN02' 'CN03' 'CN04' 'CN05' 'CN06' 'CN07' 'CN10' 'CN12' 'CN13' 'CN14' 'CN15' 'CN16'};
% icars_tot=[41 46 50 23 52 24 31 25 42 45 31 39 55];
% icars_limb= [17 23 23 8 28 7 15 11 23 16 13 18 20] ;


%subjects who have completed RL and SSE (and CB patient ICARS scores from demo table)
subj ={'CB02' 'CB03' 'CB04' 'CB05' 'CB06' 'CB07' 'CB08' 'CB09' 'CB11' 'CB14' 'CB15' 'CB17' ...
        'CN01' 'CN02' 'CN03' 'CN04' 'CN05' 'CN06' 'CN07' 'CN10' 'CN12' 'CN13' 'CN14' 'CN16'};
icars_limb=[17 23 23 8 28 7 15 11 23 16 13 20];
icars_tot=[41 46 50 23 52 24 31 25 42 45 31 55];


%% 2. PULL IN AND COMPILE GROUP DATA FOR SSE AND RL TASKS

%initialze varables for speed
DataMat=zeros(length(subj),65);
% cb_blvel=[];
% cb_pertvel=[];
% cn_blvel=[];
% cn_pertvel=[];

for ns=1:length(subj) %loop through each subject
 
    %Load subject SSE data
    load(strcat(genpath,'AnalysisOutputs/',subj{ns},'/sse170.mat'));
    %Load subject RL data
    load(strcat(genpath,'AnalysisOutputs/',subj{ns},'/RL.mat')); 
            
    %Organizing data for SSE task
    DataMat (ns,1)=  ns;
    DataMat (ns,2) = mean(sse.endpoint.active.mdm(:,14)); %endpoint peak velocity
    DataMat (ns,3) = mean(sse.endpoint.active.mdm(:,15)); %endpoint mean velocity
%     DataMat (ns,4) = mean(sse.dynamic.active.mdm(:,14)); %dynamic peak velocity    
%     DataMat (ns,5) = mean(sse.dynamic.active.mdm(:,15)); %dynamic mean velocity
    %JND for each SSE task
    DataMat (ns,6) = sse.endpoint.active.psycurve{1,3}(1,3)-sse.endpoint.active.psycurve{1,3}(1,1); 
    DataMat (ns,7) = sse.endpoint.passive.psycurve{1,3}(1,3)-sse.endpoint.passive.psycurve{1,3}(1,1); 
%     DataMat (ns,8) = sse.dynamic.active.psycurve{1,3}(1,3)-sse.dynamic.active.psycurve{1,3}(1,1); 
%     DataMat (ns,9) = sse.dynamic.passive.psycurve{1,3}(1,3)-sse.dynamic.passive.psycurve{1,3}(1,1);
    %Active benefit for each SSE task
    DataMat (ns,10) = DataMat(ns,6)-DataMat(ns,7); %endpoint
%     DataMat (ns,11) = DataMat(ns,8) - DataMat(ns,9); %passive
    % Bias for each SSE task
    DataMat(ns,12)=sse.endpoint.active.psycurve{1,3}(1,2);
    DataMat(ns,13)=sse.endpoint.passive.psycurve{1,3}(1,2);
%     DataMat(ns,14)=sse.dynamic.active.psycurve{1,3}(1,2);
%     DataMat(ns,15)=sse.dynamic.passive.psycurve{1,3}(1,2);
    
    %Organizing data for RL task
    DataMat(ns,16) = mean(RL.BLandPert.mdm(51:70,12)); %rtheta mean for last 20 BL
    DataMat(ns,17) = std(RL.BLandPert.mdm(51:70,12)); %rtheta SD for last 20 BL
    DataMat(ns,18) = mean(RL.BLandPert.mdm(51:70,14)); %mean peak vel last 20 BL
    DataMat(ns,19) = mean(RL.BLandPert.mdm(231:250,12));  %rtheta mean for last 20 Pert
    DataMat(ns,20) = std(RL.BLandPert.mdm(231:250,12)); %rtheta SD for last 20 Pert
    DataMat(ns,21) = mean(RL.BLandPert.mdm(231:250,14)); %mean peak vel last 20 Pert
    DataMat(ns,22) = mean(RL.Retention.mdm(1:20,12));  %rtheta mean for first 20 Ret
    DataMat(ns,23) = std(RL.Retention.mdm(1:20,12)); %rtheta SD for first 20 Ret
    DataMat(ns,24) = mean(RL.Retention.mdm(1:20,14)); %mean peak vel first 20 Ret
    DataMat(ns,25) = mean(RL.Retention.mdm(81:100,12));  %rtheta mean for last 20 Ret
    DataMat(ns,26) = std(RL.Retention.mdm(81:100,12)); %rtheta SD for last 20 Ret
    DataMat(ns,27) = mean(RL.Retention.mdm(81:100,14)); %mean peak vel for last 20 Ret 
    DataMat(ns,28) = DataMat(ns,16)-DataMat(ns,19); %Total learning BL-Pert
    DataMat(ns,29) = DataMat(ns,22)/DataMat(ns,19); %percent early retention
    DataMat(ns,30) = DataMat(ns,25)/DataMat(ns,19); %percent late retention
    %learning rate
        x=[1:180];
        y=RL.BLandPert.mdm(71:end,12);
        [coef,S]=polyfit(x,y,1);
        DataMat(ns,31)=coef(1,1); %RL task learning rate
        clear x
%     %compile velocities for histogram plot
%     if contains(subj{ns}, 'CB')
%         cb_blvel=cat(1,cb_blvel,RL.BLandPert.mdm(11:70,14));
%         cb_pertvel=cat(1,cb_pertvel,RL.BLandPert.mdm(71:250,14));
%     else
%         cn_blvel=cat(1,cn_blvel,RL.BLandPert.mdm(11:70,14));
%         cn_pertvel=cat(1,cn_pertvel,RL.BLandPert.mdm(71:250,14));
%     end

    %Add in ICARS values for cerebellar group
    if contains(subj{ns}, 'CB')
        DataMat (ns,32) = icars_tot(1,ns); %ICARS total score
        DataMat (ns,33) = icars_limb(1,ns); %ICARS kinetic sub-score
        DataMat(ns,34)=1;
    end 

end %loop ns

%% 3. PULL IN AND COMPILE GROUP DATA FROM NON-MOTOR REWARD TASKS

load(strcat(genpath,'OnlineAnalysisOutputs/Group/GroupData.mat'));

for nr=1:length(GroupData(2:end,1))
    s=char(GroupData(nr+1));
    idx=find(strcmp(subj,s));

    %compile matrixof IWG scores for timeseries figure
    if(strncmp('CB',s,2))
        iwg_sc(nr,1)=1;
        iwg_rt(nr,1)=1;
        iwg_d1(nr,1)=1;
        iwg_d2(nr,1)=1;
        iwg_d3(nr,1)=1;
        iwg_d4(nr,1)=1;
    else
        iwg_sc(nr,1)=0;
        iwg_sc(nr,1)=0;
        iwg_d1(nr,1)=0;
        iwg_d2(nr,1)=0;
        iwg_d3(nr,1)=0;
        iwg_d4(nr,1)=0;
    end
    iwg_sc(nr,2:101)=cell2mat(GroupData(nr+1,strcmp('IGT Score Timeseries',GroupData(1,:))));
    %compile matrix of IWG response times for timeseries figure
    iwg_rt(nr,2:101)=cell2mat(GroupData(nr+1,strcmp('IGT Reaction Timeseries',GroupData(1,:))));
    %compile matrix of deck probabilites for figure
    iwg_d1(nr,2:101)=cell2mat(GroupData(nr+1,strcmp('Deck 1 Probability Timeseries',GroupData(1,:))));
    iwg_d2(nr,2:101)=cell2mat(GroupData(nr+1,strcmp('Deck 2 Probability Timeseries',GroupData(1,:))));
    iwg_d3(nr,2:101)=cell2mat(GroupData(nr+1,strcmp('Deck 3 Probability Timeseries',GroupData(1,:))));
    iwg_d4(nr,2:101)=cell2mat(GroupData(nr+1,strcmp('Deck 4 Probability Timeseries',GroupData(1,:))));

    %add non-motor data to DataMat
    DataMat(idx,35)=cell2mat(GroupData(nr+1,strcmp('Point of Indifference',GroupData(1,:))));
    DataMat(idx,36)=cell2mat(GroupData(nr+1,strcmp('$.20 acq %correct block 1',GroupData(1,:))));
    DataMat(idx,37)=cell2mat(GroupData(nr+1,strcmp('$.20 acq %correct block 2',GroupData(1,:))));
    DataMat(idx,38)=cell2mat(GroupData(nr+1,strcmp('$.20 acq %correct block 3',GroupData(1,:))));
    DataMat(idx,39)=cell2mat(GroupData(nr+1,strcmp('$.20 rev %correct block 1',GroupData(1,:))));
    DataMat(idx,40)=cell2mat(GroupData(nr+1,strcmp('$.20 rev %correct block 2',GroupData(1,:))));
    DataMat(idx,41)=cell2mat(GroupData(nr+1,strcmp('$.20 rev %correct block 3',GroupData(1,:))));
    DataMat(idx,42)=cell2mat(GroupData(nr+1,strcmp('$.05 acq %correct block 1',GroupData(1,:))));
    DataMat(idx,43)=cell2mat(GroupData(nr+1,strcmp('$.05 acq %correct block 2',GroupData(1,:))));
    DataMat(idx,44)=cell2mat(GroupData(nr+1,strcmp('$.05 acq %correct block 3',GroupData(1,:))));
    DataMat(idx,45)=cell2mat(GroupData(nr+1,strcmp('$.05 rev %correct block 1',GroupData(1,:))));
    DataMat(idx,46)=cell2mat(GroupData(nr+1,strcmp('$.05 rev %correct block 2',GroupData(1,:))));
    DataMat(idx,47)=cell2mat(GroupData(nr+1,strcmp('$.05 rev %correct block 3',GroupData(1,:))));
    DataMat(idx,48)=cell2mat(GroupData(nr+1,strcmp('Block 1 Reaction $0.20',GroupData(1,:))));
    DataMat(idx,49)=cell2mat(GroupData(nr+1,strcmp('Block 2 Reaction $0.20',GroupData(1,:))));
    DataMat(idx,50)=cell2mat(GroupData(nr+1,strcmp('Block 3 Reaction $0.20',GroupData(1,:))));
    DataMat(idx,51)=cell2mat(GroupData(nr+1,strcmp('Block 4 Reaction $0.20',GroupData(1,:))));
    DataMat(idx,52)=cell2mat(GroupData(nr+1,strcmp('Block 5 Reaction $0.20',GroupData(1,:))));
    DataMat(idx,53)=cell2mat(GroupData(nr+1,strcmp('Block 6 Reaction $0.20',GroupData(1,:))));
    DataMat(idx,54)=cell2mat(GroupData(nr+1,strcmp('Block 1 Reaction $0.05',GroupData(1,:))));
    DataMat(idx,55)=cell2mat(GroupData(nr+1,strcmp('Block 2 Reaction $0.05',GroupData(1,:))));
    DataMat(idx,56)=cell2mat(GroupData(nr+1,strcmp('Block 3 Reaction $0.05',GroupData(1,:))));
    DataMat(idx,57)=cell2mat(GroupData(nr+1,strcmp('Block 4 Reaction $0.05',GroupData(1,:))));
    DataMat(idx,58)=cell2mat(GroupData(nr+1,strcmp('Block 5 Reaction $0.05',GroupData(1,:))));
    DataMat(idx,59)=cell2mat(GroupData(nr+1,strcmp('Block 6 Reaction $0.05',GroupData(1,:))));
    DataMat(idx,60)=iwg_sc(nr,end)-iwg_sc(nr,2);
    DataMat(idx,61)=iwg_sc(nr,25)-iwg_sc(nr,2);
    DataMat(idx,62)=iwg_d1(nr,end);
    DataMat(idx,63)=iwg_d2(nr,end);
    DataMat(idx,64)=iwg_d3(nr,end);
    DataMat(idx,65)=iwg_d4(nr,end);
   
end

%% 4. COMPILE GROUP DATA FOR ALL TASKS INTO MATRICES FOR PLOTTING

CB=DataMat(DataMat(:,34)==1,:);
CN=DataMat(DataMat(:,34)==0,:);

%% 5. COMPILE GROUP DATA FOR EXPORTING TO R FOR STATS
% 
% statsmat(:,1)=DataMat(:,1); %subject #
% statsmat(:,2)=DataMat(:,34); %group
% statsmat(:,3)=DataMat(:,32); %icards total
% statsmat(:,4)=DataMat(:,33); %icars limb
% statsmat(:,5)=DataMat(:,28); %rl total lrn
% statsmat(:,6)=DataMat(:,31); %rl lrn rate
% statsmat(:,7)=DataMat(:,18); %rl peak vel bl
% statsmat(:,8)=DataMat(:,21); %rl peak vel end pert
% statsmat(:,9)=DataMat(:,6); %sse endpoint active jnd
% statsmat(:,10)=DataMat(:,7); %sse endpoint passive jnd
% statsmat(:,11)=DataMat(:,10); %sse endpoint active benefit
% statsmat(:,12)=DataMat(:,35); %utility poi
% statsmat(:,13)=DataMat(:,60); %iwg final score
% statsmat(:,14)=DataMat(:,61); %iwg 25 score
% statsmat(:,15)=DataMat(:,36); %rev a1 0.2
% statsmat(:,16)=DataMat(:,37); %rev a2 0.2
% statsmat(:,17)=DataMat(:,38); %rev a3 0.2
% statsmat(:,18)=DataMat(:,39); %rev r1 0.2
% statsmat(:,19)=DataMat(:,40); %rev r2 0.2
% statsmat(:,20)=DataMat(:,41); %rev r3 0.2
% statsmat(:,21)=DataMat(:,42); %rev a1 0.05
% statsmat(:,22)=DataMat(:,43); %rev a2 0.05
% statsmat(:,23)=DataMat(:,44); %rev a3 .05
% statsmat(:,24)=DataMat(:,45); %rev r1 .05
% statsmat(:,25)=DataMat(:,46); %rev r2 .05
% statsmat(:,26)=DataMat(:,47); %rev r3 .05
% statsmat(:,27)=DataMat(:,48); %rev a1 0.2
% statsmat(:,28)=DataMat(:,49); %rev a2 0.2
% statsmat(:,29)=DataMat(:,50); %rev a3 0.2
% statsmat(:,30)=DataMat(:,51); %rev r1 0.2
% statsmat(:,31)=DataMat(:,52); %rev r2 0.2
% statsmat(:,32)=DataMat(:,53); %rev r3 0.2
% statsmat(:,33)=DataMat(:,54); %rev a1 0.05
% statsmat(:,34)=DataMat(:,55); %rev a2 0.05
% statsmat(:,35)=DataMat(:,56); %rev a3 .05
% statsmat(:,36)=DataMat(:,57); %rev r1 .05
% statsmat(:,37)=DataMat(:,58); %rev r2 .05
% statsmat(:,38)=DataMat(:,59); %rev r3 .05
% statsmat(:,39)=DataMat(:,62);
% statsmat(:,40)=DataMat(:,63);
% statsmat(:,41)=DataMat(:,64);
% statsmat(:,42)=DataMat(:,65);
% 
% statsmat_columnNames={'subj' 'group' 'icars_tot' 'icars_limb' ...
%        'rl_totlrn' 'rl_lrnrate' 'rl_pvelBL' 'rl_pvelPERT'...
%        'sseep_actJND' 'sseep_pasJND' 'sseep_actben'...
%         'util_poi' 'iwg_final' 'iwg_25'...
%         'rev20_a1corr' 'rev20_a2corr' 'rev20_a3corr' 'rev20_r1corr' 'rev20_r2corr' 'rev20_r3corr'...
%         'rev05_a1corr' 'rev05_a2corr' 'rev05_a3corr' 'rev05_r1corr' 'rev05_r2corr' 'rev05_r3corr'...
%         'rev20_a1rt' 'rev20_a2rt' 'rev20_a3rt' 'rev20_r1rt' 'rev20_r2rt' 'rev20_r3rt'...
%         'rev05_a1rt' 'rev05_a2rt' 'rev05_a3rt' 'rev05_r1rt' 'rev05_r2rt' 'rev05_r3rt'...
%         'iwg_d1prob' 'iwg_d2prob' 'iwg_d3prob' 'iwg_d4prob'};
% 
% %Export as .CSV for processing in R
% writematrix(statsmat,'/Users/amandatherrien/Dropbox/Amanda_Keith/RLinCBD/statsmat.csv')
% writecell(statsmat_columnNames,'/Users/amandatherrien/Dropbox/Amanda_Keith/RLinCBD/statsmat_columnNames.csv' )

%% 6. GENERATE FIGURES

%set general figure parameters
figpath=strcat(genpath,'AnalysisOutputs/Group/n12'); %path for eventual saving
set(0,'DefaultAxesFontSize',16)

%%%%%% 1. GROUP MEANS %%%%%%

%%%% 1a. SSE TASK %%%% 

% figure(1) %JND
% d=cat(2,CB(:,7),CN(:,7),CB(:,6),CN(:,6)); %endpoint only
% ylabel('Proprioceptive JND (mm)')
% ylim([0 100])
% hold on
% for nd=1:length(d(1,:))
%     x(1:length(d(nd,:)))=nd;
%     if mod(nd,2)==0
%         bar(nd,mean(d(:,nd)),'k','FaceAlpha',0.5)    
%         scatter(nd,d(:,nd),60,'k','Filled')
%     else
%         bar(nd,mean(d(:,nd)),'m','FaceAlpha',0.3)    
%         scatter(nd,d(:,nd),60,'m','Filled')
%     end
%     scatter(nd,d(:,nd),60,'k')
% 
% end
% clear d x
% saveas(gcf,strcat(figpath,'/SSE_group_JND.fig'))
% saveas(gcf,strcat(figpath,'/SSE_group_JND.pdf'))

% figure(2) %Bias
% d=cat(2,CB(:,13),CN(:,13),CB(:,12),CN(:,12)); %endpoint only
% ylabel('Proprioceptive Bias (mm)')
% ylim([-100 100])
% hold on
% for nd=1:length(d(1,:))
%     x(1:length(d(nd,:)))=nd;
%     if mod(nd,2)==0
%         bar(nd,mean(d(:,nd)),'k','FaceAlpha',0.5)    
%         scatter(nd,d(:,nd),60,'k','Filled')
%     else
%         bar(nd,mean(d(:,nd)),'m','FaceAlpha',0.3)    
%         scatter(nd,d(:,nd),60,'m','Filled')
%     end
%     scatter(nd,d(:,nd),60,'k')
% 
% end
% clear d x
% saveas(gcf,strcat(figpath,'/SSE_group_Bias.fig'))
% saveas(gcf,strcat(figpath,'/SSE_group_Bias.pdf'))

% %%%% 1b. RL TASK %%%%

% %RL Task phases - mean angle
% cb=cat(2,CB(:,16),CB(:,19));
% cn=cat(2,CN(:,16),CN(:,19));
% figure(3)
% ylabel('Reach Angle (deg)')
% hold on
% for nd=1:length(cb(1,:))
%     bar(nd,mean(cb(:,nd)),'m','FaceAlpha',0.3)
%     xcb(1:length(cb(:,nd)))=nd;
%     scatter(xcb,cb(:,nd),60,'m','Filled')
%     bar(nd+length(cb(1,:)),mean(cn(:,nd)),'k','FaceAlpha',0.5)
%     xcn(1:length(cn(:,nd)))=nd;
%     scatter(xcn+length(cb(1,:)),cn(:,nd),60,'k','Filled')
% end
% clear d c xcb xcn
% saveas(gcf,strcat(figpath,'/RL_group_thetaMu_phases.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_thetaMu_phases.pdf'))
 
% figure(4) %RL Task Total Learning
% hold on
% ylabel('Total Learning')
% bar(1,mean(CB(:,28)),'m','FaceAlpha',0.3)
% xcb(1:length(CB(:,28)))=1;
% scatter(xcb,CB(:,28),60,'m','Filled')
% scatter(xcb,CB(:,28),60,'k')
% bar(2,mean(CN(:,28)),'k','FaceAlpha',0.5)
% xcn(1:length(CN(:,28)))=2;
% scatter(xcn,CN(:,28),60,'k','Filled')
% scatter(xcn,CN(:,28),60,'k')
% clear xcb xcn
% axis([0 3 -5 20])
% saveas(gcf,strcat(figpath,'/RL_group_totalLearning.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_totalLearning.pdf'))

% figure(5) %RL Task learning rate
% hold on
% ylabel('Learning Rate')
% bar(1,mean(CB(:,31)),'m','FaceAlpha',0.5)
% xcb(1:length(CB(:,31)))=1;
% scatter(xcb,CB(:,31),60,'m','Filled')
% scatter(xcb,CB(:,31),60,'k')
% bar(2,mean(CN(:,31)),'k','FaceAlpha',0.5)
% xcn(1:length(CN(:,31)))=2;
% scatter(xcn,CN(:,31),60,'k','Filled')
% scatter(xcn,CN(:,31),60,'k')
% clear xcb xcn
% axis([0 3 -0.15 0.1])
% saveas(gcf,strcat(figpath,'/RL_group_learnRate.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_learnRate.pdf'))

% figure(6) %RL Task phases - within subject SD
% cb=cat(2,CB(:,17),CB(:,20));
% cn=cat(2,CN(:,17),CN(:,20));
% ylabel('Within subject SD (deg)')
% hold on
% for nd=1:length(cb(1,:))
%     bar(nd,mean(cb(:,nd)),'m','FaceAlpha',0.3)
%     xcb(1:length(cb(:,nd)))=nd;
%     scatter(xcb,cb(:,nd),60,'m','Filled')
%     bar(nd+length(cb(1,:)),mean(cn(:,nd)),'k','FaceAlpha',0.5)
%     xcn(1:length(cn(:,nd)))=nd;
%     scatter(xcn+length(cb(1,:)),cn(:,nd),60,'k','Filled')
% end
% clear d c xcb xcn
% saveas(gcf,strcat(figpath,'/RL_group_wiSD_phases.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_wiSD_phases.pdf'))

% figure(7) %RL Task phases - peak velocity
% cb=cat(2,CB(:,18),CB(:,21));
% cn=cat(2,CN(:,18),CN(:,21));
% ylabel('Peak velocity (cm/s)')
% hold on
% for nd=1:length(cb(1,:))
%     bar(nd,mean(cb(:,nd)),'m','FaceAlpha',0.3)
%     xcb(1:length(cb(:,nd)))=nd;
%     scatter(xcb,cb(:,nd),60,'m','Filled')
%     scatter(xcb,cb(:,nd),60,'k')
%     bar(nd+length(cb(1,:)),mean(cn(:,nd)),'k','FaceAlpha',0.5)
%     xcn(1:length(cn(:,nd)))=nd;
%     scatter(xcn+length(cb(1,:)),cn(:,nd),60,'k','Filled')
%     scatter(xcn+length(cb(1,:)),cn(:,nd),60,'k')
% end
% clear d c xcb xcn
% saveas(gcf,strcat(figpath,'/RL_group_pkVel_phases.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_pkVel_phases.pdf'))

% figure(8) %RL Task BL peak velocity histogram
% ylabel('Probability')
% xlabel ('Baseline Peak Velocity (cm/s)')
% hold on
% h1=histogram(cb_blvel);
% h1.Normalization = 'probability';
% h1.BinWidth = 0.05;
% h1.FaceColor=[ 0 0 1];
% h2=histogram(cn_blvel);
% h2.Normalization = 'probability';
% h2.BinWidth = 0.05;
% h2.FaceColor= [1 0 0];
% axis([0 1.5 0 0.35])
% saveas(gcf,strcat(figpath,'/RL_group_pkVel_blHistogram.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_pkVel_blHistogram.pdf'))

% figure(9) %RL Task Pert peak velocity histogram
% ylabel('Probability')
% xlabel ('Perturbation Peak Velocity (cm/s)')
% hold on
% h1=histogram(cb_pertvel);
% h1.Normalization = 'probability';
% h1.BinWidth = 0.05;
% h1.FaceColor=[ 0 0 1];
% h2=histogram(cn_pertvel);
% h2.Normalization = 'probability';
% h2.BinWidth = 0.05;
% h2.FaceColor= [1 0 0];
% axis([0 1.5 0 0.35])
% saveas(gcf,strcat(figpath,'/RL_group_pkVel_pertHistogram.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_pkVel_pertHistogram.pdf'))

%   %%%% 1c. NON-MOTOR REWARD %%%%

cbrows=find(iwg_sc(:,1)==1);
cnrows=find(iwg_sc(:,1)==0);
x1(1:length(cbrows))=1;
x2(1:length(cnrows))=2;

% figure(10) % IWG score timeseries
% hold on
% ylabel('IWG Task Score')
% xlabel('Trial')
% cb=iwg_sc(cbrows,2:end)-iwg_sc(cbrows,2);    
% cb_mu=mean(cb);
% cb_se=std(cb)/(sqrt(length(cbrows)));
% cn=iwg_sc(cnrows,2:end)-iwg_sc(cnrows,2);    
% cn_mu=mean(cn);
% cn_se=std(cn)/(sqrt(length(cnrows)));
% x=cat(1,(1:length(cn_mu))',flip(1:length(cn_mu))');
% ycn=cat(2,cn_mu+cn_se,flip(cn_mu-cn_se));
% fill(x,ycn,'k','FaceColor','k', 'FaceAlpha',0.3,'EdgeColor','k','EdgeAlpha',0.3)
% plot(cn_mu,'k','LineWidth',3)
% ycb=cat(2,cb_mu+cb_se,flip(cb_mu-cb_se));
% fill(x,ycb,'m','FaceColor','m', 'FaceAlpha',0.3,'EdgeColor','m','EdgeAlpha',0.3)
% plot(cb_mu,'m','LineWidth',3)
% clear x
% saveas(gcf,strcat(figpath,'/NM_group_IWGscoreTimeseries.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_IWGscoreTimeseries.pdf'))

% figure(11) %IWG final score
% hold on
% ylabel('IWG Task Final Score')
% bar(1, mean(cb(:,end)),'m','FaceAlpha',0.3)
% bar(2, mean(cn(:,end)),'k','FaceAlpha',0.5)
% scatter(x1,cb(:,end),60,'m','Filled')
% scatter(x1,cb(:,end),60, 'k')
% scatter(x2,cn(:,end),60','k','Filled')
% scatter(x2,cn(:,end),60,'k')
% saveas(gcf,strcat(figpath,'/NM_group_IWGscoreFinal.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_IWGscoreFinal.pdf'))

% figure(12) %IWG score at trial 25
% hold on
% ylabel('IWG Task Score at Trial 25')
% bar(1,mean(cb(:,25)),'m','FaceAlpha',0.3)
% bar(2,mean(cn(:,25)),'k','FaceAlpha',0.5)
% scatter(x1,cb(:,25),60,'m','Filled')
% scatter(x1,cb(:,25),60, 'k')
% scatter(x2,cn(:,25),60','k','Filled')
% scatter(x2,cn(:,25),60,'k')
% saveas(gcf,strcat(figpath,'/NM_group_IWGscore25.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_IWGscore25.pdf'))

% figure(13) %IWG Deck probabilities
% subplot(1,2,1)
% hold on
% ylabel('Probability')
% xlabel('Trial')
% ylim([0 .8])
% xlim([0 100])
% cb_d1mu=mean(iwg_d1(cbrows,2:end));
% cb_d1se=std(iwg_d1(cbrows,2:end))/(sqrt(length(cbrows)));
% cb_d2mu=mean(iwg_d2(cbrows,2:end));
% cb_d2se=std(iwg_d2(cbrows,2:end))/(sqrt(length(cbrows)));
% cb_d3mu=mean(iwg_d3(cbrows,2:end));
% cb_d3se=std(iwg_d3(cbrows,2:end))/(sqrt(length(cbrows)));
% cb_d4mu=mean(iwg_d4(cbrows,2:end));
% cb_d4se=std(iwg_d4(cbrows,2:end))/(sqrt(length(cbrows)));
% x=cat(1,(1:length(cb_d1mu))',flip(1:length(cb_d1mu))');
% ycb=cat(2,cb_d1mu+cb_d1se,flip(cb_d1mu-cb_d1se));
% fill(x,ycb,'k','FaceColor','k', 'FaceAlpha',0.3,'EdgeColor','k','EdgeAlpha',0.3)
% plot(cb_d1mu,'k','LineWidth',3)
% ycb=cat(2,cb_d2mu+cb_d2se,flip(cb_d2mu-cb_d2se));
% fill(x,ycb,'r','FaceColor','r', 'FaceAlpha',0.3,'EdgeColor','r','EdgeAlpha',0.3)
% plot(cb_d2mu,'r','LineWidth',3)
% ycb=cat(2,cb_d3mu+cb_d3se,flip(cb_d3mu-cb_d3se));
% fill(x,ycb,'b','FaceColor','b', 'FaceAlpha',0.3,'EdgeColor','b','EdgeAlpha',0.3)
% plot(cb_d3mu,'b','LineWidth',3)
% ycb=cat(2,cb_d4mu+cb_d4se,flip(cb_d4mu-cb_d4se));
% fill(x,ycb,'g','FaceColor','g', 'FaceAlpha',0.3,'EdgeColor','g','EdgeAlpha',0.3)
% plot(cb_d4mu,'g','LineWidth',3)
% subplot(1,2,2)
% hold on
% ylabel('Probability')
% xlabel('Trial')
% ylim([0 .8])
% xlim([0 100])
% cn_d1mu=mean(iwg_d1(cnrows,2:end));
% cn_d1se=std(iwg_d1(cnrows,2:end))/(sqrt(length(cnrows)));
% cn_d2mu=mean(iwg_d2(cnrows,2:end));
% cn_d2se=std(iwg_d2(cnrows,2:end))/(sqrt(length(cnrows)));
% cn_d3mu=mean(iwg_d3(cnrows,2:end));
% cn_d3se=std(iwg_d3(cnrows,2:end))/(sqrt(length(cnrows)));
% cn_d4mu=mean(iwg_d4(cbrows,2:end));
% cn_d4se=std(iwg_d4(cnrows,2:end))/(sqrt(length(cnrows)));
% x=cat(1,(1:length(cn_d1mu))',flip(1:length(cn_d1mu))');
% ycn=cat(2,cn_d1mu+cn_d1se,flip(cn_d1mu-cn_d1se));
% fill(x,ycn,'k','FaceColor','k', 'FaceAlpha',0.3,'EdgeColor','k','EdgeAlpha',0.3)
% plot(cn_d1mu,'k','LineWidth',3)
% ycn=cat(2,cn_d2mu+cn_d2se,flip(cn_d2mu-cn_d2se));
% fill(x,ycn,'r','FaceColor','r', 'FaceAlpha',0.3,'EdgeColor','r','EdgeAlpha',0.3)
% plot(cn_d2mu,'r','LineWidth',3)
% ycn=cat(2,cn_d3mu+cn_d3se,flip(cn_d3mu-cn_d3se));
% fill(x,ycn,'b','FaceColor','b', 'FaceAlpha',0.3,'EdgeColor','b','EdgeAlpha',0.3)
% plot(cn_d3mu,'b','LineWidth',3)
% ycn=cat(2,cn_d4mu+cn_d4se,flip(cn_d4mu-cn_d4se));
% fill(x,ycn,'g','FaceColor','g', 'FaceAlpha',0.3,'EdgeColor','g','EdgeAlpha',0.3)
% plot(cn_d4mu,'g','LineWidth',3)
% saveas(gcf,strcat(figpath,'/NM_group_IWGDeckTimeseries.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_IWGDeckTimeseries.pdf'))

% figure(14) %IWG final deck probabilities
% hold on
% bar(1,mean(iwg_d1(cbrows,end)),'m','FaceAlpha',0.3)
% scatter(x1,iwg_d1(cbrows,end),60,'m','filled')
% scatter(x1,iwg_d1(cbrows,end),60,'k')
% bar(2,mean(iwg_d1(cnrows,end)),'k','FaceAlpha',0.5)
% scatter(x2,iwg_d1(cnrows,end),60,'k','filled')
% scatter(x2,iwg_d1(cnrows,end),60,'k')
% bar(3,mean(iwg_d2(cbrows,end)),'m','FaceAlpha',0.3)
% scatter(x1+2,iwg_d2(cbrows,end),60,'m','filled')
% scatter(x1+2,iwg_d2(cbrows,end),60,'k')
% bar(4,mean(iwg_d2(cnrows,end)),'k','FaceAlpha',0.5)
% scatter(x2+2,iwg_d2(cnrows,end),60,'k','filled')
% scatter(x2+2,iwg_d2(cnrows,end),60,'k')
% bar(5,mean(iwg_d3(cbrows,end)),'m','FaceAlpha',0.3)
% scatter(x1+4,iwg_d3(cbrows,end),60,'m','filled')
% scatter(x1+4,iwg_d3(cbrows,end),60,'k')
% bar(6,mean(iwg_d3(cnrows,end)),'k','FaceAlpha',0.5)
% scatter(x2+4,iwg_d3(cnrows,end),60,'k','filled')
% scatter(x2+4,iwg_d3(cnrows,end),60,'k')
% bar(7,mean(iwg_d4(cbrows,end)),'m','FaceAlpha',0.3)
% scatter(x1+6,iwg_d4(cbrows,end),60,'m','filled')
% scatter(x1+6,iwg_d4(cbrows,end),60,'k')
% bar(8,mean(iwg_d4(cnrows,end)),'k','FaceAlpha',0.5)
% scatter(x2+6,iwg_d4(cnrows,end),60,'k','filled')
% scatter(x2+6,iwg_d4(cnrows,end),60,'k')
% saveas(gcf,strcat(figpath,'/NM_group_IWGDeckFinal.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_IWGDeckFinal.pdf'))

% figure(13) %Utility POI
% hold on
% ylabel('Point of Indifference')
% cbidx=find(CB(:,35)~=0); 
% cnidx=find(CN(:,35)~=0);
% bar(1,mean(CB(cbidx,35)),'m','FaceAlpha',0.3)
% bar(2,mean(CN(cnidx,35)),'k','FaceAlpha',0.5)
% scatter(x1,CB(cbidx,35),60,'m','Filled')
% scatter(x1,CB(cbidx,35),60,'k')
% scatter(x2,CN(cnidx,35),60,'k','Filled')
% scatter(x2,CN(cnidx,35),60,'k')
% saveas(gcf,strcat(figpath,'/NM_group_UtilityPOI.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_UtilityPOI.pdf'))

% figure(14) %Reversal task performance $0.20
% hold on
% ylabel('Percent correct')
% ylim([0 100])
% xlim([0.5 7.5])
% scatter(x1,CB(cbidx,36),60,'m')
% scatter(x2-1,CN(cnidx,36),60,'k')
% scatter(x1+1,CB(cbidx,37),60,'m')
% scatter(x2,CN(cnidx,37),60,'k')
% scatter(x1+2,CB(cbidx,38),60,'m')
% scatter(x2+1,CN(cnidx,38),60,'k')
% scatter(x1+4,CB(cbidx,39),60,'m')
% scatter(x2+3,CN(cnidx,39),60,'k')
% scatter(x1+5,CB(cbidx,40),60,'m')
% scatter(x2+4,CN(cnidx,40),60,'k')
% scatter(x1+6,CB(cbidx,41),60,'m')
% scatter(x2+5,CN(cnidx,41),60,'k')
% plot([1 2 3],mean(CN(cnidx,36:38)),'k','LineWidth',2)
% plot([1 2 3],mean(CB(cbidx,36:38)),'m','LineWidth',2)
% plot([5 6 7],mean(CN(cnidx,39:41)),'k','LineWidth',2)
% plot([5 6 7],mean(CB(cbidx,39:41)),'m','LineWidth',2)
% saveas(gcf,strcat(figpath,'/NM_group_reversalScore20c.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_reversalScore20c.pdf'))

% figure(15) %Reversal task performance $0.05
% hold on
% ylabel('Percent correct')
% ylim([0 100])
% xlim([0.5 7.5])
% scatter(x1,CB(cbidx,42),60,'m')
% scatter(x2-1,CN(cnidx,42),60,'k')
% scatter(x1+1,CB(cbidx,43),60,'m')
% scatter(x2,CN(cnidx,43),60,'k')
% scatter(x1+2,CB(cbidx,44),60,'m')
% scatter(x2+1,CN(cnidx,44),60,'k')
% scatter(x1+4,CB(cbidx,45),60,'m')
% scatter(x2+3,CN(cnidx,45),60,'k')
% scatter(x1+5,CB(cbidx,46),60,'m')
% scatter(x2+4,CN(cnidx,46),60,'k')
% scatter(x1+6,CB(cbidx,47),60,'m')
% scatter(x2+5,CN(cnidx,47),60,'k')
% plot([1 2 3],mean(CN(cnidx,42:44)),'k','LineWidth',2)
% plot([1 2 3],mean(CB(cbidx,42:44)),'m','LineWidth',2)
% plot([5 6 7],mean(CN(cnidx,45:47)),'k','LineWidth',2)
% plot([5 6 7],mean(CB(cbidx,45:47)),'m','LineWidth',2)
% saveas(gcf,strcat(figpath,'/NM_group_reversalScore05c.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_reversalScore05c.pdf'))

% figure(16) %Reversal response time $0.20
% hold on
% ylabel('Response Time (s)')
% ylim([0 5])
% xlim([0.5 7.5])
% scatter(x1,CB(cbidx,48),60,'m')
% scatter(x2-1,CN(cnidx,48),60,'k')
% scatter(x1+1,CB(cbidx,49),60,'m')
% scatter(x2,CN(cnidx,49),60,'k')
% scatter(x1+2,CB(cbidx,50),60,'m')
% scatter(x2+1,CN(cnidx,50),60,'k')
% scatter(x1+4,CB(cbidx,51),60,'m')
% scatter(x2+3,CN(cnidx,51),60,'k')
% scatter(x1+5,CB(cbidx,52),60,'m')
% scatter(x2+4,CN(cnidx,52),60,'k')
% scatter(x1+6,CB(cbidx,53),60,'m')
% scatter(x2+5,CN(cnidx,53),60,'k')
% plot([1 2 3],mean(CN(cnidx,48:50)),'k','LineWidth',2)
% plot([1 2 3],mean(CB(cbidx,48:50)),'m','LineWidth',2)
% plot([5 6 7],mean(CN(cnidx,51:53)),'k','LineWidth',2)
% plot([5 6 7],mean(CB(cbidx,51:53)),'m','LineWidth',2)
% saveas(gcf,strcat(figpath,'/NM_group_reversalRT20c.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_reversalRT20c.pdf'))

% figure(17) %Reversal response time $0.05
% hold on
% ylabel('Response Time (s)')
% ylim([0 5])
% xlim([0.5 7.5])
% scatter(x1,CB(cbidx,54),60,'m')
% scatter(x2-1,CN(cnidx,54),60,'k')
% scatter(x1+1,CB(cbidx,55),60,'m')
% scatter(x2,CN(cnidx,55),60,'k')
% scatter(x1+2,CB(cbidx,56),60,'m')
% scatter(x2+1,CN(cnidx,56),60,'k')
% scatter(x1+4,CB(cbidx,57),60,'m')
% scatter(x2+3,CN(cnidx,57),60,'k')
% scatter(x1+5,CB(cbidx,58),60,'m')
% scatter(x2+4,CN(cnidx,58),60,'k')
% scatter(x1+6,CB(cbidx,59),60,'m')
% scatter(x2+5,CN(cnidx,59),60,'k')
% plot([1 2 3],mean(CN(cnidx,54:56)),'k','LineWidth',2)
% plot([1 2 3],mean(CB(cbidx,54:56)),'m','LineWidth',2)
% plot([5 6 7],mean(CN(cnidx,57:59)),'k','LineWidth',2)
% plot([5 6 7],mean(CB(cbidx,57:59)),'m','LineWidth',2)
% saveas(gcf,strcat(figpath,'/NM_group_reversalRT05c.fig'))
% saveas(gcf,strcat(figpath,'/NM_group_reversalRT05c.pdf'))


%%%%%% 2. ACTIVE BENEFIT CORRELATIONS %%%%%%

% figure(18) %correlation between endpoint and dynamic active benefit
% hold on
% [coef,S]=polyfit(cb_epab,cb_dyab,1);
% cb_lin=polyval(coef,cb_epab);
% [r,p,rl,ru]=corrcoef(cb_epab,cb_dyab); %pearson r and sig
% r2=1-(S.normr/norm(cb_dyab-mean(cb_dyab)))^2; %r squared
% cb=strcat('Cerebellar: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(cn_epab,cn_dyab,1);
% cn_lin=polyval(coef,cn_epab);
% [r,p,rl,ru]=corrcoef(cn_epab,cn_dyab); %pearson r and sig
% r2=1-(S.normr/norm(cn_dyab-mean(cn_dyab)))^2; %r squared
% cn=strcat('Control: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(cb_epab,cb_dyab,60,'b', 'filled')
% scatter(cb_epab,cb_dyab,60,'k')
% plot(cb_epab,cb_lin,'b','LineWidth',1.5)
% scatter(cn_epab,cn_dyab,60,'r', 'filled')
% scatter(cn_epab,cn_dyab,60,'k')
% plot(cn_epab,cn_lin,'r','LineWidth',1.5)
% xlabel('Endpoint Active Benefit')
% ylabel('Dynamic Active Benefit')
% title(strcat(cb,' ',cn))
% axis([-40 40 -40 40])
% saveas(gcf,strcat(figpath,'/SSE_group_epAB_v_dyAB.fig'))
% saveas(gcf,strcat(figpath,'/SSE_group_epAB_v_dyAB.pdf'))

% figure(19) %endpoint active benefit vs. learning rate'
% hold on
% [coef,S]=polyfit(CB(:,10),CB(:,31),1);
% cb_lin=polyval(coef,CB(:,10));
% [r,p,rl,ru]=corrcoef(CB(:,10),CB(:,31)); %pearson r and sig
% r2=1-(S.normr/norm(CB(:,31)-mean(CB(:,31))))^2; %r squared
% cb=strcat('CB: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,10),CN(:,31),1);
% cn_lin=polyval(coef,CN(:,10));
% [r,p,rl,ru]=corrcoef(CN(:,10),CN(:,31)); %pearson r and sig
% r2=1-(S.normr/norm(CN(:,31)-mean(CN(:,31))))^2; %r squared
% cn=strcat('CN: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,10),CB(:,31),60,'m','filled')
% scatter(CB(:,10),CB(:,31),60,'k')
% plot(CB(:,10),cb_lin,'m','LineWidth',1.5)
% scatter(CN(:,10),CN(:,31),60,'k','filled')
% scatter(CN(:,10),CN(:,31),60,'k')
% plot(CN(:,10),cn_lin,'k','LineWidth',1.5)
% xlabel('Endpoint Active Benefit')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))
% axis([-40 40 -0.15 0.1])
% saveas(gcf,strcat(figpath,'/RL&SSE_group_epAB_v_RLlearnrate.fig'))
% saveas(gcf,strcat(figpath,'/RL&SSE_group_epAB_v_RLlearnrate.pdf'))

% figure(20) %endpoint active benefit vs. total learning'
% hold on
% [coef,S]=polyfit(CB(:,10),CB(:,28),1);
% cb_lin=polyval(coef,CB(:,10));
% [r,p,rl,ru]=corrcoef(CB(:,10),CB(:,28)); %pearson r and sig
% r2=1-(S.normr/norm(CB(:,28)-mean(CB(:,28))))^2; %r squared
% cb=strcat('CB: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,10),CN(:,28),1);
% cn_lin=polyval(coef,CN(:,10));
% [r,p,rl,ru]=corrcoef(CN(:,10),CN(:,28)); %pearson r and sig
% r2=1-(S.normr/norm(CN(:,28)-mean(CN(:,28))))^2; %r squared
% cn=strcat('CN: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,10),CB(:,28),60,'m','filled')
% scatter(CB(:,10),CB(:,28),60,'k')
% plot(CB(:,10),cb_lin,'m','LineWidth',1.5)
% scatter(CN(:,10),CN(:,28),60,'k','filled')
% scatter(CN(:,10),CN(:,28),60,'k')
% plot(CN(:,10),cn_lin,'k','LineWidth',1.5)
% xlabel('Endpoint Active Benefit')
% ylabel('RL Total Learning (deg)')
% title(strcat(cb,' ',cn))
% axis([-40 40 -10 20])
% saveas(gcf,strcat(figpath,'/RL&SSE_group_epAB_v_RLtotlrn.fig'))
% saveas(gcf,strcat(figpath,'/RL&SSE_group_epAB_v_RLtotlrn.pdf'))

% figure(21) %dynamic active benefit vs. learning rate
% hold on
% [coef,S]=polyfit(cb_dyab,CB(:,29),1);
% cb_lin=polyval(coef,cb_dyab);
% [r,p,rl,ru]=corrcoef(cb_dyab,CB(:,29));
% r2=1-(S.normr/norm(CB(:,29)-mean(CB(:,29))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(cn_dyab,CN(:,29),1);
% cn_lin=polyval(coef,cn_dyab);
% [r,p,rl,ru]=corrcoef(cn_dyab,CN(:,29));
% r2=1-(S.normr/norm(CN(:,29)-mean(CN(:,29))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(cb_dyab,CB(:,29),60,'b','filled')
% scatter(cb_dyab,CB(:,29),60,'k')
% plot(cb_dyab,cb_lin,'b','LineWidth',1.5)
% scatter(cn_dyab,CN(:,29),60,'r','filled')
% scatter(cn_dyab,CN(:,29),60,'k')
% plot(cn_dyab,cn_lin,'r','LineWidth',1.5)
% xlabel('Dynamic Active Benefit')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))
% axis([-40 40 -0.15 0.1])
% saveas(gcf,strcat(figpath,'/RL&SSE_group_dyAB_v_RLlearnrate.fig'))
% saveas(gcf,strcat(figpath,'/RL&SSE_group_dyAB_v_RLlearnrate.pdf'))


% %%%%%% 3. JND MEANS CORRELATIONS %%%%%%

% figure(22) %passive endpoint JND vs. active endpoint JND
% hold on
% [coef,S]=polyfit(CB(:,7),CB(:,6),1);
% cb_lin=polyval(coef,CB(:,7));
% [r,p,rl,ru]=corrcoef(CB(:,7),CB(:,6));
% r2=1-(S.normr/norm(CB(:,6)-mean(CB(:,6))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,7),CN(:,6),1);
% cn_lin=polyval(coef,CN(:,7));
% [r,p,rl,ru]=corrcoef(CN(:,7),CN(:,6));
% r2=1-(S.normr/norm(CN(:,6)-mean(CN(:,6))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,7),CB(:,6),'b','filled')
% plot(CB(:,7),cb_lin,'b','LineWidth',1.5)
% scatter(CN(:,7),CN(:,6),'r','filled')
% plot(CN(:,7),cn_lin,'r','LineWidth',1.5)
% xlabel('Endpoint Passive JND (mm)')
% ylabel('Endpoint Active JND (mm)')
% title(strcat(cb,' ',cn))

% figure(23) %passive endpoint JND vs. total learning
% hold on
% [coef,S]=polyfit(CB(:,7),CB(:,28),1);
% cb_lin=polyval(coef,CB(:,7));
% [r,p,rl,ru]=corrcoef(CB(:,7),CB(:,28));
% r2=1-(S.normr/norm(CB(:,28)-mean(CB(:,28))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,7),CN(:,28),1);
% cn_lin=polyval(coef,CN(:,7));
% [r,p,~,ru]=corrcoef(CN(:,7),CN(:,28));
% r2=1-(S.normr/norm(CN(:,28)-mean(CN(:,28))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,7),CB(:,28),'m','filled')
% plot(CB(:,7),cb_lin,'m','LineWidth',1.5)
% scatter(CN(:,7),CN(:,28),'k','filled')
% plot(CN(:,7),cn_lin,'k','LineWidth',1.5)
% xlabel('Endpoint Passive JND (mm)')
% ylabel('RL Total Learning')
% title(strcat(cb,' ',cn))
% saveas(gcf,strcat(figpath,'/RL&SSE_group_pasepJND_v_RLtotlrn.fig'))
% saveas(gcf,strcat(figpath,'/RL&SSE_group_pasepJND_v_RLtotlrn.pdf'))

% figure(24) %active endpoint JND vs. total learing
% hold on
% [coef,S]=polyfit(CB(:,6),CB(:,28),1);
% cb_lin=polyval(coef,CB(:,6));
% [r,p,rl,ru]=corrcoef(CB(:,6),CB(:,28));
% r2=1-(S.normr/norm(CB(:,28)-mean(CB(:,28))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,6),CN(:,28),1);
% cn_lin=polyval(coef,CN(:,6));
% [r,p,rl,ru]=corrcoef(CN(:,6),CN(:,28));
% r2=1-(S.normr/norm(CN(:,28)-mean(CN(:,28))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,6),CB(:,28),60,'m','filled')
% plot(CB(:,6),cb_lin,'m','LineWidth',1.5)
% scatter(CN(:,6),CN(:,28),60,'k','filled')
% plot(CN(:,6),cn_lin,'k','LineWidth',1.5)
% xlabel('Endpoint Active JND (mm)')
% ylabel('RL Total Learning')
% title(strcat(cb,' ',cn))
% saveas(gcf,strcat(figpath,'/RL&SSE_group_actepJND_v_RLtotlrn.fig'))
% saveas(gcf,strcat(figpath,'/RL&SSE_group_actepJND_v_RLtotlrn.pdf'))
 
% figure(25) %passive dynamic JND vs. learning rate
% hold on
% [coef,S]=polyfit(CB(:,9),CB(:,29),1);
% cb_lin=polyval(coef,CB(:,9));
% [r,p,rl,ru]=corrcoef(CB(:,9),CB(:,29));
% r2=1-(S.normr/norm(CB(:,29)-mean(CB(:,29))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,9),CN(:,29),1);
% cn_lin=polyval(coef,CN(:,9));
% [r,p,rl,ru]=corrcoef(CN(:,9),CN(:,29));
% r2=1-(S.normr/norm(CN(:,29)-mean(CN(:,29))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,9),CB(:,29),'b','filled')
% plot(CB(:,9),cb_lin,'b','LineWidth',1.5)
% scatter(CN(:,9),CN(:,29),'r','filled')
% plot(CN(:,9),cn_lin,'r','LineWidth',1.5)
% xlabel('Dynamic Passive JND (mm)')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))
% 
% figure(18) %active dynamic JND vs. learning rate
% hold on
% [coef,S]=polyfit(CB(:,8),CB(:,29),1);
% cb_lin=polyval(coef,CB(:,8));
% [r,p,rl,ru]=corrcoef(CB(:,8),CB(:,29));
% r2=1-(S.normr/norm(CB(:,29)-mean(CB(:,29))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,8),CN(:,29),1);
% cn_lin=polyval(coef,CN(:,8));
% [r,p,rl,ru]=corrcoef(CN(:,8),CN(:,29));
% r2=1-(S.normr/norm(CN(:,29)-mean(CN(:,29))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,8),CB(:,29),'b','filled')
% plot(CB(:,8),cb_lin,'b','LineWidth',1.5)
% scatter(CN(:,8),CN(:,29),'r','filled')
% plot(CN(:,8),cn_lin,'r','LineWidth',1.5)
% xlabel('Dynamic Active JND (mm)')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))


% %%%%%% 4. BIAS MEANS CORRELATIONS %%%%%%

% figure(26) %passive endpoint bias vs. learning rate
% hold on
% [coef,S]=polyfit(CB(:,11),CB(:,29),1);
% cb_lin=polyval(coef,CB(:,11));
% [r,p,rl,ru]=corrcoef(CB(:,11),CB(:,29));
% r2=1-(S.normr/norm(CB(:,29)-mean(CB(:,29))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,11),CN(:,29),1);
% cn_lin=polyval(coef,CN(:,11));
% [r,p,rl,ru]=corrcoef(CN(:,11),CN(:,29));
% r2=1-(S.normr/norm(CN(:,29)-mean(CN(:,29))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,11),CB(:,29),'b','filled')
% plot(CB(:,11),cb_lin,'b','LineWidth',1.5)
% scatter(CN(:,11),CN(:,29),'r','filled')
% plot(CN(:,11),cn_lin,'r','LineWidth',1.5)
% xlabel('Endpoint Passive Bias (mm)')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))

% figure(27) %active endpoint bias vs. learning rate
% hold on
% [coef,S]=polyfit(CB(:,10),CB(:,29),1);
% cb_lin=polyval(coef,CB(:,10));
% [r,p,rl,ru]=corrcoef(CB(:,10),CB(:,29));
% r2=1-(S.normr/norm(CB(:,29)-mean(CB(:,29))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,10),CN(:,29),1);
% cn_lin=polyval(coef,CN(:,10));
% [r,p,rl,ru]=corrcoef(CN(:,10),CN(:,29));
% r2=1-(S.normr/norm(CN(:,29)-mean(CN(:,29))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,10),CB(:,29),'b','filled')
% plot(CB(:,10),cb_lin,'b','LineWidth',1.5)
% scatter(CN(:,10),CN(:,29),'r','filled')
% plot(CN(:,10),cn_lin,'r','LineWidth',1.5)
% xlabel('Endpoint Active Bias (mm)')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))
 
% figure(28) %passive dynamic bias vs. learning rate
% hold on
% [coef,S]=polyfit(CB(:,13),CB(:,29),1);
% cb_lin=polyval(coef,CB(:,13));
% [r,p,rl,ru]=corrcoef(CB(:,13),CB(:,29));
% r2=1-(S.normr/norm(CB(:,29)-mean(CB(:,29))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,13),CN(:,29),1);
% cn_lin=polyval(coef,CN(:,13));
% [r,p,rl,ru]=corrcoef(CN(:,13),CN(:,29));
% r2=1-(S.normr/norm(CN(:,29)-mean(CN(:,29))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,13),CB(:,29),'b','filled')
% plot(CB(:,13),cb_lin,'b','LineWidth',1.5)
% scatter(CN(:,13),CN(:,29),'r','filled')
% plot(CN(:,13),cn_lin,'r','LineWidth',1.5)
% xlabel('Dynamic Passive Bias (mm)')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))

% figure(29) %active dynamic bias vs. learning rate
% hold on
% [coef,S]=polyfit(CB(:,12),CB(:,29),1);
% cb_lin=polyval(coef,CB(:,12));
% [r,p,rl,ru]=corrcoef(CB(:,12),CB(:,29));
% r2=1-(S.normr/norm(CB(:,29)-mean(CB(:,29))))^2; %R squared
% cb=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(:,12),CN(:,29),1);
% cn_lin=polyval(coef,CN(:,12));
% [r,p,rl,ru]=corrcoef(CN(:,12),CN(:,29));
% r2=1-(S.normr/norm(CN(:,29)-mean(CN(:,29))))^2; %R squared
% cn=strcat('r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,12),CB(:,29),'b','filled')
% plot(CB(:,12),cb_lin,'b','LineWidth',1.5)
% scatter(CN(:,12),CN(:,29),'r','filled')
% plot(CN(:,12),cn_lin,'r','LineWidth',1.5)
% xlabel('Dynamic Active Bias (mm)')
% ylabel('RL Learning Rate')
% title(strcat(cb,' ',cn))


%%%%%% 5. ICARS CORRELTIONS %%%%%%

% figure(30) %ICARS total vs. endpoint active benefit
% hold on
% [coef,S]=polyfit(CB(:,32),CB(:,10),1);
% cb_lin=polyval(coef,CB(:,32));
% [r,p,rl,ru]=corrcoef(CB(:,32),CB(:,10)); %pearson r and sig
% r2=1-(S.normr/norm(CB(:,10)-mean(CB(:,10))))^2; %r squared
% cb=strcat('Cerebellar: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,32),CB(:,10),60,'m','filled')
% scatter(CB(:,32),CB(:,10),60,'k')
% plot(CB(:,32),cb_lin,'m','LineWidth',1.5)
% xlabel('ICARS Total Score (/100)')
% ylabel('Endpoint Active Benefit')
% title(cb)
% axis([0 60 -40 40])
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSTot_v_epAB.fig'))
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSTot_v_epAB.pdf'))

% figure(31) %ICARS Limb vs. endpoint active benefit
% hold on
% [coef,S]=polyfit(CB(:,33),CB(:,10),1);
% cb_lin=polyval(coef,CB(:,33));
% [r,p,rl,ru]=corrcoef(CB(:,33),CB(:,10)); %pearson r and sig
% r2=1-(S.normr/norm(CB(:,10)-mean(CB(:,10))))^2; %r squared
% cb=strcat('Cerebellar: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,33),CB(:,10),60,'m','filled')
% scatter(CB(:,33),CB(:,10),60,'k')
% plot(CB(:,33),cb_lin,'m','LineWidth',1.5)
% xlabel('ICARS Limb Kinetic (/56)')
% ylabel('Endpoint Active Benefit')
% title(cb)
% axis([0 30 -40 40])
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSLimb_v_epAB.fig'))
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSLimb_v_epAB.pdf'))

% figure(32) %ICARS total vs. dynamic active benefit
% hold on
% [coef,S]=polyfit(CB(:,30),cb_dyab,1);
% cb_lin=polyval(coef,CB(:,30));
% [r,p,rl,ru]=corrcoef(CB(:,30),cb_dyab); %pearson r and sig
% r2=1-(S.normr/norm(cb_dyab-mean(cb_dyab)))^2; %r squared
% cb=strcat('Cerebellar: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,30),cb_dyab,60,'b','filled')
% scatter(CB(:,30),cb_dyab,60,'k')
% plot(CB(:,30),cb_lin,'b','LineWidth',1.5)
% xlabel('ICARS Total Score (/100)')
% ylabel('Dynamic Active Benefit')
% title(cb)
% axis([0 60 -40 40])
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSTot_v_dyAB.fig'))
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSTot_v_dyAB.pdf'))
% 
% figure(26) %ICARS Limb vs. dynamic active benefit
% hold on
% [coef,S]=polyfit(CB(:,31),cb_dyab,1);
% cb_lin=polyval(coef,CB(:,31));
% [r,p,rl,ru]=corrcoef(CB(:,31),cb_dyab); %pearson r and sig
% r2=1-(S.normr/norm(cb_dyab-mean(cb_dyab)))^2; %r squared
% cb=strcat('Cerebellar: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,31),cb_dyab,60,'b','filled')
% scatter(CB(:,31),cb_dyab,60,'k')
% plot(CB(:,31),cb_lin,'b','LineWidth',1.5)
% xlabel('ICARS Limb Kinetic (/56)')
% ylabel('Dynamic Active Benefit')
% title(cb)
% axis([0 30 -40 40])
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSLimb_v_dyAB.fig'))
% saveas(gcf,strcat(figpath,'/SSE_group_ICARSLimb_v_dyAB.pdf'))

% figure(33) %ICARS total vs. RL total learning
% hold on
% [coef,S]=polyfit(CB(:,32),CB(:,28),1);
% cb_lin=polyval(coef,CB(:,32));
% [r,p,rl,ru]=corrcoef(CB(:,32),CB(:,28)); %pearson r and sig
% r2=1-(S.normr/norm(CB(:,28)-mean(CB(:,28))))^2; %r squared
% cb=strcat('Cerebellar: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,32),CB(:,28),60,'m','filled')
% scatter(CB(:,32),CB(:,28),60,'k')
% plot(CB(:,32),cb_lin,'m','LineWidth',1.5)
% xlabel('ICARS Total Score (/100)')
% ylabel('RL Learning Rate')
% axis([10 60 -5 20])
% title(cb)
% saveas(gcf,strcat(figpath,'/RL_group_ICARSTot_v_LrnRate.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_ICARSTot_v_LrnRate.pdf'))

% figure(34) %ICARS limb vs. RL total learning
% hold on
% [coef,S]=polyfit(CB(:,33),CB(:,28),1);
% cb_lin=polyval(coef,CB(:,33));
% [r,p,rl,ru]=corrcoef(CB(:,33),CB(:,28)); %pearson r and sig
% r2=1-(S.normr/norm(CB(:,28)-mean(CB(:,28))))^2; %r squared
% cb=strcat('Cerebellar: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% scatter(CB(:,33),CB(:,28),60,'m','filled')
% scatter(CB(:,33),CB(:,28),60,'k')
% plot(CB(:,33),cb_lin,'m','LineWidth',1.5)
% xlabel('ICARS Limb Kinetic (/56)')
% ylabel('RL Learning Rate')
% axis([0 30 -5 20])
% title(cb)
% saveas(gcf,strcat(figpath,'/RL_group_ICARSLimb_v_LrnRate.fig'))
% saveas(gcf,strcat(figpath,'/RL_group_ICARSLimb_v_LrnRate.pdf'))


%%%%%% 6. NON-MOTOR REWARD LEARNING CORRELATIONS %%%%%%

cbidx=find(CB(:,35)~=0);
cnidx=find(CN(:,35)~=0);
cbrows=find(iwg_sc(:,1)==1);
cnrows=find(iwg_sc(:,1)==0);
x1(1:length(cbidx))=1;
x2(1:length(cnidx))=2;
cb_iwg=iwg_sc(cbrows,2:end)-iwg_sc(cbrows,2);
cn_iwg=iwg_sc(cnrows,2:end)-iwg_sc(cnrows,2);    


figure(35) %point of indiffernce vs. RL total learning
hold on
cbidx=find(CB(:,35)~=0);
cnidx=find(CN(:,35)~=0);
[coef,S]=polyfit(CB(cbidx,35),CB(cbidx,28),1);
cb_lin=polyval(coef,CB(cbidx,35));
[r,p,rl,ru]=corrcoef(CB(cbidx,35),CB(cbidx,28));
r2=1-(S.normr/norm(CB(cbidx,28)-mean(CB(cbidx,28))))^2; %R squared
cb=strcat('CB: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(CN(cnidx,35),CN(cnidx,28),1);
% cn_lin=polyval(coef,CN(cnidx,35));
% [r,p,rl,ru]=corrcoef(CN(cnidx,35),CN(cnidx,28));
% r2=1-(S.normr/norm(CN(cnidx,28)-mean(CN(cnidx,28))))^2; %R squared
% cn=strcat('CN: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
scatter(CB(cbidx,35),CB(cbidx,28),60,'m','filled')
scatter(CB(cbidx,35),CB(cbidx,28),60,'k')
plot(CB(cbidx,35),cb_lin,'m','LineWidth',1.5)
% scatter(CN(cnidx,35),CN(cnidx,28),60,'k','filled')
% scatter(CN(cnidx,35),CN(cnidx,28),60,'k')
% plot(CN(cnidx,35),cn_lin,'k','LineWidth',1.5)
xlabel('Point of Indifference')
ylabel('RL Total Learning')
axis([-20 20 -5 20])
% title(strcat(cb,' ',cn))
saveas(gcf,strcat(figpath,'/RL_CB_NMPOI_v_TotalLrn.fig'))
saveas(gcf,strcat(figpath,'/RL_CB_NMPOI_v_TotalLrn.pdf'))

figure(36) %IWG score Final vs. RL total learning
hold on
[coef,S]=polyfit(cb_iwg(:,end),CB(cbidx,28),1);
cb_lin=polyval(coef,cb_iwg(:,end));
[r,p,rl,ru]=corrcoef(cb_iwg(:,end),CB(cbidx,28));
r2=1-(S.normr/norm(CB(cbidx,28)-mean(CB(cbidx,28))))^2; %R squared
cb=strcat('CB: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(cn_iwg(:,end),CN(cnidx,28),1);
% cn_lin=polyval(coef,cn_iwg(:,end));
% [r,p,rl,ru]=corrcoef(cn_iwg(:,end),CN(cnidx,28));
% r2=1-(S.normr/norm(CN(cnidx,28)-mean(CN(cnidx,28))))^2; %R squared
% cn=strcat('CN: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
scatter(cb_iwg(:,end),CB(cbidx,28),60,'m','filled')
scatter(cb_iwg(:,end),CB(cbidx,28),60,'k')
plot(cb_iwg(:,end),cb_lin,'m','LineWidth',1.5)
% scatter(cn_iwg(:,end),CN(cnidx,28),60,'k','filled')
% scatter(cn_iwg(:,end),CN(cnidx,28),60,'k')
% plot(cn_iwg(:,end),cn_lin,'k','LineWidth',1.5)
xlabel('IWG Score Final')
ylabel('RL Total Learning')
axis([-1500 1500 -5 20])
% title(strcat(cb,' ',cn))
saveas(gcf,strcat(figpath,'/NM_CB_IWGFinal_v_RLTotLrn.fig'))
saveas(gcf,strcat(figpath,'/NM_CB_IWGFinal_v_RLTotLrn.pdf'))

figure(37) %IWG score 25 vs. RL total learning
hold on
[coef,S]=polyfit(CB(cbidx,61),CB(cbidx,28),1);
cb_lin=polyval(coef,CB(cbidx,61));
[r,p,rl,ru]=corrcoef(CB(cbidx,61),CB(cbidx,28));
r2=1-(S.normr/norm(CB(cbidx,28)-mean(CB(cbidx,28))))^2; %R squared
cb=strcat('CB: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(cn_iwg(:,25),CN(cnidx,28),1);
% cn_lin=polyval(coef,cn_iwg(:,25));
% [r,p,rl,ru]=corrcoef(cn_iwg(:,25),CN(cnidx,28));
% r2=1-(S.normr/norm(CN(cnidx,28)-mean(CN(cnidx,28))))^2; %R squared
% cn=strcat('CN: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
scatter(CB(cbidx,61),CB(cbidx,28),60,'m','filled')
scatter(CB(cbidx,61),CB(cbidx,28),60,'k')
plot(CB(cbidx,61),cb_lin,'m','LineWidth',1.5)
% scatter(cn_iwg(:,25),CN(cnidx,28),60,'k','filled')
% scatter(cn_iwg(:,25),CN(cnidx,28),60,'k')
% plot(cn_iwg(:,25),cn_lin,'k','LineWidth',1.5)
xlabel('IWG Score at Trial 25')
ylabel('RL Total Learning')
axis([-1000 1000 -5 20])
% title(strcat(cb,' ',cn))
saveas(gcf,strcat(figpath,'/NM_CB_IWG25_v_RLTotLrn.fig'))
saveas(gcf,strcat(figpath,'/NM_CB_IWG25_v_RLTotLrn.pdf'))

figure(38) %Acquisition % Correct vs. RL total learning
hold on
cbx=mean([CB(cbidx,38),CB(cbidx,44)],2);
% cnx=mean([CN(cnidx,38),CN(cnidx,44)],2);
[coef,S]=polyfit(cbx,CB(cbidx,28),1);
cb_lin=polyval(coef,cbx);
[r,p,rl,ru]=corrcoef(cbx,CB(cbidx,28));
r2=1-(S.normr/norm(CB(cbidx,28)-mean(CB(cbidx,28))))^2; %R squared
cb=strcat('CB: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(cnx,CN(cnidx,28),1);
% cn_lin=polyval(coef,cnx);
% [r,p,rl,ru]=corrcoef(cnx,CN(cnidx,28));
% r2=1-(S.normr/norm(CN(cnidx,28)-mean(CN(cnidx,28))))^2; %R squared
% cn=strcat('CN: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
scatter(cbx,CB(cbidx,28),60,'m','filled')
scatter(cbx,CB(cbidx,28),60,'k')
plot(cbx,cb_lin,'m','LineWidth',1.5)
% scatter(cnx,CN(cnidx,28),60,'k','filled')
% scatter(cnx,CN(cnidx,28),60,'k')
% plot(cnx,cn_lin,'k','LineWidth',1.5)
xlabel('% Correct By End of Acquisition')
ylabel('RL Total Learning')
axis([30 100 -5 20])
% title(strcat(cb,' ',cn))
saveas(gcf,strcat(figpath,'/RL_CB_RevLrnAcq_v_LrnRate.fig'))
saveas(gcf,strcat(figpath,'/RL_CB_RevLrnAcq_v_LrnRate.pdf'))

figure(39) %Block 1 reversal % Correct vs. RL total learning
hold on
cbx=mean([CB(cbidx,41),CB(cbidx,47)],2);
% cnx=mean([CN(cnidx,41),CN(cnidx,47)],2);
[coef,S]=polyfit(cbx,CB(cbidx,28),1);
cb_lin=polyval(coef,cbx);
[r,p,rl,ru]=corrcoef(cbx,CB(cbidx,28));
r2=1-(S.normr/norm(CB(cbidx,28)-mean(CB(cbidx,28))))^2; %R squared
cb=strcat('CB: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
% [coef,S]=polyfit(cnx,CN(cnidx,28),1);
% cn_lin=polyval(coef,cnx);
% [r,p,rl,ru]=corrcoef(cnx,CN(cnidx,28));
% r2=1-(S.normr/norm(CN(cnidx,28)-mean(CN(cnidx,28))))^2; %R squared
% cn=strcat('CN: ','r = ',num2str(r(1,2)),' p = ',num2str(p(1,2)),' R2 = ',num2str(r2));
scatter(cbx,CB(cbidx,28),60,'m','filled')
scatter(cbx,CB(cbidx,28),60,'k')
plot(cbx,cb_lin,'m','LineWidth',1.5)
% scatter(cnx,CN(cnidx,28),60,'k','filled')
% scatter(cnx,CN(cnidx,28),60,'k')
% plot(cnx,cn_lin,'k','LineWidth',1.5)
xlabel('% Correct in Block 1 of Reversal')
ylabel('Motor RL Total Learning')
axis([30 100 -5 20])
% title(strcat(cb,' ',cn))
saveas(gcf,strcat(figpath,'/RL_CB_RevLrnRev_v_LrnRate.fig'))
saveas(gcf,strcat(figpath,'/RL_CB_RevLrnRev_v_LrnRate.pdf'))



