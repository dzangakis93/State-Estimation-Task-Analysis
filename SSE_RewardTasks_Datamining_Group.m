clear all; close all

dataFolder='OnlineAnalysisOutputs'; %what folder is the raw data in?
subj=dir ('OnlineAnalysisOutputs');
flag=[subj.isdir];
subj=subj(flag);
subjName={subj(3:length(subj)).name};
subjNum=length(subjName)-1;
%Group Data Headers
GroupData{1,1}='Participant';
GroupData{1,2}='Point of Indifference';
GroupData{1,3}='$.20 acq slope';
GroupData{1,4}='$.05 acq slope';
GroupData{1,5}='acq mean slope';
GroupData{1,6}='$.20 rev slope';
GroupData{1,7}='$.05 rev slope';
GroupData{1,8}='mean rev slope';
GroupData{1,9}='IGT score';
GroupData{1,10}='$.20 acq %correct block 1';
GroupData{1,11}='$.20 acq %correct block 2';
GroupData{1,12}='$.20 acq %correct block 3';
GroupData{1,13}='$.05 acq %correct block 1';
GroupData{1,14}='$.05 acq %correct block 2';
GroupData{1,15}='$.05 acq %correct block 3';
GroupData{1,16}='$.20 rev %correct block 1';
GroupData{1,17}='$.20 rev %correct block 2';
GroupData{1,18}='$.20 rev %correct block 3';
GroupData{1,19}='$.05 rev %correct block 1';
GroupData{1,20}='$.05 rev %correct block 2';
GroupData{1,21}='$.05 rev %correct block 3';
GroupData{1,22}='Block 1 Reaction $0.05';
GroupData{1,23}='Block 2 Reaction $0.05';
GroupData{1,24}='Block 3 Reaction $0.05';
GroupData{1,25}='Block 4 Reaction $0.05';
GroupData{1,26}='Block 5 Reaction $0.05';
GroupData{1,27}='Block 6 Reaction $0.05';
GroupData{1,28}='Block 1 Reaction $0.20';
GroupData{1,29}='Block 2 Reaction $0.20';
GroupData{1,30}='Block 3 Reaction $0.20';
GroupData{1,31}='Block 4 Reaction $0.20';
GroupData{1,32}='Block 5 Reaction $0.20';
GroupData{1,33}='Block 6 Reaction $0.20';
GroupData{1,34}='IGT Score Timeseries';
GroupData{1,35}='IGT Reaction Timeseries';
GroupData{1,36}='Deck 1 Probability Timeseries';
GroupData{1,37}='Deck 2 Probability Timeseries';
GroupData{1,38}='Deck 3 Probability Timeseries';
GroupData{1,39}='Deck 4 Probability Timeseries';



%% Loop through data
for ns=1:subjNum
load(strcat(pwd,'/',dataFolder,'/',subjName{1,ns},'/Data.mat'))
%% separate CN data
if contains(data.subj,'CN') 
    CNigtScore(:,ns)=data.igt{1,4}(:,1); 
    CNigtReact(:,ns)=data.igt{1,1}(:,1);
    CNacqSwitch(:,ns)=data.revLearn.switchprob(1,:);
    CNgambleProb(:,ns)=data.util{2,3}{1,5}(1,:);
    CNindiff(:,ns)=data.util{2,3}{1,3}(1,2); 
    
    CNacqProb(1:3,ns)=data.revLearn.acqprob(1:3,1);
    CNacqProb(4:6,ns)=data.revLearn.acqprob(1:3,2);
    CNacqProb(7:9,ns)=data.revLearn.acqprob(1:3,3);
    CNacqProb(10:12,ns)=data.revLearn.acqprob(1:3,4);
    CNreact5(1:3,ns)=data.revLearn.acqReact5;
    CNreact5(4:6,ns)=data.revLearn.revReact5;
    CNreact20(1:3,ns)=data.revLearn.acqReact20;
    CNreact20(4:6,ns)=data.revLearn.revReact20;
    
   
    

    GroupData{ns+1,3}=((CNacqProb(12,ns)+CNacqProb(9,ns))/2-(CNacqProb(10,ns)+CNacqProb(7,ns))/2)/2;%acq 20
    GroupData{ns+1,4}=((CNacqProb(6,ns)+CNacqProb(3,ns))/2-(CNacqProb(4,ns)+CNacqProb(1,ns))/2)/2; %acq5
    GroupData{ns+1,5}=(GroupData{ns+1,3}+GroupData{ns+1,4})/2;
    % % correct by block
    GroupData{ns+1,10}=(CNacqProb(10,ns)+CNacqProb(7,ns))/2; %acq20 block 1
    GroupData{ns+1,11}=(CNacqProb(11,ns)+CNacqProb(8,ns))/2; %acq20 block 2
    GroupData{ns+1,12}=(CNacqProb(12,ns)+CNacqProb(9,ns))/2; %acq20 block 3
    GroupData{ns+1,13}=(CNacqProb(4,ns)+CNacqProb(1,ns))/2; %acq5 1
    GroupData{ns+1,14}=(CNacqProb(5,ns)+CNacqProb(2,ns))/2; %acq5 2
    GroupData{ns+1,15}=(CNacqProb(6,ns)+CNacqProb(3,ns))/2; %acq5 3
    
    CNrevProb(1:3,ns)=data.revLearn.revprob(1:3,1);
    CNrevProb(4:6,ns)=data.revLearn.revprob(1:3,2);
    CNrevProb(7:9,ns)=data.revLearn.revprob(1:3,3);
    CNrevProb(10:12,ns)=data.revLearn.revprob(1:3,4);
    GroupData{ns+1,6}=((CNrevProb(12,ns)+CNrevProb(9,ns))/2-(CNrevProb(10,ns)+CNrevProb(7,ns))/2)/2;%rev20
    GroupData{ns+1,7}=((CNrevProb(6,ns)+CNrevProb(3,ns))/2-(CNrevProb(4,ns)+CNrevProb(1,ns))/2)/2; %rev5
    GroupData{ns+1,8}=(GroupData{ns+1,6}+GroupData{ns+1,7})/2;
    
    % % correct by block
    GroupData{ns+1,16}=(CNrevProb(10,ns)+CNrevProb(7,ns))/2; %rev20 block 1
    GroupData{ns+1,17}=(CNrevProb(11,ns)+CNrevProb(8,ns))/2; %rev20 block 2
    GroupData{ns+1,18}=(CNrevProb(12,ns)+CNrevProb(9,ns))/2; %rev20 block 3
    GroupData{ns+1,19}=(CNrevProb(4,ns)+CNrevProb(1,ns))/2; %rev5 1
    GroupData{ns+1,20}=(CNrevProb(5,ns)+CNrevProb(2,ns))/2; %rev5 2
    GroupData{ns+1,21}=(CNrevProb(6,ns)+CNrevProb(3,ns))/2; %rev5 3
    
    CNacqReaction(:,ns)=data.revLearn.acq{1,2}(:,1);
    CNrevReaction(:,ns)=data.revLearn.rev{1,2}(:,1);
    
    CNigtProbA(:,ns)=data.igt{1,5}(:,1);
    CNigtProbB(:,ns)=data.igt{1,5}(:,2);
    CNigtProbC(:,ns)=data.igt{1,5}(:,3);
    CNigtProbD(:,ns)=data.igt{1,5}(:,4);
    
    %organize percent corret by reward value
    %5 cent rewards
    %block 1
    CNacqReward5(1,ns)=CNacqProb(1,ns);
    CNacqReward5(2,ns)=CNacqProb(4,ns);
    %block 2
    CNacqReward5(3,ns)=CNacqProb(2,ns);
    CNacqReward5(4,ns)=CNacqProb(5,ns);
    %block 3
    CNacqReward5(5,ns)=CNacqProb(3,ns);
    CNacqReward5(6,ns)=CNacqProb(6,ns);
    %20 cent rewards
    %block 1
    CNacqReward20(1,ns)=CNacqProb(7,ns);
    CNacqReward20(2,ns)=CNacqProb(10,ns);
    %block 2
    CNacqReward20(3,ns)=CNacqProb(8,ns);
    CNacqReward20(4,ns)=CNacqProb(11,ns);
    %block 3
    CNacqReward20(5,ns)=CNacqProb(9,ns);
    CNacqReward20(6,ns)=CNacqProb(12,ns);
    
    %5 cent rewards rev
    %block 1
    CNrevReward5(1,ns)=CNrevProb(1,ns);
    CNrevReward5(2,ns)=CNrevProb(4,ns);
    %block 2
    CNrevReward5(3,ns)=CNrevProb(2,ns);
    CNrevReward5(4,ns)=CNrevProb(5,ns);
    %block 3
    CNrevReward5(5,ns)=CNrevProb(3,ns);
    CNrevReward5(6,ns)=CNrevProb(6,ns);
    %20 cent rewards
    %block 1
    CNrevReward20(1,ns)=CNrevProb(7,ns);
    CNrevReward20(2,ns)=CNrevProb(10,ns);
    %block 2
    CNrevReward20(3,ns)=CNrevProb(8,ns);
    CNrevReward20(4,ns)=CNrevProb(11,ns);
    %block 3
    CNrevReward20(5,ns)=CNrevProb(9,ns);
    CNrevReward20(6,ns)=CNrevProb(12,ns);
    
    
end
%% CB data
if contains(data.subj,'CB')
    CBigtScore(:,ns)=data.igt{1,4}(:,1);
    CBigtReact(:,ns)=data.igt{1,1}(:,1);
    CBacqSwitch(:,ns)=data.revLearn.switchprob(1,:);
    CBgambleProb(:,ns)=data.util{2,3}{1,5}(1,:);
    CBindiff(:,ns)=data.util{2,3}{1,3}(1,2);
    
    CBacqProb(1:3,ns)=data.revLearn.acqprob(1:3,1);
    CBacqProb(4:6,ns)=data.revLearn.acqprob(1:3,2);
    CBacqProb(7:9,ns)=data.revLearn.acqprob(1:3,3);
    CBacqProb(10:12,ns)=data.revLearn.acqprob(1:3,4);
    CBreact5(1:3,ns)=data.revLearn.acqReact5;
    CBreact5(4:6,ns)=data.revLearn.revReact5;
    CBreact20(1:3,ns)=data.revLearn.acqReact20;
    CBreact20(4:6,ns)=data.revLearn.revReact20;
    GroupData{ns+1,3}=((CBacqProb(12,ns)+CBacqProb(9,ns))/2-(CBacqProb(10,ns)+CBacqProb(7,ns))/2)/2; %acq20
    GroupData{ns+1,4}=((CBacqProb(6,ns)+CBacqProb(3,ns))/2-(CBacqProb(4,ns)+CBacqProb(1,ns))/2)/2; %acq5
    GroupData{ns+1,5}=(GroupData{ns+1,3}+GroupData{ns+1,4})/2;
    
    GroupData{ns+1,10}=(CBacqProb(10,ns)+CBacqProb(7,ns))/2; %acq20 block 1
    GroupData{ns+1,11}=(CBacqProb(11,ns)+CBacqProb(8,ns))/2; %acq20 block 2
    GroupData{ns+1,12}=(CBacqProb(12,ns)+CBacqProb(9,ns))/2; %acq20 block 3
    GroupData{ns+1,13}=(CBacqProb(4,ns)+CBacqProb(1,ns))/2; %acq5 1
    GroupData{ns+1,14}=(CBacqProb(5,ns)+CBacqProb(2,ns))/2; %acq5 2
    GroupData{ns+1,15}=(CBacqProb(6,ns)+CBacqProb(3,ns))/2; %acq5 3
    
    CBrevProb(1:3,ns)=data.revLearn.revprob(1:3,1);
    CBrevProb(4:6,ns)=data.revLearn.revprob(1:3,2);
    CBrevProb(7:9,ns)=data.revLearn.revprob(1:3,3);
    CBrevProb(10:12,ns)=data.revLearn.revprob(1:3,4);
    GroupData{ns+1,6}=((CBrevProb(12,ns)+CBrevProb(9,ns))/2-(CBrevProb(10,ns)+CBrevProb(7,ns))/2)/2; %rev20
    GroupData{ns+1,7}=((CBrevProb(6,ns)+CBrevProb(3,ns))/2-(CBrevProb(4,ns)+CBrevProb(1,ns))/2)/2; %rev5
    GroupData{ns+1,8}=(GroupData{ns+1,6}+GroupData{ns+1,7})/2;
    
     % % correct by block
    GroupData{ns+1,16}=(CBrevProb(10,ns)+CBrevProb(7,ns))/2; %rev20 block 1
    GroupData{ns+1,17}=(CBrevProb(11,ns)+CBrevProb(8,ns))/2; %rev20 block 2
    GroupData{ns+1,18}=(CBrevProb(12,ns)+CBrevProb(9,ns))/2; %rev20 block 3
    GroupData{ns+1,19}=(CBrevProb(4,ns)+CBrevProb(1,ns))/2; %rev5 1
    GroupData{ns+1,20}=(CBrevProb(5,ns)+CBrevProb(2,ns))/2; %rev5 2
    GroupData{ns+1,21}=(CBrevProb(6,ns)+CBrevProb(3,ns))/2; %rev5 3
    
    CBacqReaction(:,ns)=data.revLearn.acq{1,2}(:,1);
    CBrevReaction(:,ns)=data.revLearn.rev{1,2}(:,1);
    
    CBigtProbA(:,ns)=data.igt{1,5}(:,1);
    CBigtProbB(:,ns)=data.igt{1,5}(:,2);
    CBigtProbC(:,ns)=data.igt{1,5}(:,3);
    CBigtProbD(:,ns)=data.igt{1,5}(:,4);
    
     %organize percent corret by reward value
    %5 cent rewards
    %block 1
    CBacqReward5(1,ns)=CBacqProb(1,ns);
    CBacqReward5(2,ns)=CBacqProb(4,ns);
    %block 2
    CBacqReward5(3,ns)=CBacqProb(2,ns);
    CBacqReward5(4,ns)=CBacqProb(5,ns);
    %block 3
    CBacqReward5(5,ns)=CBacqProb(3,ns);
    CBacqReward5(6,ns)=CBacqProb(6,ns);
    %20 cent rewards
    %block 1
    CBacqReward20(1,ns)=CBacqProb(7,ns);
    CBacqReward20(2,ns)=CBacqProb(10,ns);
    %block 2
    CBacqReward20(3,ns)=CBacqProb(8,ns);
    CBacqReward20(4,ns)=CBacqProb(11,ns);
    %block 3
    CBacqReward20(5,ns)=CBacqProb(9,ns);
    CBacqReward20(6,ns)=CBacqProb(12,ns);
    
     %5 cent rewards rev
    %block 1
    CBrevReward5(1,ns)=CBrevProb(1,ns);
    CBrevReward5(2,ns)=CBrevProb(4,ns);
    %block 2
    CBrevReward5(3,ns)=CBrevProb(2,ns);
    CBrevReward5(4,ns)=CBrevProb(5,ns);
    %block 3
    CBrevReward5(5,ns)=CBrevProb(3,ns);
    CBrevReward5(6,ns)=CBrevProb(6,ns);
    %20 cent rewards
    %block 1
    CBrevReward20(1,ns)=CBrevProb(7,ns);
    CBrevReward20(2,ns)=CBrevProb(10,ns);
    %block 2
    CBrevReward20(3,ns)=CBrevProb(8,ns);
    CBrevReward20(4,ns)=CBrevProb(11,ns);
    %block 3
    CBrevReward20(5,ns)=CBrevProb(9,ns);
    CBrevReward20(6,ns)=CBrevProb(12,ns);
end
%% All participant data
igtScore(:,ns)=data.igt{1,4}(:,1);
igtReaction(:,ns)=data.igt{1,1}(:,1);
acqSwitch(:,ns)=data.revLearn.switchprob(1,:);
gambleProb(:,ns)=data.util{2,3}{1,5}(1,:);
indiff(:,ns)=data.util{2,3}{1,3}(1,2);
acqProb(1:3,ns)=data.revLearn.acqprob(1:3,1);
acqProb(4:6,ns)=data.revLearn.acqprob(1:3,2);
acqProb(7:9,ns)=data.revLearn.acqprob(1:3,3);
acqProb(10:12,ns)=data.revLearn.acqprob(1:3,4);

revProb(1:3,ns)=data.revLearn.revprob(1:3,1);
revProb(4:6,ns)=data.revLearn.revprob(1:3,2);
revProb(7:9,ns)=data.revLearn.revprob(1:3,3);
revProb(10:12,ns)=data.revLearn.revprob(1:3,4);

acqReaction(:,ns)=data.revLearn.acq{1,2}(:,1);
revReaction(:,ns)=data.revLearn.rev{1,2}(:,1);

 igtProbA(:,ns)=data.igt{1,5}(:,1);
 GroupData{ns+1,36}=igtProbA(:,ns);
 igtProbB(:,ns)=data.igt{1,5}(:,2);
 GroupData{ns+1,37}=igtProbB(:,ns);
 igtProbC(:,ns)=data.igt{1,5}(:,3);
 GroupData{ns+1,38}=igtProbC(:,ns);
 igtProbD(:,ns)=data.igt{1,5}(:,4);
 GroupData{ns+1,39}=igtProbD(:,ns);
 
 %GroupData
 GroupData{ns+1,1}=subjName{1,ns};
 GroupData{ns+1,9}=data.igt{1,4}(100,1);
 GroupData{ns+1,2}=data.util{2,3}{1,3}(1,2);
 GroupData{ns+1,22}=data.revLearn.acqReact5(1,1);
 GroupData{ns+1,23}=data.revLearn.acqReact5(1,2);
 GroupData{ns+1,24}=data.revLearn.acqReact5(1,3);
 GroupData{ns+1,25}=data.revLearn.revReact5(1,1);
 GroupData{ns+1,26}=data.revLearn.revReact5(1,2);
 GroupData{ns+1,27}=data.revLearn.revReact5(1,3);
 GroupData{ns+1,28}=data.revLearn.acqReact20(1,1);
 GroupData{ns+1,29}=data.revLearn.acqReact20(1,2);
 GroupData{ns+1,30}=data.revLearn.acqReact20(1,3);
 GroupData{ns+1,31}=data.revLearn.revReact20(1,1);
 GroupData{ns+1,32}=data.revLearn.revReact20(1,2);
 GroupData{ns+1,33}=data.revLearn.revReact20(1,3);
 GroupData{ns+1,34}=data.igt{1,4};
 GroupData{ns+1,35}=data.igt{1,1};
end


%% Organize Data
%clear empty columns
CNindiff(:,all(CNigtScore==0))=[];%this didnt work with all(CNindiff==0) for some reason
CNigtReact(:,all(CNigtScore==0))=[];
CNigtScore(:,all(CNigtScore==0))=[];
CBigtReact(:,all(CBigtScore==0))=[];
CBigtScore(:,all(CBigtScore==0))=[];



CNacqSwitch(:,all(CNacqSwitch==0))=[];
CBacqSwitch(:,all(CBacqSwitch==0))=[];

CNgambleProb(:,all(CNgambleProb==0))=[];
CBgambleProb(:,all(CBgambleProb==0))=[];

CBacqProb(:,all(CBacqProb==0))=[];
CNacqProb(:,all(CNacqProb==0))=[];
CNreact5(:,all(CNreact5==0))=[];
CNreact20(:,all(CNreact20==0))=[];
CBreact5(:,all(CBreact5==0))=[];
CBreact20(:,all(CBreact20==0))=[];

CBrevProb(:,all(CBrevProb==0))=[];
CNrevProb(:,all(CNrevProb==0))=[];

CNacqReward5(:,all(CNacqReward5==0))=[];
CNacqReward20(:,all(CNacqReward20==0))=[];
CBacqReward5(:,all(CBacqReward5==0))=[];
CBacqReward20(:,all(CBacqReward20==0))=[];

CNrevReward5(:,all(CNrevReward5==0))=[];
CNrevReward20(:,all(CNrevReward20==0))=[];
CBrevReward5(:,all(CBrevReward5==0))=[];
CBrevReward20(:,all(CBrevReward20==0))=[];


CBindiff(:,all(CBindiff==0))=[];

CNigtProbA(:,all(CNigtProbA==0))=[];
CNigtProbB(:,all(CNigtProbB==0))=[];
CNigtProbC(:,all(CNigtProbC==0))=[];
CNigtProbD(:,all(CNigtProbD==0))=[];

CBigtProbA(:,all(CBigtProbA==0))=[];
CBigtProbB(:,all(CBigtProbB==0))=[];
CBigtProbC(:,all(CBigtProbC==0))=[];
CBigtProbD(:,all(CBigtProbD==0))=[];

%get width +1 for column of means
CNwidth=width(CNigtScore)+1;
CBwidth=width(CBigtScore)+1;

%IGT score means
CNigtError=std(CNigtScore,0,2)/sqrt(CNwidth-1);
CNigtScore(:,CNwidth)=mean(CNigtScore,2);
CBigtError=std(CBigtScore,0,2)/sqrt(CBwidth-1);
CBigtScore(:,CBwidth)=mean(CBigtScore,2);
igtScore(:,length(subjName))=mean(igtScore,2);
%% Reversal Learning
%Reversal learning switch/stay means and standard error
for n=1:18
CNswitchError(n,1)=std(CNacqSwitch(n,1:CNwidth-1))/sqrt(CNwidth-1);
CBswitchError(n,1)=std(CNacqSwitch(n,1:CNwidth-1))/sqrt(CBwidth-1);
end
CNacqSwitch(:,CNwidth)=mean(CNacqSwitch,2);
CBacqSwitch(:,CBwidth)=mean(CBacqSwitch,2);
acqSwitch(:,length(subjName))=mean(acqSwitch,2);

%reversal learning percent correct   means
CNacqProb(:,CNwidth)=mean(CNacqProb,2);
CNrevProb(:,CNwidth)=mean(CNrevProb,2);  
CBacqProb(:,CBwidth)=mean(CBacqProb,2);
CBrevProb(:,CBwidth)=mean(CBrevProb,2);
acqProb(:,length(subjName))=mean(acqProb,2);
revProb(:,length(subjName))=mean(revProb,2);

%reversal learning means by reward value/condition
acq5(1:3,1)=acqProb(1:3,subjNum);
acq5(1:3,2)=acqProb(4:6,subjNum);
acq5=mean(acq5,2);

rev5(1:3,1)=revProb(1:3,subjNum);
rev5(1:3,2)=revProb(4:6,subjNum);
rev5=mean(rev5,2);

acq20(1:3,1)=acqProb(7:9,subjNum);
acq20(1:3,2)=acqProb(10:12,subjNum);
rev20(1:3,1)=revProb(7:9,subjNum);
rev20(1:3,2)=revProb(10:12,subjNum);
rev20=mean(rev20,2);

CNacq5(1:3,1)=CNacqProb(1:3,CNwidth);
CNacq5(1:3,2)=CNacqProb(4:6,CNwidth);
CNacq5=mean(CNacq5,2);
CNrev5(1:3,1)=CNrevProb(1:3,CNwidth);
CNrev5(1:3,2)=CNrevProb(4:6,CNwidth);
CNrev5=mean(CNrev5,2);

CNacq20(1:3,1)=CNacqProb(7:9,CNwidth);
CNacq20(1:3,2)=CNacqProb(10:12,CNwidth);
CNrev20(1:3,1)=CNrevProb(7:9,CNwidth);
CNrev20(1:3,2)=CNrevProb(10:12,CNwidth);
CNrev20=mean(CNrev20,2);

CBacq5(1:3,1)=CBacqProb(1:3,CBwidth);
CBacq5(1:3,2)=CBacqProb(4:6,CBwidth);
CBacq5=mean(CBacq5,2);
CBrev5(1:3,1)=CBrevProb(1:3,CBwidth);
CBrev5(1:3,2)=CBrevProb(4:6,CBwidth);
CBrev5=mean(CBrev5,2);

CBacq20(1:3,1)=CBacqProb(7:9,CBwidth);
CBacq20(1:3,2)=CBacqProb(10:12,CBwidth);
CBrev20(1:3,1)=CBrevProb(7:9,CBwidth);
CBrev20(1:3,2)=CBrevProb(10:12,CBwidth);
CBrev20=mean(CBrev20,2);

CNindiff(1,CNwidth)=mean(CNindiff,2);
CBindiff(1,CBwidth)=mean(CBindiff,2);
indiff(1,length(subjName))=mean(indiff,2);

CNreact5(:,CNwidth)=mean(CNreact5,2);
CNreact20(:,CNwidth)=mean(CNreact20,2);
CBreact5(:,CBwidth)=mean(CBreact5,2);
CBreact20(:,CBwidth)=mean(CBreact20,2);



 %% %standard errors
%acq
CNacq5StandardError(1,1)=std([CNacqReward5(1,:) CNacqReward5(2,:)])/sqrt(CNwidth-1);
CNacq5StandardError(2,1)=std([CNacqReward5(3,:) CNacqReward5(4,:)])/sqrt(CNwidth-1);
CNacq5StandardError(3,1)=std([CNacqReward5(5,:) CNacqReward5(6,:)])/sqrt(CNwidth-1);
CNacq20StandardError(1,1)=std([CNacqReward20(1,:) CNacqReward20(2,:)])/sqrt(CNwidth-1);
CNacq20StandardError(2,1)=std([CNacqReward20(3,:) CNacqReward20(4,:)])/sqrt(CNwidth-1);
CNacq20StandardError(3,1)=std([CNacqReward20(5,:) CNacqReward20(6,:)])/sqrt(CNwidth-1);

CBacq5StandardError(1,1)=std([CBacqReward5(1,:) CBacqReward5(2,:)])/sqrt(CBwidth-1);
CBacq5StandardError(2,1)=std([CBacqReward5(3,:) CBacqReward5(4,:)])/sqrt(CBwidth-1);
CBacq5StandardError(3,1)=std([CBacqReward5(5,:) CBacqReward5(6,:)])/sqrt(CBwidth-1);
CBacq20StandardError(1,1)=std([CBacqReward20(1,:) CBacqReward20(2,:)])/sqrt(CBwidth-1);
CBacq20StandardError(2,1)=std([CBacqReward20(3,:) CBacqReward20(4,:)])/sqrt(CBwidth-1);
CBacq20StandardError(3,1)=std([CBacqReward20(5,:) CBacqReward20(6,:)])/sqrt(CBwidth-1);
%rev
CNrev5StandardError(1,1)=std([CNrevReward5(1,:) CNrevReward5(2,:)])/sqrt(CNwidth-1);
CNrev5StandardError(2,1)=std([CNrevReward5(3,:) CNrevReward5(4,:)])/sqrt(CNwidth-1);
CNrev5StandardError(3,1)=std([CNrevReward5(5,:) CNrevReward5(6,:)])/sqrt(CNwidth-1);
CNrev20StandardError(1,1)=std([CNrevReward20(1,:) CNrevReward20(2,:)])/sqrt(CNwidth-1);
CNrev20StandardError(2,1)=std([CNrevReward20(3,:) CNrevReward20(4,:)])/sqrt(CNwidth-1);
CNrev20StandardError(3,1)=std([CNrevReward20(5,:) CNrevReward20(6,:)])/sqrt(CNwidth-1);

CBrev5StandardError(1,1)=std([CBrevReward5(1,:) CBrevReward5(2,:)])/sqrt(CBwidth-1);
CBrev5StandardError(2,1)=std([CBrevReward5(3,:) CBrevReward5(4,:)])/sqrt(CBwidth-1);
CBrev5StandardError(3,1)=std([CBrevReward5(5,:) CBrevReward5(6,:)])/sqrt(CBwidth-1);
CBrev20StandardError(1,1)=std([CBrevReward20(1,:) CBrevReward20(2,:)])/sqrt(CBwidth-1);
CBrev20StandardError(2,1)=std([CBrevReward20(3,:) CBrevReward20(4,:)])/sqrt(CBwidth-1);
CBrev20StandardError(3,1)=std([CBrevReward20(5,:) CBrevReward20(6,:)])/sqrt(CBwidth-1);

CNigtProbStandardError(:,1)=std(CNigtProbA,0,2)/sqrt(CNwidth-1);
CNigtProbStandardError(:,2)=std(CNigtProbB,0,2)/sqrt(CNwidth-1);
CNigtProbStandardError(:,3)=std(CNigtProbC,0,2)/sqrt(CNwidth-1);
CNigtProbStandardError(:,4)=std(CNigtProbD,0,2)/sqrt(CNwidth-1);

CBigtProbStandardError(:,1)=std(CBigtProbA,0,2)/sqrt(CBwidth-1);
CBigtProbStandardError(:,2)=std(CBigtProbB,0,2)/sqrt(CBwidth-1);
CBigtProbStandardError(:,3)=std(CBigtProbC,0,2)/sqrt(CBwidth-1);
CBigtProbStandardError(:,4)=std(CBigtProbD,0,2)/sqrt(CBwidth-1);
%% IGT
%reaction Time means
CNigtReact(:,CNwidth)=mean(CNigtReact,2);
CBigtReact(:,CBwidth)=mean(CBigtReact,2);
%igt deck probability means
CNigtProbA=mean(CNigtProbA,2);
CNigtProbB=mean(CNigtProbB,2);
CNigtProbC=mean(CNigtProbC,2);
CNigtProbD=mean(CNigtProbD,2);

CBigtProbA=mean(CBigtProbA,2);
CBigtProbB=mean(CBigtProbB,2);
CBigtProbC=mean(CBigtProbC,2);
CBigtProbD=mean(CBigtProbD,2);

igtProbA=mean(igtProbA,2);
igtProbB=mean(igtProbB,2);
igtProbC=mean(igtProbC,2);
igtProbD=mean(igtProbD,2);
%% Prep Psycurve
%psycurve stError
% for n=1:11 
% CNpsycurveError(n,1)=std(CNgambleProb(n,:))/sqrt(CNwidth-1);
% CBpsycurveError(n,1)=std(CBgambleProb(n,:))/sqrt(CBwidth-1);
% end
% %psycurve means 
% CNgambleProb(:,CNwidth)=mean(CNgambleProb,2);
% CBgambleProb(:,CBwidth)=mean(CBgambleProb,2);
% gambleProb(:,length(subjName))=mean(gambleProb,2);
% %run psycurve function for all three conditions
% expected=[-30 -20 -15 -10 -5 0 5 10 15 20 30];
% [coeffs, curve,stats]=FitPsycheCurveLogit(expected',gambleProb(:,width(gambleProb)),ones(11,1));
% psycurve={coeffs,curve,stats,expected,gambleProb(:,width(gambleProb))'};
% 
% 
% [coeffs, curve,stats]=FitPsycheCurveLogit(expected',CBgambleProb(:,CBwidth),ones(11,1));
% CBpsycurve={coeffs,curve,stats,expected,CBgambleProb(:,CBwidth)'};
% 
% 
% [coeffs, curve,stats]=FitPsycheCurveLogit(expected',CNgambleProb(:,CNwidth),ones(11,1));
% CNpsycurve={coeffs,curve,stats,expected,CNgambleProb(:,CNwidth)'};

%% %plots%
figure(1) %IGT score CN/CB
hold on
x1=1:100;
x2=[x1,fliplr(x1)];
y1=(CNigtScore+CNigtError)';
y2=(CNigtScore-CNigtError)';
inbetween=[y1,fliplr(y2)];
% fill(x2,inbetween,'b')
% y1=(CBigtScore+CBigtError)';
% y2=(CBigtScore-CBigtError)';
% inbetween=[y1,fliplr(y2)];
% fill(x2,inbetween,'r')
for n=1:(width(CNigtScore)-1)
plot(1:100,CNigtScore(:,n),'b');
end
for n=1:(width(CBigtScore)-1)
plot(1:100,CBigtScore(:,n),'r');
end
title('IGT Score by Trial')
xlabel('Trial Number')
ylabel('Score')
legend('CN Mean','CB Mean')
legend('location','best')


figure(3) % Mean Switch Prob reversal learning CN
subplot(2,1,1)
p1=errorbar(1:3,CNacqSwitch(1:3,width(CNacqSwitch)),CNswitchError(1:3,1),'g');
hold on
errorbar(4:6,CNacqSwitch(4:6,width(CNacqSwitch)),CNswitchError(4:6,1),'g')
p2=errorbar(1:3,CNacqSwitch(7:9,width(CNacqSwitch)),CNswitchError(7:9,1),'b');
errorbar(4:6,CNacqSwitch(10:12,width(CNacqSwitch)),CNswitchError(10:12,1),'b')
p3=errorbar(1:3,CNacqSwitch(13:15,width(CNacqSwitch)),CNswitchError(13:15,1),'r');
errorbar(4:6,CNacqSwitch(16:18,width(CNacqSwitch)),CNswitchError(16:18,1),'r')
xline(3.5,'--')
set(gca,'xtick',1:6)
title('CN Mean Reversal Learning Switch/Stay Probability')
ylabel('Switch Probability')
xlabel({'Blocks','Acquisition                                                      Reversal'})
ylim([0 0.35])
subplot(2,1,2)
p1=errorbar(1:3,CBacqSwitch(1:3,width(CBacqSwitch)),CBswitchError(1:3,1),'g');
hold on
errorbar(4:6,CBacqSwitch(4:6,width(CBacqSwitch)),CBswitchError(4:6,1),'g')
p2=errorbar(1:3,CBacqSwitch(7:9,width(CBacqSwitch)),CBswitchError(7:9,1),'b');
errorbar(4:6,CBacqSwitch(10:12,width(CBacqSwitch)),CBswitchError(10:12,1),'b')
p3=errorbar(1:3,CBacqSwitch(13:15,width(CBacqSwitch)),CBswitchError(13:15,1),'r');
errorbar(4:6,CBacqSwitch(16:18,width(CBacqSwitch)),CBswitchError(16:18,1),'r')
xline(3.5,'--')
set(gca,'xtick',1:6)
legend([p1 p2 p3],{'Correct reward', 'Correct no reward' , 'Incorrect'})
legend('location', 'northoutside')
title(' CB Mean Reversal Learning Switch/Stay Probability')
ylim([0 0.35])


% 
% figure(8) %psycurve by condition
% hold on
% p1=plot(CNpsycurve{1,2}(:,1),CNpsycurve{1,2}(:,2));
% p2=errorbar(CNpsycurve{1,4},CNpsycurve{1,5},CNpsycurveError,'o');
% p3=plot(CBpsycurve{1,2}(:,1),CBpsycurve{1,2}(:,2));
% p4=errorbar(CBpsycurve{1,4},CBpsycurve{1,5},CBpsycurveError,'o');
% yline(0.5,'--')
% legend([p1 p2 p3 p4], {'CN', 'CN', 'CB' ,'CB'})
% legend('location','eastoutside')
% title('Gamble Probability')
% xlabel('Difference Between Fixed and Expected Gamble Values')
% ylabel('Probability of Choosing Gamble')

figure(9)% mean percent correct by reward value
hold on
a=plot(1:3,acq5(1:3,1),'b');
plot(4:6,rev5(1:3,1),'b')
b=plot(1:3,acq20(1:3,1),'r');
plot(4:6,rev20(1:3,1),'r')
xline(3.5,'--')
set(gca,'xtick',1:6)
legend([a b],{'$0.05 Reward' '$0.20 Reward'})
legend('location', 'best')
title('Mean Reversal Learning Percent Correct by Reward Value')
ylabel('Percent Correct')
xlabel({'Blocks','Acquisition                                                      Reversal'})

figure(10)%percent correct by reward value
subplot(1,2,1)
hold on
scatter(ones([1,CNwidth-1]),(CNacqProb(1,1:CNwidth-1)+CNacqProb(4,1:CNwidth-1))/2,'b','filled')
scatter(ones([1,CBwidth-1]),(CBacqProb(1,1:CBwidth-1)+CBacqProb(4,1:CBwidth-1))/2,'r')
scatter(2*ones([1,CNwidth-1]),(CNacqProb(2,1:CNwidth-1)+CNacqProb(5,1:CNwidth-1))/2,'b','filled')
scatter(2*ones([1,CBwidth-1]),(CBacqProb(2,1:CBwidth-1)+CBacqProb(5,1:CBwidth-1))/2,'r')
scatter(3*ones([1,CNwidth-1]),(CNacqProb(3,1:CNwidth-1)+CNacqProb(6,1:CNwidth-1))/2,'b','filled')
scatter(3*ones([1,CBwidth-1]),(CBacqProb(3,1:CBwidth-1)+CBacqProb(6,1:CBwidth-1))/2,'r')
scatter(4*ones([1,CNwidth-1]),(CNrevProb(1,1:CNwidth-1)+CNrevProb(4,1:CNwidth-1))/2,'b','filled')
scatter(4*ones([1,CBwidth-1]),(CBrevProb(1,1:CBwidth-1)+CBrevProb(4,1:CBwidth-1))/2,'r')
scatter(5*ones([1,CNwidth-1]),(CNrevProb(2,1:CNwidth-1)+CNrevProb(5,1:CNwidth-1))/2,'b','filled')
scatter(5*ones([1,CBwidth-1]),(CBrevProb(2,1:CBwidth-1)+CBrevProb(5,1:CBwidth-1))/2,'r')
scatter(6*ones([1,CNwidth-1]),(CNrevProb(3,1:CNwidth-1)+CNrevProb(6,1:CNwidth-1))/2,'b','filled')
scatter(6*ones([1,CBwidth-1]),(CBrevProb(3,1:CBwidth-1)+CBrevProb(6,1:CBwidth-1))/2,'r')


errorbar(1:3,CNacq5(1:3,1),CNacq5StandardError,'b');
errorbar(4:6,CNrev5(1:3,1),CNrev5StandardError,'b')
errorbar(4:6,CBrev5(1:3,1),CBrev5StandardError,'r')
errorbar(1:3,CBacq5(1:3,1),CBacq5StandardError,'r');
xline(3.5,'--')
set(gca,'xtick',1:6)
title('Mean Reversal Learning Percent Correct $0.05')
ylabel('Percent Correct')
xlabel({'Blocks','Acquisition                                                      Reversal'})
ylim([20 100])
subplot(1,2,2)

hold on
scatter(ones([1,CNwidth-1]),(CNacqProb(7,1:CNwidth-1)+CNacqProb(10,1:CNwidth-1))/2,'b','filled')
scatter(ones([1,CBwidth-1]),(CBacqProb(7,1:CBwidth-1)+CBacqProb(10,1:CBwidth-1))/2,'r')
scatter(2*ones([1,CNwidth-1]),(CNacqProb(8,1:CNwidth-1)+CNacqProb(11,1:CNwidth-1))/2,'b','filled')
scatter(2*ones([1,CBwidth-1]),(CBacqProb(8,1:CBwidth-1)+CBacqProb(11,1:CBwidth-1))/2,'r')
scatter(3*ones([1,CNwidth-1]),(CNacqProb(9,1:CNwidth-1)+CNacqProb(12,1:CNwidth-1))/2,'b','filled')
scatter(3*ones([1,CBwidth-1]),(CBacqProb(9,1:CBwidth-1)+CBacqProb(12,1:CBwidth-1))/2,'r')
scatter(4*ones([1,CNwidth-1]),(CNrevProb(7,1:CNwidth-1)+CNrevProb(10,1:CNwidth-1))/2,'b','filled')
scatter(4*ones([1,CBwidth-1]),(CBrevProb(7,1:CBwidth-1)+CBrevProb(10,1:CBwidth-1))/2,'r')
scatter(5*ones([1,CNwidth-1]),(CNrevProb(8,1:CNwidth-1)+CNrevProb(11,1:CNwidth-1))/2,'b','filled')
scatter(5*ones([1,CBwidth-1]),(CBrevProb(8,1:CBwidth-1)+CBrevProb(11,1:CBwidth-1))/2,'r')
scatter(6*ones([1,CNwidth-1]),(CNrevProb(9,1:CNwidth-1)+CNrevProb(12,1:CNwidth-1))/2,'b','filled')
scatter(6*ones([1,CBwidth-1]),(CBrevProb(9,1:CBwidth-1)+CBrevProb(12,1:CBwidth-1))/2,'r')
a=errorbar(1:3,CNacq20(1:3,1),CNacq20StandardError,'b');
errorbar(4:6,CNrev20(1:3,1),CNrev20StandardError,'b');
b=errorbar(1:3,CBacq20(1:3,1),CBacq20StandardError,'r');
errorbar(4:6,CBrev20(1:3,1),CBrev20StandardError,'r');
xline(3.5,'--')
legend([a b],{'CN' 'CB'})
legend('location', 'best')
set(gca,'xtick',1:6)
title('Mean Reversal Learning Percent Correct $0.20')
ylabel('Percent Correct')
xlabel({'Blocks','Acquisition                                                      Reversal'})
ylim([20 100])


figure(11) %plot point of indifference
hold on
b1=bar(1,CNindiff(1,CNwidth),'r','FaceAlpha',.5);
b2=bar(2,CBindiff(1,CBwidth),'b','FaceAlpha',.5);
scatter(ones([1,CNwidth-1]),CNindiff(1,1:CNwidth-1),'r')
scatter(ones(CBwidth-1,1)*2,CBindiff(1,1:CBwidth-1),'b')
xlim([0 3])
ylim([-10 16])
xticks([1 2])
xticklabels({'CN', 'CB'})
title('Point of Indifference by Condition')
ylabel('Point of Indifference')
xlabel('Condition')
legend([b1 b2],{'CN' 'CB'})

figure(12) %CN/CB deck probability
subplot(1,2,1)
plot(1:100,CNigtProbA(:,1),'k');
hold on
% x=1:100;
% x2=[x,fliplr(x)];
% y1=(CNigtProbA(:,1)+CNigtProbStandardError(:,1))';
% y2=(CNigtProbA(:,1)-CNigtProbStandardError(:,1))';
% inbetween=[y1,fliplr(y2)];
% fill(x2,inbetween,'b');
plot(1:100,CNigtProbB(:,1),'r');
% y1=(CNigtProbB(:,1)+CNigtProbStandardError(:,2))';
% y2=(CNigtProbB(:,1)-CNigtProbStandardError(:,2))';
% inbetween=[y1,fliplr(y2)];
% fill(x2,inbetween,'b');
plot(1:100,CNigtProbC(:,1),'b');
% y1=(CNigtProbC(:,1)+CNigtProbStandardError(:,3))';
% y2=(CNigtProbC(:,1)-CNigtProbStandardError(:,3))';
% inbetween=[y1,fliplr(y2)];
% fill(x2,inbetween,'b');
plot(1:100,CNigtProbD(:,1),'g');
% y1=(CNigtProbD(:,1)+CNigtProbStandardError(:,4))';
% y2=(CNigtProbD(:,1)-CNigtProbStandardError(:,4))';
% inbetween=[y1,fliplr(y2)];
% fill(x2,inbetween,'b');
title('CN Deck Choice Probability by Trial')
ylabel('Deck Probability')
xlabel('Trial Number')
subplot(1,2,2)
plot(1:100,CBigtProbA(:,1),'k');
hold on
plot(1:100,CBigtProbB(:,1),'r');
plot(1:100,CBigtProbC(:,1),'b');
plot(1:100,CBigtProbD(:,1),'g');
legend ('deck 1', 'deck 2', 'deck 3' , 'deck 4')
legend('location', 'eastoutside')
title('CB Deck Choice Probability by Trial')
ylabel('Deck Probability')
xlabel('Trial Number')



%add reaction time figure

figure(13)
hold on
plot(1:100,CNigtReact(:,CNwidth),'b');
plot(1:100,CBigtReact(:,CBwidth),'r');
ylabel('Reaction Time')
xlabel('Trial')
title('IGT Reaction Time by Group')


figure(14)
hold on
for n=1:6
scatter((4*(n-1)+1)*ones([1,CNwidth-1]),CNreact5(n,1:CNwidth-1),'r')
r=bar((4*(n-1)+1),CNreact5(n,CNwidth),'r','FaceAlpha',.5);
scatter((4*(n-1)+2)*ones([1,CBwidth-1]),CBreact5(n,1:CBwidth-1),'b')
b=bar((4*(n-1)+2),CBreact5(n,CBwidth),'b','FaceAlpha',.5);
scatter((4*(n-1)+3)*ones([1,CNwidth-1]),CNreact20(n,1:CNwidth-1),'r')
bar((4*(n-1)+3),CNreact20(n,CNwidth),'r','FaceAlpha',.5);
scatter((4*(n-1)+4)*ones([1,CBwidth-1]),CBreact20(n,1:CBwidth-1),'b')
bar((4*(n-1)+4),CBreact20(n,CBwidth),'b','FaceAlpha',.5);
end
xticks([1 3 5 7 9 11 13 15 17 19 21 23])
xticklabels({'1 $0.05','$0.20', '2 $0.05','$0.20','3 $0.05','$0.20','4 $0.05','$0.20','5 $0.05','$0.20','6 $0.05','$0.20'})
title('Reaction Times by Reward Value and Condition')
ylabel('Reaction Time(s)')
legend([r b],{'CN' 'CB'})



%% %save%
path=strcat('OnlineAnalysisOutputs/Group');
if~isfolder(path)
    mkdir(path);
end
save(strcat(pwd,'/',path,'/GroupData.mat'),'GroupData')
saveas(figure(1),strcat(pwd,'/',path,'/igtscore_Condition.fig'))
saveas(figure(1),strcat(pwd,'/',path,'/igtscore_Condition.pdf'))
% saveas(figure(2),strcat(pwd,'/',path,'/igtscore_Mean.fig'))
% saveas(figure(2),strcat(pwd,'/',path,'/igtscore_Mean.pdf'))
saveas(figure(3),strcat(pwd,'/',path,'/revlearning_switchstay_Condition.fig'))
saveas(figure(3),strcat(pwd,'/',path,'/revlearning_switchstay_Condition.pdf'))
% saveas(figure(4),strcat(pwd,'/',path,'/revlearning_switchstay_Mean.fig'))
% saveas(figure(4),strcat(pwd,'/',path,'/revlearning_switchstay_Mean.pdf'))
% saveas(figure(5),strcat(pwd,'/',path,'/revlearning_percentcorrect_Mean.fig'))
% saveas(figure(5),strcat(pwd,'/',path,'/revlearning_percentcorrect_Mean.pdf'))
% saveas(figure(6),strcat(pwd,'/',path,'/revlearning_percentcorrect_Condition.fig'))
% saveas(figure(6),strcat(pwd,'/',path,'/revlearning_percentcorrect_Condition.pdf'))
% saveas(figure(7),strcat(pwd,'/',path,'/util_psycurve_Mean.fig'))
% saveas(figure(7),strcat(pwd,'/',path,'/util_psycurve_Mean.pdf'))
% saveas(figure(8),strcat(pwd,'/',path,'/util_psycurve_Condition.fig'))
% saveas(figure(8),strcat(pwd,'/',path,'/util_psycurve_Condition.pdf'))
saveas(figure(9),strcat(pwd,'/',path,'/revlearning_rewardvalue_Mean.fig'))
saveas(figure(9),strcat(pwd,'/',path,'/revlearning_rewardvalue_Mean.pdf'))
saveas(figure(10),strcat(pwd,'/',path,'/revlearning_rewardvalue_Condition.fig'))
saveas(figure(10),strcat(pwd,'/',path,'/revlearning_rewardvalue_Condition.pdf'))
saveas(figure(11),strcat(pwd,'/',path,'/util_indifference_Condition.fig'))
saveas(figure(11),strcat(pwd,'/',path,'/util_indifference_Condition.pdf'))
saveas(figure(12),strcat(pwd,'/',path,'/igtscore_deckprob_Condition.fig'))
saveas(figure(12),strcat(pwd,'/',path,'/igtscore_deckprob_Condition.pdf'))
saveas(figure(13),strcat(pwd,'/',path,'/igt_reaction.fig'))
saveas(figure(13),strcat(pwd,'/',path,'/igt_reaction.pdf'))
saveas(figure(14),strcat(pwd,'/',path,'/reversal_reaction.fig'))
saveas(figure(14),strcat(pwd,'/',path,'/reversal_reaction.pdf'))

%figure 4 total data for rev learning switch/stay
% figure(4)
% hold on
% p1=plot(1:3,acqSwitch(1:3,width(acqSwitch)),'g');
% plot(4:6,acqSwitch(4:6,width(acqSwitch)),'g');
% p2=plot(1:3,acqSwitch(7:9,width(acqSwitch)),'b');
% plot(4:6,acqSwitch(10:12,width(acqSwitch)),'b');
% p3=plot(1:3,acqSwitch(13:15,width(acqSwitch)),'r');
% plot(4:6,acqSwitch(16:18,width(acqSwitch)),'r');
% xline(3.5,'--')
% set(gca,'xtick',1:6)
% legend([p1 p2 p3],{'Correct reward', 'Correct no reward' , 'Incorrect'})
% legend('location', 'eastoutside')
% title('Mean Reversal Learning Switch/Stay Probability')
% ylabel('Switch Probability')
% xlabel({'Blocks','Acquisition                                                      Reversal'})

% figure(5) %percent correct choice reversal learning
% hold on
% a=plot(1:3,acqProb(1:3,width(acqProb)),'r');
% b=plot(1:3,acqProb(4:6,width(acqProb)),'y');
% c=plot(1:3,acqProb(7:9,width(acqProb)),'b');
% d=plot(1:3,acqProb(10:12,width(acqProb)),'c');
% plot(4:6,revProb(1:3,width(revProb)),'r')
% plot(4:6,revProb(4:6,width(revProb)),'y')
% plot(4:6,revProb(7:9,width(revProb)),'b')
% plot(4:6,revProb(10:12,width(revProb)),'c')
% xline(3.5,'--')
% legend([a b c d],{'Letter 1 $0.05', 'Letter 2 $0.05' , 'Letter 3 $0.20', 'Letter 4 $0.20'})
% legend('location', 'eastoutside')
% title('Percentage of Correct Response by Letter')
% ylim([0,100])
% xlim([1 6])
% xlabel({'Blocks','Acquisition                                                      Reversal'})
% ylabel('Percent Correct')
% set(gca,'xtick',1:6)

% figure(6) %reversal learning % correct by condition
% subplot(1,2,1)
% plot(1:3,CNacqProb(1:3,CNwidth),'r');
% hold on
% plot(1:3,CNacqProb(4:6,CNwidth),'y');
% plot(1:3,CNacqProb(7:9,CNwidth),'b');
% plot(1:3,CNacqProb(10:12,CNwidth),'c');
% plot(4:6,CNrevProb(1:3,CNwidth),'r');
% plot(4:6,CNrevProb(4:6,CNwidth),'y');
% plot(4:6,CNrevProb(7:9,CNwidth),'b');
% plot(4:6,CNrevProb(10:12,CNwidth),'c');
% xline(3.5,'--')
% set(gca,'xtick',1:6)
% title('CN Mean Reversal Learning Percent Correct by Letter')
% ylabel('Percent Correct')
% xlabel({'Blocks','Acquisition                                                      Reversal'})
% subplot(1,2,2)
% a=plot(1:3,CBacqProb(1:3,CBwidth),'r');
% hold on
% b=plot(1:3,CBacqProb(4:6,CBwidth),'y');
% c=plot(1:3,CBacqProb(7:9,CBwidth),'b');
% d=plot(1:3,CBacqProb(10:12,CBwidth),'c');
% plot(4:6,CBrevProb(1:3,CBwidth),'r');
% plot(4:6,CBrevProb(4:6,CBwidth),'y');
% plot(4:6,CBrevProb(7:9,CBwidth),'b');
% plot(4:6,CBrevProb(10:12,CBwidth),'c');
% xline(3.5,'--')
% set(gca,'xtick',1:6)
% legend([a b c d],{'Letter 1 $0.05', 'Letter 2 $0.05' , 'Letter 3 $0.20', 'Letter 4 $0.20'})
% legend('location', 'best')
% title('CB Mean Reversal Learning Percent Correct by Letter')
% ylabel('Percent Correct')
% xlabel({'Blocks','Acquisition                                                      Reversal'})


% figure(7) %psycurve
% hold on
% plot(psycurve{1,2}(:,1),psycurve{1,2}(:,2))
% scatter(psycurve{1,4},psycurve{1,5})
% yline(0.5,'--')
% title('Gamble Probability')
% xlabel('Difference Between Fixed and Expected Gamble Values')
% ylabel('Probability of Choosing Gamble')

% figure(13) %mean deck probability
% hold on
% plot(1:100,igtProbA(:,1),'k');
% plot(1:100,igtProbB(:,1),'r');
% plot(1:100,igtProbC(:,1),'b');
% plot(1:100,igtProbD(:,1),'g');
% legend ('deck 1', 'deck 2', 'deck 3' , 'deck 4')
% legend('location', 'eastoutside')
% title('Mean Deck Choice Probability by Trial')
% ylabel('Deck Probability')
% xlabel('Trial Number')

% figure(2) %Mean IGT Score
% hold on
% plot(1:100,igtScore(:,subjNum))
% title('Mean IGT Score by Trial')
% xlabel('Trial Number')
% ylabel('Score')
% ylim([min(igtScore(:,subjNum)),max(igtScore(:,subjNum))])

