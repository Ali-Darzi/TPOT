clear
clc
close all
set(0,'defaultAxesFontSize',12)

load Construct2.mat
load('Turn_152.mat','Turn_Pair_ID','Turn_Both','Turn_Joint')
load('AU_165.mat','AU_Joint','AU_Pair_ID')
load('TPOT_Info.mat','TPOT_General_Info')

% Find Exitsing pairs in all three datasets
[T1,T2,T3]=unique([AU_Pair_ID;Construct_Pair_ID;Turn_Pair_ID]);
All_IDs=T1(accumarray(T3,1)==3);
Valid_Pairs=length(All_IDs);
clear T1 T2 T3

%% Comaprison of the length of AU/ Construct/ Turn information

for i=1:Valid_Pairs
    Index_AU=find(AU_Pair_ID==All_IDs(i));
    Index_Construct=find(Construct_Pair_ID==All_IDs(i));
    Index_Turn=find(Turn_Pair_ID==All_IDs(i));
    
    Data_AU=AU_Joint{Index_AU}{2};
    Data_Construct_Child=Construct_Child{Index_Construct};
    Data_Construct_Mother=Construct_Mother{Index_Construct};
    Data_Turn=Turn_Both{Index_Turn};
    
    SS_AU(i,:)=[0.033,size(Data_AU,1)/30];
    SS_Construt_Child(i,:)=[min(Data_Construct_Child.Start_Sec),max(Data_Construct_Child.Start_Sec)];
    SS_Construt_Mother(i,:)=[min(Data_Construct_Mother.Start_Sec),max(Data_Construct_Mother.Start_Sec)];
    SS_Turn(i,:)=[min(Data_Turn.Start_Sec),max(Data_Turn.Stop_Sec)];

    clear Index_AU Index_Construct Data_AU Data_Construct_Child Data_Construct_Mother Data_Turn
end

% Both Start and Stop time configuration: AU - Constructs - Turn
Start_Time=[SS_AU(:,1),SS_Construt_Child(:,1),SS_Construt_Mother(:,1),SS_Turn(:,1)];
Stop_Time=[SS_AU(:,2),SS_Construt_Child(:,2),SS_Construt_Mother(:,2),SS_Turn(:,2)];
Half_Length=[0 47 95 142];

figure

for j=1:3
    subplot(1,3,j)
    barh(Stop_Time(Half_Length(j)+1:Half_Length(j+1),:))
    hold on
    barh(Start_Time(Half_Length(j)+1:Half_Length(j+1),:),'w')
    set(gca,'YTick',1:Half_Length(j+1)-Half_Length(j),'YTickLabel',All_IDs(Half_Length(j)+1:Half_Length(j+1)));
    ytickangle(45)
    xlabel('Task Duration - Seconds')
    ylabel('Pairs')
    legend('Whole Video','Const-Ch','Const-Mo','Segmentation')
    xlim([0 1200])
end

%%  Finding the pairs that Turn starts after the constructs or ends before 
Start_Time=Start_Time';
Stop_Time=Stop_Time';
Start_After=All_IDs(Start_Time(4,:)>min(Start_Time(2:3,:))+5)
Ends_Before=All_IDs(Stop_Time(4,:)+5<max(Stop_Time(2:3,:)))

%% Making A Dataset As is

Counter=1;

for i=1:Valid_Pairs
    Index_General=find(TPOT_General_Info{:,1}==All_IDs(i));
    Index_AU=find(AU_Pair_ID==All_IDs(i));
    Index_Construct=find(Construct_Pair_ID==All_IDs(i));
    Index_Turn=find(Turn_Pair_ID==All_IDs(i));
    
    Data_General=TPOT_General_Info(Index_General,:);
    Data_AU=AU_Joint{Index_AU}{2};
    Data_Construct=Construct_Joint{Index_Construct};
    Data_Turn=Turn_Joint{Index_Turn};
    
    % ******** Findig the Start and Stop of the overlap between AU/ Constrcut/ and Turn
    
    Overlap_Start=max([0.0333,min(Data_Construct.Start_Sec),min(Data_Turn.Time)]);
    Overlap_Stop=min([size(Data_AU,1)/30,max(Data_Construct.Start_Sec),max(Data_Turn.Time)]);
    sprintf('Pair ID: %d, with Strat time: %d, and Stop time: %d',All_IDs(i),round(Overlap_Start),round(Overlap_Stop))
    
    %*********** Combining all Data Together ***************
    if Overlap_Stop>Overlap_Start        
        
        % Preparation of AU data
        Overlap_Start_Frame=round(Overlap_Start/(1/30));
        Overlap_Stop_Frame=round(Overlap_Stop/(1/30));
        Overlap_Length_Frame=Overlap_Stop_Frame-Overlap_Start_Frame+1;
        
        % First adding Turn Info to AUs
        Turn_Start_Row=find(Data_Turn.Frame_Index==Overlap_Start_Frame);
        Turn_Stop_Row=find(Data_Turn.Frame_Index==Overlap_Stop_Frame);

        % Now, preparing the Construct data to add
        Temp={''};
        Table_C=table(zeros(size(Data_AU,1),1),repmat(Temp,[size(Data_AU,1),1]),repmat(Temp,[size(Data_AU,1),1]));
        Table_C.Properties.VariableNames={'Frame','Child_Construct','Mother_Construct'};

        for j=1:size(Data_Construct,1)-1
            Start_Frame=round(Data_Construct.Start_Sec(j)/(1/30));
            Stop_Frame=round(Data_Construct.Start_Sec(j+1)/(1/30));
            Table_C{Start_Frame:Stop_Frame,1}=[Start_Frame:Stop_Frame]';
            Table_C{Start_Frame:Stop_Frame,2}=Data_Construct.Child_Construct(j);
            Table_C{Start_Frame:Stop_Frame,3}=Data_Construct.Mother_Construct(j);
        end

        %***** Adding All Data together *****
        Data_All=[Data_Turn(Turn_Start_Row:Turn_Stop_Row,1:2),Data_AU(Overlap_Start_Frame:Overlap_Stop_Frame,:),...
            Table_C(Overlap_Start_Frame:Overlap_Stop_Frame,2:3),Data_Turn(Turn_Start_Row:Turn_Stop_Row,3:4)];
        TPOT_Dataset{Counter}=Data_All;
        All_Pair_ID(Counter,:)=Data_General;
        Counter=Counter+1;
    else
        sprintf('There is a problematic pair. Pair ID: %d',All_IDs(i))
    end
    
    clear Index_General Index_AU Index_Construct Index_Turn 
    clear Data_General Data_AU Data_Construct Data_Turn Data_All
end

save TPOT_Dataset TPOT_Dataset All_Pair_ID


















