% 
% The constructs were presented as 

clear
clc
close all

%% Getting General Data 

Dir1='/Users/alidarzi/Desktop/TPOT_Dataset/Data/';
Test_Info=xlsread(sprintf('%s%s',Dir1,'DatasetInfo.xlsx'));
Test_Info(170:end,:)=[];

Frame_Rate=29.97;

%% Dropping the problematic Pairs
Drop_Pair=[102620];%108668;109885;100065;104988;106896;108418;110537;110606];
Drop_Pair=[Drop_Pair;100404;100665;100819;101046;101980;102872;103656;104480;104710;104909]; 
Drop_Pair=[Drop_Pair;105031;108988;109524;110167;110568];  % ;100709 - Among all pairs, 100709 doe snot have info for the child
for i=1:size(Drop_Pair,1)
    Idx=find(Test_Info(:,1)==Drop_Pair(i));
    Test_Info(Idx,:)=[];
end

%% Construct of Mother and Child

Dir2='/Users/alidarzi/Desktop/TPOT_Dataset/Data/Transcription2/';

XXX=dir('/Users/alidarzi/Desktop/TPOT_Dataset/Data/Transcription2/');

for P=1:length(Test_Info)       % each test pair
    TT=num2str(Test_Info(P,1));
    All=[];
    
    % There is one file for both Mother and child - The first two digits were dropped
    Name=sprintf('%s%d_%s.txt',TT(3:6),0,'02');    
    
    for Q=1:size(XXX,1)
        if strcmp(XXX(Q).name,Name)
            XXX(Q)=[];
            break
        end
    end
    
    
    TD_All=readtable(sprintf('%s%s',Dir2,Name));
    TD_All = removevars(TD_All,{'Var2'});
    TD_All.Properties.VariableNames={'Speaker','Start_Min','Start_Sec','Stop_Min','Stop_Sec','Duration_min','Duration_Sec','Transcription'};
    
    %% Making Mother and child table separate
    Map=strcmp(TD_All.Speaker,'Parent');
    
    Turn_Mother{P}=TD_All(Map,:);
    Turn_Child{P}=TD_All(~Map,:);
    if isempty(Turn_Mother{P})
        sprintf('No Mother turn info found for the %s pair',TT)
    end
    if isempty(Turn_Child{P})
        sprintf('No child turn info found for the %s pair',TT)
    end
    %% Making Table for Both
    [Sorted,Index]=sort(TD_All.Start_Sec);
    
    TD_All=TD_All(Index,:);
    Turn_Both{P}=TD_All;
    Turn_Pair_ID(P,1)=Test_Info(P,1);
    
    %% Making Table for Joint Turn
    
    Rows=size(TD_All,1);
    Frame=[round(min(TD_All{:,3})/(1/Frame_Rate)):round(max(TD_All{:,5})/(1/Frame_Rate))]';
    Time=Frame/30;
    
    Ch_Turn=zeros(length(Frame),1);
    Mo_Turn=zeros(length(Frame),1);
    
    Start_Row=round(TD_All{:,3}/(1/Frame_Rate))-Frame(1)+1;  % Finding Start Frame
    Stop_Row=round(TD_All{:,5}/(1/Frame_Rate))-Frame(1)+1;  % Finding Stop Frame
    
    for i=1:size(TD_All,1)
        if strcmp(TD_All.Speaker(i),'Adolescent')
            Ch_Turn(Start_Row(i):Stop_Row(i))=1;
        elseif strcmp(TD_All.Speaker(i),'Parent')
            Mo_Turn(Start_Row(i):Stop_Row(i))=1;
        end   
    end
    
    TD_Joint=table(Time,Frame,Ch_Turn,Mo_Turn);
    TD_Joint.Properties.VariableNames={'Time','Frame_Index','Child_Turn','Mother_Turn'};
    Turn_Joint{P}=TD_Joint;


    clear Rows Frame Time Ch_Turn Mo_Turn Start_Row Stop_Row
end
 
 save Turn_152 Turn_Pair_ID Turn_Child Turn_Mother Turn_Both Turn_Joint


                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                