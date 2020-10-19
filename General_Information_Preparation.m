%*********************
% This code is written to convert the data of the TPOT dataset into
% MATLAB format, for easier analysis
% Most important indicators:
%           Depression: 1= Depressed, 2= Not-Depressed
%           Subject:    1= Child,     2= Mother
%           Task:       1= EPI,       2= PSI
%           Construct:  1= Pos,  2= Dis,  3=Agr,  4= Other


clear
clc
close all

%% Getting General Data - We have two sources Main: Multimodal_TPOT, supplementory 

Current_Dir=pwd;
Index=strfind(Current_Dir,'TPOT_Dataset');
Dir1=sprintf('%s/Data/',Current_Dir(1:Index+12));
% Dir1='/Users/alidarzi/Desktop/TPOT_Dataset/Data/';
Test_Info=xlsread(sprintf('%s%s',Dir1,'DatasetInfo.xlsx'));
Org_Dataset = readtable(sprintf('%s%s',Dir1,'Multimodal_TPOT.csv'));
Org_Dataset(170:end,:)=[];
Test_Info(170:end,:)=[];

%% Dropping the problematic Pairs

% Drop_Pair=[102620;108668;109885];
% Drop_Pair=[102620;108668;109885;100065;104988;106896;108418;110537;110606];
Drop_Pair=[];
for i=1:size(Drop_Pair,1)
    Idx=find(Test_Info(:,1)==Drop_Pair(i));
    Test_Info(Idx,:)=[];
    Org_Dataset(Idx,:)=[];
end

Num_Valid_Pairs=size(Test_Info,1);
Num_All=4*Num_Valid_Pairs;          % Each pair has 4 videos Child vs. Mother and EPI vs. PSI tasks

%% Making General info table 

TEMP=repmat({'---'},[Num_Valid_Pairs,1]);
TPOT_General_Info=table(Test_Info(:,1),TEMP,Org_Dataset.Child_gender);
TPOT_General_Info.Properties.VariableNames={'ID','Dep_Hist','Child_Gender'};

Dep_Map=Test_Info(:,5)==1;

TPOT_General_Info.Dep_Hist(Dep_Map)={'DEP'};
TPOT_General_Info.Dep_Hist(~Dep_Map)={'NoD'};

clear TEMP

%% Making Detail info table 

TEMP1=repmat({'-'},[Num_All,1]);
TEMP2=zeros(Num_All,1);
ID=repmat(Org_Dataset.FamId',[4,1]);
GENDER=repmat(Org_Dataset.Child_gender',[4,1]);

TPOT_Detail_Info=table(ID(:),TEMP1,TEMP1,TEMP1,GENDER(:),TEMP2,TEMP2,TEMP2,TEMP2);
TPOT_Detail_Info.Properties.VariableNames={'ID','Subject','Task','Dep_Hist','Child_Gender',...
'PANAS_Neg_Pre','PANAS_Pos_Pre','PANAS_Neg_Post','PANAS_Pos_Post'}; 

PANAS_Table=[23 26;27 30;14 17;18 21];    % The table to read PANAS scores Row1: Child-EPI, Row2: Child-PSi, Row3: Mother-EPI, Row4: Mother-PSI

for P=1:length(Test_Info)       % each test pair
    Start_Stop=4*P-3:4*P;
    
    TPOT_Detail_Info.Subject(Start_Stop)=[{'Child '};{'Child '};{'Mother'};{'Mother'}];
    TPOT_Detail_Info.Task(Start_Stop)=[{'EPI'};{'PSI'};{'EPI'};{'PSI'}];
    if Test_Info(P,5)==1
        TPOT_Detail_Info.Dep_Hist(Start_Stop)=[{'DEP'};{'DEP'};{'DEP'};{'DEP'}];
    elseif Test_Info(P,5)==2
        TPOT_Detail_Info.Dep_Hist(Start_Stop)=[{'NoD'};{'NoD'};{'NoD'};{'NoD'}];
    end
    
    TPOT_Detail_Info{Start_Stop(1),6:9}=Test_Info(P,PANAS_Table(1,1):PANAS_Table(1,2));
    TPOT_Detail_Info{Start_Stop(2),6:9}=Test_Info(P,PANAS_Table(2,1):PANAS_Table(2,2));
    TPOT_Detail_Info{Start_Stop(3),6:9}=Test_Info(P,PANAS_Table(3,1):PANAS_Table(3,2));
    TPOT_Detail_Info{Start_Stop(4),6:9}=Test_Info(P,PANAS_Table(4,1):PANAS_Table(4,2));
end

save TPOT_Info TPOT_Detail_Info TPOT_General_Info











%% Making Detail info table 

TEMP1=repmat({'-'},[Num_All,1]);
TEMP2=zeros(Num_All,1);
ID=repmat(Org_Dataset.FamId',[4,1]);
GENDER=repmat(Org_Dataset.Child_gender',[4,1]);

TPOT_Detail_Info=table(ID(:),TEMP1,TEMP1,TEMP1,GENDER(:),TEMP2,TEMP2,TEMP2,TEMP2);
TPOT_Detail_Info.Properties.VariableNames={'ID','Subject','Task','Dep_Hist','Child_Gender',...
'PANAS_Neg_Pre','PANAS_Pos_Pre','PANAS_Neg_Post','PANAS_Pos_Post'}; 

PANAS_Table=[23 26;27 30;14 17;18 21];    % The table to read PANAS scores Row1: Child-EPI, Row2: Child-PSi, Row3: Mother-EPI, Row4: Mother-PSI

for P=1:length(Test_Info)       % each test pair
    Start_Stop=4*P-3:4*P;
    
    TPOT_Detail_Info.Subject(Start_Stop)=[{'Child '};{'Child '};{'Mother'};{'Mother'}];
    TPOT_Detail_Info.Task(Start_Stop)=[{'EPI'};{'PSI'};{'EPI'};{'PSI'}];
    if Test_Info(P,5)==1
        TPOT_Detail_Info.Dep_Hist(Start_Stop)=[{'DEP'};{'DEP'};{'DEP'};{'DEP'}];
    elseif Test_Info(P,5)==2
        TPOT_Detail_Info.Dep_Hist(Start_Stop)=[{'NoD'};{'NoD'};{'NoD'};{'NoD'}];
    end
    
    TPOT_Detail_Info{Start_Stop(1),6:9}=Test_Info(P,PANAS_Table(1,1):PANAS_Table(1,2));
    TPOT_Detail_Info{Start_Stop(2),6:9}=Test_Info(P,PANAS_Table(2,1):PANAS_Table(2,2));
    TPOT_Detail_Info{Start_Stop(3),6:9}=Test_Info(P,PANAS_Table(3,1):PANAS_Table(3,2));
    TPOT_Detail_Info{Start_Stop(4),6:9}=Test_Info(P,PANAS_Table(4,1):PANAS_Table(4,2));
end

%% Raw - AU intensity

Dir2='/Users/alidarzi/Desktop/TPOT_Dataset/Data/AU_Intensity/';
Data=zeros(4*length(Test_Info),5);
PANAS=zeros(4*length(Test_Info),4);
PANAS_Table=[23 26;27 30;14 17;18 21];    % The table to read PANAS scores 

for P=1:length(Test_Info)       % each test pair
    TT=num2str(Test_Info(P,1));
    TT=TT(3:end);

    for S=2:2       % each subject 1: Child, 2: Mother
       for T=2:2        % each task 1:EPI, 2: PSI
           Task=sprintf('0%d',T);
           Count1=4*P+2*S+T-6;
           Name(Count1,:)=sprintf('%s%d_%s_01',TT,S,Task);
           load(sprintf('%s%s_norm/au6/combined_ordinal.mat',Dir2,Name(Count1,:)));
           AU6=double(est_int); clear est_int
           load(sprintf('%s%s_norm/au10/combined_ordinal.mat',Dir2,Name(Count1,:)));
           AU10=double(est_int); clear est_int
           load(sprintf('%s%s_norm/au12/combined_ordinal.mat',Dir2,Name(Count1,:)));
           AU12=double(est_int); clear est_int
           load(sprintf('%s%s_norm/au14/combined_ordinal.mat',Dir2,Name(Count1,:)));
           AU14=double(est_int); clear est_int
           Data(Count1,:)=[Test_Info(P,5),Mean_AU6,Mean_AU10,Mean_AU12,Mean_AU14];
           Count2=2*S+T-2;
           PANAS(Count1,:)=Test_Info(P,PANAS_Table(Count2,1):PANAS_Table(Count2,2));
       end
    end
end                            
                                
%% Time and Construct of Mother and Child                                        
                                
load Construct        % Have have access to Construct and Construct_Pair_ID for 160 pairs
                                
%% Time and Speaker Turn



            











TPOT_General=table(Name,Data(:,1),Data(:,2),Data(:,3),Data(:,4),Data(:,5),...
                PANAS(:,1),PANAS(:,2),PANAS(:,3),PANAS(:,4));
TPOT_General.Properties.VariableNames={'ID','Dep_Hist','AU6','AU10','AU12','AU14',...
                                    'N_Pre','P_Pre','N_Post','P_Post'};  











