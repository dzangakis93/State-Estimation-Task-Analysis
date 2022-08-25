clear all; close all; clc;
subj='CN16';
[fileName,filePath]=uigetfile({'*.csv';},'Select Participant Data',strcat(pwd,'/OnlineStudyData/',subj)) %select file to open
file=strcat(filePath,fileName);
opts = detectImportOptions(file);
opts = setvartype(opts,'string');  % or 'string'
% opts.SelectedVariableNames={'name' 'rname' 'key_resp.keys' 'rkey_resp.keys' 'revTotal'};
td=readtable(file,opts);
md=readtable(file);
clear opts fileName
%%Initialize vars

highCorrect=0;
lowCorrect=0;
highProb(1:6,1)=[1:6];
lowProb(1:6,1)=[1:6];
deckCount1=0;
deckCount2=0;
deckCount3=0;
deckCount4=0;
%initialize empty matricies
corrRew{1,1}=zeros(30,4);
corrRew{1,2}=zeros(30,4);
corrRew{1,3}=zeros(30,4);
corrNoRew{1,1}=zeros(30,4);
corrNoRew{1,2}=zeros(30,4);
corrNoRew{1,3}=zeros(30,4);
incorrect{1,1}=zeros(30,4);
incorrect{1,2}=zeros(30,4);
incorrect{1,3}=zeros(30,4);
%%util data pulled by column
util{:,1}=rmmissing(md.choice_key_keys); %key choice
util{:,2}=rmmissing(md.choice_key_rt); %reaction time
util{:,3}=rmmissing(md.fixedVal); %fixed value
util{:,4}=rmmissing(md.gambleVal1); %gamble value
util{:,5}=rmmissing(md.headerText);%Header Question

%find attention check rows
attentionCheck=strcmp(util{:,5},'If you are paying attention, choose the gamble!'); 
attentionPass=find(attentionCheck);
attentionCount=0;
for n=1:length(attentionPass)
    if strcmp(util{1,1}(attentionPass(n,1)),'j')==1
        attentionCount=attentionCount+1;
    end
end
%Remove attentioncheck from cell
for i=1:5
util{1,i}(attentionCheck,:)=[];
end
clear attentionCheck
for i=1:length(util{1,3})
    util{1,6}(i,1)=util{1,3}(i,1)-(util{1,4}(i,1)/2); %diff between fixed & expected value
end
utilProb(:,1)=util{1,1};
utilProb(:,2)=num2cell(util{1,6});
%sort by expected value
utilProb=sortrows(utilProb,2); 
gambleCount=0;
for n=1:11 %number of expected values
    for i=14*(n-1)+1:14*(n-1)+14
        if strcmp(utilProb(i,1),'j')==1
            gambleCount=gambleCount+1;
        end 
        gambleProb(n,1)=gambleCount/14;    
    end
    gambleCount=0;
end
clear gambleCount
expected=[-30 -20 -15 -10 -5 0 5 10 15 20 30];
[coeffs, curve,stats]=FitPsycheCurveLogit(expected',gambleProb,ones(11,1));
psycurve={coeffs,curve,stats,expected,gambleProb'};


% %IGT data by column
igt{:,1}=rmmissing(md.mouse_2_time); %reaction time
igt{:,2}=rmmissing(md.mouse_2_clicked_name); %deck clicked
igt{:,3}=rmmissing(md.trialnet); %net value
igt{:,4}=rmmissing(md.mycurrent); %total value

deck1=strcmp(igt{1,2},'deck1');
deck2=strcmp(igt{1,2},'deck2');
deck3=strcmp(igt{1,2},'deck3');
deck4=strcmp(igt{1,2},'deck4');
%Get running probability of selecting each deck
for i=1:length(deck1)
  if deck1(i,1)==1
      deckCount1=deckCount1+1;
    elseif deck2(i,1)==1
      deckCount2=deckCount2+1;
    elseif deck3(i,1)==1
      deckCount3=deckCount3+1;
    elseif deck4(i,1)==1
      deckCount4=deckCount4+1;
  end
    igtProb(i,1)=deckCount1/i;
    igtProb(i,2)=deckCount2/i;
    igtProb(i,3)=deckCount3/i;
    igtProb(i,4)=deckCount4/i;
end

%acq data by column
acq{:,1}=rmmissing(md.key_resp_corr); %correct answer [0 1]
acq{:,2}=rmmissing(md.key_resp_rt);  %reaction time
acq{:,3}=rmmissing(md.total);  %total value
acq{:,4}=rmmissing(md.reward); %Reward received or not [0 1]
acq{:,5}=rmmissing(td.name);   %letter name [a,b,c,d]
acq{:,6}=rmmissing(md.value);  %letter value [0.2,0.05]
acq{1,7}=rmmissing(td.key_resp_keys); %get key response
%sort by letter
idxA=find(strcmp(acq{1,5},'a'));
idxB=find(strcmp(acq{1,5},'b'));
idxC=find(strcmp(acq{1,5},'c'));
idxD=find(strcmp(acq{1,5},'d'));
idx=[idxA idxB idxC idxD];

acqRt5(1,1)=mean(acq{1,2}(idx(1:10,1:2),1));
acqRt5(1,2)=mean(acq{1,2}(idx(11:20,1:2),1));
acqRt5(1,3)=mean(acq{1,2}(idx(21:30,1:2),1));
acqRt20(1,1)=mean(acq{1,2}(idx(1:10,3:4),1));
acqRt20(1,2)=mean(acq{1,2}(idx(11:20,3:4),1));
acqRt20(1,3)=mean(acq{1,2}(idx(21:30,3:4),1));



countCorrect=[0 0 0 0; 0 0 0 0; 0 0 0 0];
for n=1:4 %loop through each letter
    for b=1:3 %loop through each block
        for i=(b-1)*10+1:(b-1)*10+10 %loop through block
            if acq{1,1}(idx(i,n),1)==1 %if correct answer
                countCorrect(b,n)=countCorrect(b,n)+1;
                    if acq{1,4}(idx(i,n),1)==1
                            %get index number where correct sorted by
                            %letter and block
                            corrRew{1,b}(i,n)=idx(i,n); 
                    end
                    if acq{1,4}(idx(i,n),1)==0
                            corrNoRew{1,b}(i,n)=idx(i,n);
                    end
            elseif acq{1,1}(idx(i,n),1)==0
                incorrect{1,b}(i,n)=idx(i,n);
            end
        end
        probAcq(b,n)=countCorrect(b,n)/10*100;
    end
end


sumCR=0;
sumC=0;
sumI=0;
for b=1:3
    for n=1:4 % go through each letter
        if b<3
            for i=(b-1)*10+1:(b-1)*10+10 %find switch/stay for correct&reward
                if find(corrRew{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(acq{1,7}(idx(i,n),1),acq{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumCR=sumCR+1; %sum up each time there's a change
                    end
                end  
                if find(corrNoRew{1,b}(:,n)==idx(i,n)) %find indices for correct no reward reward in index matrix
                    if strcmp(acq{1,7}(idx(i,n),1),acq{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumC=sumC+1; %sum up each time there's a change
                    end
                end
                if find(incorrect{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(acq{1,7}(idx(i,n),1),acq{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumI=sumI+1; %sum up each time there's a change
                    end
                end
            end
        end
        if b==3
            for i=(b-1)*10+1:(b-1)*10+9 %find switch/stay for correct&reward
                if find(corrRew{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(acq{1,7}(idx(i,n),1),acq{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumCR=sumCR+1; %sum up each time there's a change
                    end
                end  
                if find(corrNoRew{1,b}(:,n)==idx(i,n)) %find indices for correct no reward reward in index matrix
                    if strcmp(acq{1,7}(idx(i,n),1),acq{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumC=sumC+1; %sum up each time there's a change
                    end
                end
                if find(incorrect{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(acq{1,7}(idx(i,n),1),acq{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumI=sumI+1; %sum up each time there's a change
                    end
                end
            end
        end
    end
    if b<3
        corrRewProb(1,b)=sumCR/40; %number of times choice was changed after correct and reward
        corrProb(1,b)=sumC/40;
        incorrectProb(1,b)=sumI/40;
    elseif b==3
        corrRewProb(1,b)=sumCR/36; %number of times choice was changed after correct and reward
        corrProb(1,b)=sumC/36;
        incorrectProb(1,b)=sumI/36;
    end
    sumCR=0; %reset sum value for each letter this needs to change from letter to block
    sumC=0; %reset sum value for each letter this needs to change from letter to block
    sumI=0; %reset sum value for each letter this needs to change from letter to block
end

%Bin Reaction time by block
acqRt(1,1)=mean(acq{1,2}(1:40,1));
acqRt(1,2)=mean(acq{1,2}(41:80,1));
acqRt(1,3)=mean(acq{1,2}(81:120,1));
clear idxA idxB idxC idxD
rev{:,1}=rmmissing(md.rkey_resp_corr); %response
rev{:,2}=rmmissing(md.rkey_resp_rt);   %reaction time
rev{:,3}=rmmissing(td.revTotal);   %total value
rev{:,4}=rmmissing(md.revReward);  %Reward received?
rev{:,5}=rmmissing(td.rname);      % letter name
rev{:,6}=rmmissing(md.rvalue);     %letter value
rev{:,7}=rmmissing(td.rkey_resp_keys); %key pressed

%sort by letter
idxA=find(strcmp(rev{1,5},'a'));
idxB=find(strcmp(rev{1,5},'b'));
idxC=find(strcmp(rev{1,5},'c'));
idxD=find(strcmp(rev{1,5},'d'));
idx=[idxA idxB idxC idxD];
clear idxA idxB idxC idxD

revRt5(1,1)=mean(rev{1,2}(idx(1:10,1:2),1));
revRt5(1,2)=mean(rev{1,2}(idx(11:20,1:2),1));
revRt5(1,3)=mean(rev{1,2}(idx(21:30,1:2),1));
revRt20(1,1)=mean(rev{1,2}(idx(1:10,3:4),1));
revRt20(1,2)=mean(rev{1,2}(idx(11:20,3:4),1));
revRt20(1,3)=mean(rev{1,2}(idx(21:30,3:4),1));

countCorrect=[0 0 0 0; 0 0 0 0; 0 0 0 0];
for n=1:4 %loop through each letter
    for b=1:3 %loop through each block
        for i=(b-1)*10+1:(b-1)*10+10 %loop through block
            if rev{1,1}(idx(i,n),1)==1 %if correct answer
                countCorrect(b,n)=countCorrect(b,n)+1;
                    if rev{1,4}(idx(i,n),1)==1
                            %get index number where correct sorted by
                            %letter and block
                            corrRew{1,b}(i,n)=idx(i,n); 
                    end
                    if rev{1,4}(idx(i,n),1)==0
                            corrNoRew{1,b}(i,n)=idx(i,n);
                    end
            elseif rev{1,1}(idx(i,n),1)==0
                incorrect{1,b}(i,n)=idx(i,n);
            end
        end
        probRev(b,n)=countCorrect(b,n)/10*100;
    end
end


sumCR=0;
sumC=0;
sumI=0;
for b=1:3
    for n=1:4 % go through each letter
        if b<3
            for i=(b-1)*10+1:(b-1)*10+10 %find switch/stay for correct&reward
                if find(corrRew{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(rev{1,7}(idx(i,n),1),rev{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumCR=sumCR+1; %sum up each time there's a change
                    end
                end  
                if find(corrNoRew{1,b}(:,n)==idx(i,n)) %find indices for correct no reward reward in index matrix
                    if strcmp(rev{1,7}(idx(i,n),1),rev{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumC=sumC+1; %sum up each time there's a change
                    end
                end
                if find(incorrect{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(rev{1,7}(idx(i,n),1),rev{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumI=sumI+1; %sum up each time there's a change
                    end
                end
            end
        end
        if b==3
            for i=(b-1)*10+1:(b-1)*10+9 %find switch/stay for correct&reward
                if find(corrRew{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(rev{1,7}(idx(i,n),1),rev{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumCR=sumCR+1; %sum up each time there's a change
                    end
                end  
                if find(corrNoRew{1,b}(:,n)==idx(i,n)) %find indices for correct no reward reward in index matrix
                    if strcmp(rev{1,7}(idx(i,n),1),rev{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumC=sumC+1; %sum up each time there's a change
                    end
                end
                if find(incorrect{1,b}(:,n)==idx(i,n)) %find indices for correct reward in index matrix
                    if strcmp(rev{1,7}(idx(i,n),1),rev{1,7}(idx(i+1,n),1))==0 %check if input key changes from from one trial to next for a given letter
                        sumI=sumI+1; %sum up each time there's a change
                    end
                end
            end
        end
    end
    if b<3
    corrRewProb(1,b+3)=sumCR/40; %number of times choice was changed after correct and reward
    corrProb(1,b+3)=sumC/40;
    incorrectProb(1,b+3)=sumI/40;
    elseif b==3
        corrRewProb(1,b+3)=sumCR/36; %number of times choice was changed after correct and reward
        corrProb(1,b+3)=sumC/36;
        incorrectProb(1,b+3)=sumI/36;
    end
    sumCR=0; %reset sum value for each letter this needs to change from letter to block
    sumC=0; %reset sum value for each letter this needs to change from letter to block
    sumI=0; %reset sum value for each letter this needs to change from letter to block
end
switchStayProb=[corrRewProb corrProb incorrectProb];
 
%calculate bonus money earned from online task:
igtMoney=igt{1,4}(100,1)/1000; %igt score total divided by 1000
revMoney=str2num(rev{1,3}(120,1))/10; %rev learning money total divided by 10
bonusMoney=igtMoney+revMoney; 
while bonusMoney <7.50 %loop through random utility trials to add bonus money until sum is > $7.50
    i=randi([1 154]);
    if strcmp(util{1,1}(i,1),'f')==1
        bonusMoney=bonusMoney+(util{1,3}(i,1)/100);
    
    elseif strcmp(util{1,1}(i,1),'j')==1
        g=randi([0 1]);
        if g==1
            bonusMoney=bonusMoney+(util{1,4}(i,1)/100);
        end
    end
end
%Bin reaction time
revRt(1,1)=mean(rev{1,2}(1:40,1));
revRt(1,2)=mean(rev{1,2}(41:80,1));
revRt(1,3)=mean(rev{1,2}(81:120,1));

%clear unneeded vars
clear idxA idxB idxC idxD 
saveLocation=strcat(pwd,'/OnlineAnalysisOutputs')
path=strcat(saveLocation,'/',subj);
fig_path=strcat(path,'/Figures');
if~isfolder(path)
    mkdir(path);
end
if ~isfolder(fig_path)
    mkdir(fig_path);
end


%%  Plots
% figure(1) %IGT Score
% hold on
% plot(1:100,igt{1,4}(:,1));
% title('Iowa Gambling Task Score by Trial');
% xlabel('Trial Number');
% ylabel('Score');
% ylim([min(igt{1,4}(:,1)),max(igt{1,4}(:,1))])
% saveas(figure(1),strcat(fig_path,'/IGT_Score.fig'))
% saveas(figure(1),strcat(fig_path,'/IGT_Score.pdf'))
% 
% 
% 
% 
% figure(2)
% hold on
% a=plot(1:3,probAcq(1:3,1),'r');
% b=plot(1:3,probAcq(1:3,2),'y');
% c=plot(1:3,probAcq(1:3,3),'b');
% d=plot(1:3,probAcq(1:3,4),'c');
% plot(4:6,probRev(1:3,1),'r');
% plot(4:6,probRev(1:3,2),'y');
% plot(4:6,probRev(1:3,3),'b');
% plot(4:6,probRev(1:3,4),'c');
% xline(3.5,'--')
% legend([a b c d],{'Letter 1 $0.05', 'Letter 2 $0.05' , 'Letter 3 $0.20', 'Letter 4 $0.20'})
% legend('location', 'eastoutside')
% title('Percentage of Correct Response by Letter')
% ylim([0,100])
% xlim([1 6])
% xlabel({'Blocks','Acquisition                                                      Reversal'})
% ylabel('Percent Correct')
% set(gca,'xtick',1:6)
% saveas(figure(2),strcat(fig_path,'/RevLearn_Probability.fig'))
% saveas(figure(2),strcat(fig_path,'/RevLearn_Probability.pdf'))
% 
% figure(3)
% hold on
% plot(1:100,igtProb(:,1),'k');
% plot(1:100,igtProb(:,2),'r');
% plot(1:100,igtProb(:,3),'b');
% plot(1:100,igtProb(:,4),'y');
% legend ('deck 1', 'deck 2', 'deck 3' , 'deck 4')
% legend('location', 'best')
% title('Deck Choice Probability by Trial')
% ylabel('Deck Probability')
% xlabel('Trial Number')
% saveas(figure(3),strcat(fig_path,'/IGT_Probability.fig'))
% saveas(figure(3),strcat(fig_path,'/IGT_Probability.pdf'))
% 
% figure(4)
% hold on
% plot(psycurve{1,2}(:,1),psycurve{1,2}(:,2))
% scatter(psycurve{1,4},psycurve{1,5})
% yline(0.5,'--')
% title('Gamble Probability')
% xlabel('Difference Between Fixed and Expected Gamble Values')
% ylabel('Probability of Choosing Gamble')
% saveas(figure(4),strcat(fig_path,'/Utility_Probability.fig'))
% saveas(figure(4),strcat(fig_path,'/Utility_Probability.pdf'))
% 
% figure (5)
% hold on
% title('Reversal Learning Switch/Stay Probability')
% p1=plot(1:3, corrRewProb(1,1:3),'g')
% p2=plot(1:3, corrProb(1,1:3),'b')
% p3=plot(1:3, incorrectProb(1,1:3),'r')
% plot(4:6, corrRewProb(1,4:6),'g')
% plot(4:6, corrProb(1,4:6),'b')
% plot(4:6, incorrectProb(1,4:6),'r')
% xline(3.5,'--')
% set(gca,'xtick',1:6)
% legend([p1 p2 p3],{'Correct reward', 'Correct no reward' , 'Incorrect'})
% legend('location', 'eastoutside')
% ylabel('Switch Probability')
% xlabel({'Blocks','Acquisition                                                      Reversal'})
% saveas(figure(5),strcat(fig_path,'/RevLearn_SwitchStay.fig'))
% saveas(figure(5),strcat(fig_path,'/RevLearn_SwitchStay.pdf'))
% 
% bonusMoney=round(bonusMoney,2)
% set up saving data here:


data.util{1,1}='Key Choice';
data.util{1,2}='Reaction Time';
data.util{1,3}='Psycurve';
data.util{1,4}='GambleProb';
data.util{2,1}=util{1,1};
data.util{2,2}=util{1,2};
data.util{2,3}=psycurve;
data.util{2,4}=gambleProb;
data.igt=igt;
data.igt{1,5}=igtProb;
data.revLearn.acq=acq;
data.revLearn.acqReact5=acqRt5;
data.revLearn.acqReact20=acqRt20;
data.revLearn.acqprob=probAcq;
data.revLearn.rev=rev;
data.revLearn.revReact5=revRt5;
data.revLearn.revReact20=revRt20;
data.revLearn.revprob=probRev;
data.revLearn.switchprob=switchStayProb;
data.bonusMoney=bonusMoney;
data.subj=subj;
save(strcat(path,'/data.mat'),'data')







