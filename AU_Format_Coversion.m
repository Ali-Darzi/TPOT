clear
clc
close all

%% Getting General Data - We have two sources Main: Multimodal_TPOT, supplementory 

Current_Dir=pwd;
Index=strfind(Current_Dir,'TPOT_Dataset');
Dir1=sprintf('%s/Data/',Current_Dir(1:Index+12));
Test_Info=xlsread(sprintf('%s%s',Dir1,'DatasetInfo.xlsx'));
Org_Dataset = readtable(sprintf('%s%s',Dir1,'Multimodal_TPOT.csv'));
Org_Dataset(170:end,:)=[];
Test_Info(170:end,:)=[];

%% Dropping the problematic Pairs

Drop_Pair=[102620;104429;108668;109885];
for i=1:size(Drop_Pair,1)
    Idx=find(Test_Info(:,1)==Drop_Pair(i));
    Test_Info(Idx,:)=[];
%     Org_Dataset(Idx,:)=[];
end

Num_Valid_Pairs=size(Test_Info,1);
Num_All=4*Num_Valid_Pairs;          % Each pair has 4 videos Child vs. Mother and EPI vs. PSI tasks


%% Individual AU Intensity

Dir2=sprintf('%sAU_Intensity/',Dir1);

for Pair=1:length(Test_Info)       % each test pair
    TT=num2str(Test_Info(Pair,1))
    TT=TT(3:end);
    AU_Pair_ID(Pair,1)=Test_Info(Pair,1);

    for Subject=1:2       % each subject 1: Child, 2: Mother
       for Task=1:2        % each task 1:EPI, 2: PSI
           Name=sprintf('%s%d_0%d_01',TT,Subject,Task);
%            Name(Count1,:)=sprintf('%s%d_%s_01',TT,Subject,Task);
           
           load(sprintf('%s%s_norm/au6/combined_ordinal.mat',Dir2,Name));
           AU6=double(est_int); clear est_int
           load(sprintf('%s%s_norm/au10/combined_ordinal.mat',Dir2,Name));
           AU10=double(est_int); clear est_int
           load(sprintf('%s%s_norm/au12/combined_ordinal.mat',Dir2,Name));
           AU12=double(est_int); clear est_int
           load(sprintf('%s%s_norm/au14/combined_ordinal.mat',Dir2,Name));
           AU14=double(est_int); clear est_int
           
           All_AUs=table(AU6',AU10',AU12',AU14');
           All_AUs.Properties.VariableNames={'AU6','AU10','AU12','AU14'};
           
           if Subject==1
               AU_Child{Pair}{Task}=All_AUs;
           elseif Subject==2
               AU_Mother{Pair}{Task}=All_AUs;
           end
           
           clear Name Data All_AUs
           
       end
    end
end                            


%% Joint AU Intensities 

for Pair=1:length(Test_Info)       % each test pair
    for Task=1:2        % each task 1:EPI, 2: PSI
        
        Data_Child=AU_Child{Pair}{Task};
        Row1=size(Data_Child,1);
        Data_Mother=AU_Mother{Pair}{Task};
        Row2=size(Data_Mother,1);
        Row=max(Row1,Row2);
        
        TEMP=zeros(Row,1);
         
        Data_Joint=table(TEMP,TEMP,TEMP,TEMP,TEMP,TEMP,TEMP,TEMP);
        Data_Joint.Properties.VariableNames={'Child_AU6','Child_AU10','Child_AU12','Child_AU14','Mother_AU6','Mother_AU10','Mother_AU12','Mother_AU14'};
        
        Data_Joint{1:Row1,1}=Data_Child{:,1};
        Data_Joint{1:Row1,2}=Data_Child{:,2};
        Data_Joint{1:Row1,3}=Data_Child{:,3};
        Data_Joint{1:Row1,4}=Data_Child{:,4};
        
        Data_Joint{1:Row2,5}=Data_Mother{:,1};
        Data_Joint{1:Row2,6}=Data_Mother{:,2};
        Data_Joint{1:Row2,7}=Data_Mother{:,3};
        Data_Joint{1:Row2,8}=Data_Mother{:,4};
        
        AU_Joint{Pair}{Task}=Data_Joint;
        
        clear Data_Child Data_Mother Data_Joint Row1 Row2 Row
        
    end
end


save AU_165 AU_Child AU_Mother AU_Joint AU_Pair_ID











