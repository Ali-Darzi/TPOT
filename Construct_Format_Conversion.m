% 
% The constructs were presented as 

clear
clc
close all

%% Getting General Data 

Dir1='/Users/alidarzi/Desktop/TPOT_Dataset/Data/';
Test_Info=xlsread(sprintf('%s%s',Dir1,'DatasetInfo.xlsx'));
Test_Info(170:end,:)=[];

%% Dropping the problematic Pairs
Drop_Pair=[106896;110606];%102620;110537;100065;108668;109885;104988;108418;
for i=1:size(Drop_Pair,1)
    Idx=find(Test_Info(:,1)==Drop_Pair(i));
    Test_Info(Idx,:)=[];
end

%% Construct of Mother and Child

Dir2='/Users/alidarzi/Desktop/TPOT_Dataset/Data/Construct/';

for P=1:length(Test_Info)       % each test pair
    TT=num2str(Test_Info(P,1));
    All=[];
    % each subject 1: Child, 2: Mother     % each task 1:EPI, 2: PSI
    P
    %% Child
    
    Task=sprintf('0%d',2);
    Name_C=sprintf('%s%d_%s',TT,1,Task);              % 1: Subject child
    TD_Child=readtable(sprintf('%s%s.txt',Dir2,Name_C));
    TD_Child = removevars(TD_Child,{'Var2'});
    Subject{1}=['Child'];
    TD_Child=[repmat(Subject,[size(TD_Child,1),1]),TD_Child];
    TD_Child.Properties.VariableNames={'Subject','Construct','Start_Min','Start_Sec'};
    [Sorted,Index1]=sort(TD_Child.Start_Sec);
    Construct_Child{P}=TD_Child(Index1,:);
    
    %% Mother
    
    Task=sprintf('0%d',2);
    Name_M=sprintf('%s%d_%s',TT,2,Task);               % 2: Subject mother
    TD_Mother=readtable(sprintf('%s%s.txt',Dir2,Name_M));
    TD_Mother = removevars(TD_Mother,{'Var2'});
    Subject{1}=['Mother'];
    TD_Mother=[repmat(Subject,[size(TD_Mother,1),1]),TD_Mother];
    TD_Mother.Properties.VariableNames={'Subject','Construct','Start_Min','Start_Sec'};
    [Sorted,Index2]=sort(TD_Mother.Start_Sec);
    Construct_Mother{P}=TD_Mother(Index2,:);
    
    %% Making Table for Both
    
    TD_All=[TD_Child;TD_Mother];
    [Sorted,Index]=sort(TD_All.Start_Sec);
    TD_All=TD_All(Index,:);
    Construct_All{P}=TD_All;
    
    %% Making Table for Joint Construct
    A{1}='';
    B=duration('00:00:00:000');
    Rows=size(TD_All,1);
    TD_Joint=table(repmat(A,[Rows,1]),repmat(A,[Rows,1]),repmat(B,[Rows,1]),zeros(Rows,1));
    TD_Joint.Properties.VariableNames={'Mother_Construct','Child_Construct','Start_Min','Start_Sec'};
    
    Condition_Child{1}=TD_Joint.Mother_Construct(1,:);  % It is Empty, To follow the format
    Condition_Mother{1}=TD_Joint.Mother_Construct(1,:);  % It is Empty, To follow the format
    
    for i=1:Rows
       if strcmp(TD_All.Subject(i),'Child')
           Condition_Child{1}=TD_All.Construct(i,:);
       else
           Condition_Mother{1}=TD_All.Construct(i,:);
       end
       TD_Joint.Mother_Construct(i,:)=Condition_Mother{1};
       TD_Joint.Child_Construct(i,:)=Condition_Child{1};
       TD_Joint.Start_Min(i,:)=TD_All.Start_Min(i,:);
       TD_Joint.Start_Sec(i,:)=TD_All.Start_Sec(i,:);
    end
    
    Construct_Joint{P}=TD_Joint;
    
    Construct_Pair_ID(P,:)=Test_Info(P,1);
    
    %% Clearing step
    clear Name_C Name_M Index Index1 Index2 TD_All TD_Child TD_Mother TD_Joint Condition_Child Condition_Mother Rows
    
end

save Construct2 Construct_Joint Construct_All  Construct_Mother Construct_Child Construct_Pair_ID


                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                