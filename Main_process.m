% clear
% clc
% close all
% load('Complete_Results_Raw.mat')
warning off

Fs=256;
Num_Participants=80;

%% Name of the test files
load Name_Tag

%% Preparation of the Output : The Outcomes of 
load('Short_Quest_Open.mat')
load('Short_Quest_Close.mat')
Difficulty=[Short_Quest_Open(1:6:180,:);ShQ_Self(3:8:80,:);ShQ_Random(3:8:80,:);ShQ_PE(3:8:80,:);ShQ_PEPE(3:8:80,:);ShQ_All(3:8:80,:)];
Enjoy=[Short_Quest_Open(2:6:180,:);ShQ_Self(4:8:80,:);ShQ_Random(4:8:80,:);ShQ_PE(4:8:80,:);ShQ_PEPE(4:8:80,:);ShQ_All(4:8:80,:)];
Pos_Neg=[Short_Quest_Open(3:6:180,:);ShQ_Self(5:8:80,:);ShQ_Random(5:8:80,:);ShQ_PE(5:8:80,:);ShQ_PEPE(5:8:80,:);ShQ_All(5:8:80,:)];
Intensity=[Short_Quest_Open(4:6:180,:);ShQ_Self(6:8:80,:);ShQ_Random(6:8:80,:);ShQ_PE(6:8:80,:);ShQ_PEPE(6:8:80,:);ShQ_All(6:8:80,:)];
Speed_Change=[Short_Quest_Open(5:6:180,:);ShQ_Self(7:8:80,:);ShQ_Random(7:8:80,:);ShQ_PE(7:8:80,:);ShQ_PEPE(7:8:80,:);ShQ_All(7:8:80,:)];
Paddle_Change=[Short_Quest_Open(6:6:180,:);ShQ_Self(8:8:80,:);ShQ_Random(8:8:80,:);ShQ_PE(8:8:80,:);ShQ_PEPE(8:8:80,:);ShQ_All(8:8:80,:)];

Open_Speed_Paddle=[2 2 2 3 3 3 4 4 4; 0.1 0.2 0.3 0.1 0.2 0.3 0.1 0.2 0.3];

%% Processing of tests
Game_Info{1}=zeros(80,9);
Game_Info{2}=zeros(80,9);
% Exceptions=[31 61 62];
Exceptions=0;

for i=1:Num_Participants
    if sum(Exceptions==i)==0
        i
        load(Physio{i})                     % opening the physilogical data / Eye tracker     

        %% Denoise EEG
    %     EEG=double(Raw_physiology.data(:,7:14));
    %     EOG=double(Raw_physiology.data(:,5:6));

        %% Main process of the physiological signals  

        Time_Table=[Critical_Data(1,1:2:end);Critical_Data(1,2:2:end)]';    % Making the Time Table
        Time_Drift=(Time_Table(:,2)-Time_Table(:,1)-120)/2;
        Time_Table(:,1)=Time_Table(:,1)+Time_Drift;
        Time_Table(:,2)=Time_Table(:,2)-Time_Drift;

        [Final_Eye_Tracker,PSD_NEW,Lateral_NEW,Final_ECG,Final_GSR,Final_Resp,Final_ST,Final_EOG,Corr_Coeff_New,MI_New,PSI_New,DTF_New,Disp_Ent_New,LZComplexity_New,HFD_New,KFD_New,PFD_New]=All_processor([],Raw_physiology,EYE_Tracker_Output,Time_Table,1:9,Fs,i);
      
        % For those subjects without EEG
%         [Final_Eye_Tracker,Final_ECG,Final_GSR,Final_Resp,Final_ST,Final_EOG]=All_Process_WO_EEG(Raw_physiology,EYE_Tracker_Output,Time_Table,1:9,Fs,i);
%         
        %% Organizing the data in our format

        for j=1:56
            if j<3
                D_ST{j}(:,i)=Final_ST(:,j);
            end
            if j<4
                D_Resp{j}(:,i)=Final_Resp(:,j);
                D_EOG{j}(:,i)=Final_EOG(:,j);
                D_Eye{j}(:,i)=Final_Eye_Tracker(:,j);
            end
            if j<6
                D_ECG{j}(:,i)=Final_ECG(:,j);
                D_GSR{j}(:,i)=Final_GSR(:,j); 
            end
            if j<9
              D_Disp_Ent{j}(:,i)=Disp_Ent_New{j}(:,1);
%               D_LZComplexity{j}(:,i)=LZComplexity_New{j}(:,1);
%               D_HFD{j}(:,i)=HFD_New{j}(:,1);
%               D_KFD{j}(:,i)=KFD_New{j}(:,1);
%               D_PFD{j}(:,i)=PFD_New{j}(:,1);
            end
            if j<21
                D_Lateral{fix((j-1)/5)+1}{rem((j-1),5)+1}(:,i)=Lateral_NEW{fix((j-1)/5)+1}{rem((j-1),5)+1}(:,1); 
            end
%             if j<29
%                 D_Corr{j}(:,i)=Corr_Coeff_New{j}(:,1); 
%                 D_MI{j}(:,i)=MI_New{j}(:,1); 
%                 D_PSI{j}(:,i)=PSI_New{j}(:,1); 
%             end
%             if j<41
%                 D_PSD{fix((j-1)/5)+1}{rem((j-1),5)+1}(:,i)=PSD_NEW{fix((j-1)/5)+1}{rem((j-1),5)+1}(:,1);
%             end
%             D_DTF{j}(:,i)=DTF_New{j}(:,1); 
        end

        %% Calculating the performance (Score) of the game
        Start_Score=Critical_Data(2:3,3:2:20);
        Stop_Score=Critical_Data(2:3,4:2:20);
        Diff_Score=Stop_Score-Start_Score;
        Performance(i,:)=Diff_Score(1,:)-Diff_Score(2,:);
        
        %% Recording The Game Info
        TT=Critical_Data(4:5,3:2:end);
        Game_Info{1}(i,:)=TT(1,:);
        Game_Info{2}(i,:)=TT(2,:)*10;
        
        %% Updating the Short Questionnaire Outcomes
        if i <= 30
            Order=Order_Finder(TT);
            Difficulty(i,:)=Difficulty(i,Order);
            Enjoy(i,:)=Enjoy(i,Order);
            Pos_Neg(i,:)=Pos_Neg(i,Order);
            Intensity(i,:)=Intensity(i,Order);
            Speed_Change(i,:)=Speed_Change(i,Order);
            Paddle_Change(i,:)=Paddle_Change(i,Order);
        end
    end
end

save Complete_Results_Raw D_PSD D_Lateral D_Corr D_MI D_PSI D_DTF D_Disp_Ent D_LZComplexity D_HFD D_KFD D_PFD D_ECG D_GSR D_EOG D_Resp D_Eye D_ST Performance Game_Info Difficulty Enjoy Pos_Neg Intensity Speed_Change Paddle_Change

%% plotting part

load Labels

for j=1:40
    if j<2
        plotter([zeros(18,1),BIMEO_R]','RMS of BIMEO movement')
    end
    if j<3
        TT=D_ST{j};
        plotter(TT,Label_ST{j})
    end
    if j<4
        TT=D_Resp{j};
        plotter(TT,Label_Resp{j})
        TT=D_EOG{j};
        plotter(TT,Label_EOG{j})
    end
    if j<5
        TT=D_Eye{j};
        plotter(TT,Label_Eye_tracker{j})
    end
    if j<6
        TT=D_ECG{j};
        plotter(TT,Label_ECG{j})
        TT=D_GSR{j};
        plotter(TT,Label_GSR{j})
    end
    if j<21
        TT=D_Lateral{fix((j-1)/5)+1}{rem((j-1),5)+1};
        plotter(TT,Label_Lateral{fix((j-1)/5)+1}{rem((j-1),5)+1})
    end
    TT=D_PSD{fix((j-1)/5)+1}{rem((j-1),5)+1};
    plotter(TT,Label_PSD{fix((j-1)/5)+1}{rem((j-1),5)+1})
end






























