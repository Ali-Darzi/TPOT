clear
clc
close all
set(0,'defaultAxesFontSize',12)

load Construct2.mat
load('Turn_152.mat','Turn_Pair_ID','Turn_Both','Turn_Joint')
load('TPOT_Info.mat','TPOT_General_Info')

% Find Exitsing pairs in all three datasets
[T1,T2,T3]=unique([Construct_Pair_ID;Turn_Pair_ID]);
All_IDs=T1(accumarray(T3,1)==2);
All_IDs(133)=[];   % Pair 1088693 is problematic
Valid_Pairs=length(All_IDs);
clear T1 T2 T3

%% Preparign the Result tables
% One table to track the duration of talking
Mother=['Mother_Pos';'Mother_Dys';'Mother_Agr';'Mother_Oth'];
Duration_Table_Ch=table(Mother,zeros(4,1),zeros(4,1),zeros(4,1),zeros(4,1));
Duration_Table_Ch.Properties.VariableNames={'Mother','Child_Pos','Child_Dys','Child_Agr','Child_Oth'};
Duration_Table_Mo=Duration_Table_Ch;

% One table to track the numebr of turns
Turn_Num_Table_MM=Duration_Table_Ch;
Turn_Num_Table_CC=Duration_Table_Ch;
Turn_Num_Table_CM=Duration_Table_Ch;
Turn_Num_Table_MC=Duration_Table_Ch;

% One table to track the pauses
Pause_Table_MM=Duration_Table_Ch;
Pause_Table_CC=Duration_Table_Ch;
Pause_Table_CM=Duration_Table_Ch;
Pause_Table_MC=Duration_Table_Ch;

%% Comaprison of Duration of talking

for i=1:Valid_Pairs
    Index_Construct=find(Construct_Pair_ID==All_IDs(i));
    Index_Turn=find(Turn_Pair_ID==All_IDs(i));
    
    % All Construct Data that has been used
    Data_Construct_Child=Construct_Child{Index_Construct};
    Data_Construct_Mother=Construct_Mother{Index_Construct};
    Data_Construct_Joint=Construct_Joint{Index_Construct};
    Mother_Index=strcmp(Data_Construct_Joint.Mother_Construct,'Positive')+2*strcmp(Data_Construct_Joint.Mother_Construct,'Dysphoric')...
        +3*strcmp(Data_Construct_Joint.Mother_Construct,'Aggressive')+4*strcmp(Data_Construct_Joint.Mother_Construct,'Other');
    Child_Index=strcmp(Data_Construct_Joint.Child_Construct,'Positive')+2*strcmp(Data_Construct_Joint.Child_Construct,'Dysphoric')...
        +3*strcmp(Data_Construct_Joint.Child_Construct,'Aggressive')+4*strcmp(Data_Construct_Joint.Child_Construct,'Other');
    
    % Turn data that has been used
    Data_Turn=Turn_Both{Index_Turn};
    
    % Finding the overlap section
    Start_All=max([Data_Construct_Child{1,4},Data_Construct_Mother{1,4},Data_Turn{1,3}]);
    Stop_All=min([Data_Construct_Child{end,4},Data_Construct_Mother{end,4},Data_Turn{end,5}]);
    
    % Finding the duration
    Whole_Duration(i)=Stop_All-Start_All;
    
    % Which row of Construct and Turn are we talking about?
    Row_Ind_Const=min(find(Data_Construct_Joint{:,4}>Start_All))-1;
    Row_Ind_Turn=min(find(((Data_Turn.Stop_Sec>=Start_All)-(Data_Turn.Start_Sec>Start_All))==1));
    if isempty(Row_Ind_Turn)
        Row_Ind_Turn=min(find((Data_Turn.Stop_Sec>=Start_All)));
    end
    
    Construct_Flag=1;
    
    while 1==1
        
        Result_Row=Mother_Index(Row_Ind_Const);
        Result_Col=Child_Index(Row_Ind_Const)+1;
        Start=max(Data_Turn.Start_Sec(Row_Ind_Turn),Data_Construct_Joint.Start_Sec(Row_Ind_Const));
        Stop=min(Data_Turn.Stop_Sec(Row_Ind_Turn),Data_Construct_Joint.Start_Sec(Row_Ind_Const+1));
        
        % Calculation of Pause 
        if Start>Start_All && Construct_Flag==1 && Start>Data_Construct_Joint.Start_Sec(Row_Ind_Const)
            Estimated_Pause=Start-Data_Construct_Joint.Start_Sec(Row_Ind_Const);
        end
        if Stop<Stop_All && Stop<=Data_Construct_Joint.Start_Sec(Row_Ind_Const+1)
            EP1=Data_Construct_Joint.Start_Sec(Row_Ind_Const+1)-Stop;
            EP2=Data_Turn.Start_Sec(Row_Ind_Turn+1)-Stop;
            Estimated_Pause=min(EP1,EP2);
        end
        Construct_Flag=0;
        
        % Updating the result Tables
        % If Mother was talking
        if strcmp(Data_Turn.Speaker(Row_Ind_Turn),'Parent')
            Duration_Table_Mo{Result_Row,Result_Col}=Stop-Start+Duration_Table_Mo{Result_Row,Result_Col};
            
            % If next speaker is Mother as well
            if strcmp(Data_Turn.Speaker(Row_Ind_Turn+1),'Parent')
                Turn_Num_Table_MM{Result_Row,Result_Col}=Turn_Num_Table_MM{Result_Row,Result_Col}+1;
                Pause_Table_MM{Result_Row,Result_Col}=Pause_Table_MM{Result_Row,Result_Col}+Estimated_Pause;
            else
                Turn_Num_Table_MC{Result_Row,Result_Col}=Turn_Num_Table_MC{Result_Row,Result_Col}+1;
                Pause_Table_MC{Result_Row,Result_Col}=Pause_Table_MC{Result_Row,Result_Col}+Estimated_Pause;
            end
            
            % If Child was talking
        else
            Duration_Table_Ch{Result_Row,Result_Col}=Stop-Start+Duration_Table_Ch{Result_Row,Result_Col};
            % If next speaker is Mother
            if strcmp(Data_Turn.Speaker(Row_Ind_Turn+1),'Parent')
                Turn_Num_Table_CM{Result_Row,Result_Col}=Turn_Num_Table_CM{Result_Row,Result_Col}+1;
                Pause_Table_CM{Result_Row,Result_Col}=Pause_Table_CM{Result_Row,Result_Col}+Estimated_Pause;
            else
                Turn_Num_Table_CC{Result_Row,Result_Col}=Turn_Num_Table_CC{Result_Row,Result_Col}+1;
                Pause_Table_CC{Result_Row,Result_Col}=Pause_Table_CC{Result_Row,Result_Col}+Estimated_Pause;
            end
        end
        
        % if the Turn ends before Construct
        
        if Data_Turn.Stop_Sec(Row_Ind_Turn)<Data_Construct_Joint.Start_Sec(Row_Ind_Const+1)
            Row_Ind_Turn=Row_Ind_Turn+1;
            
        elseif Data_Turn.Stop_Sec(Row_Ind_Turn)>Data_Construct_Joint.Start_Sec(Row_Ind_Const+1)  
            Row_Ind_Const=Row_Ind_Const+1; 
            Construct_Flag=1;
            
        elseif Data_Turn.Stop_Sec(Row_Ind_Turn)==Data_Construct_Joint.Start_Sec(Row_Ind_Const+1)
            Row_Ind_Turn=Row_Ind_Turn+1;
            Row_Ind_Const=Row_Ind_Const+1;
            Construct_Flag=1;
            
        end
        
        if Row_Ind_Const==size(Data_Construct_Joint,1) || Row_Ind_Turn==size(Data_Turn,1)
            break
        end
        Estimated_Pause=0;
    end
    
    clear Index_Construct Index_Turn Data_Construct_Child Data_Construct_Mother Data_Construct_Joint Data_Turn Start Stop
end


%%  Plotting the calculated results

% The numebr of turns
N1=Turn_Num_Table_MM{1:4,2:5};
N2=Turn_Num_Table_MC{1:4,2:5};
N3=Turn_Num_Table_CM{1:4,2:5};
N4=Turn_Num_Table_CC{1:4,2:5};
figure
bar([N1(:),N2(:),N3(:),N4(:)])
legend('Mother-to-Mother','Mother-to-Child','Child-to-Mother','Child-to-Child')
Label=['Ch(Pos)-Mo(Pos)';'Ch(Pos)-Mo(Dys)';'Ch(Pos)-Mo(Agr)';'Ch(Pos)-Mo(Oth)';'Ch(Dys)-Mo(Pos)';'Ch(Dys)-Mo(Dys)';'Ch(Dys)-Mo(Agr)';'Ch(Dys)-Mo(Oth)';...
    'Ch(Agr)-Mo(Pos)';'Ch(Agr)-Mo(Dys)';'Ch(Agr)-Mo(Agr)';'Ch(Agr)-Mo(Oth)';'Ch(Oth)-Mo(Pos)';'Ch(Oth)-Mo(Dys)';'Ch(Oth)-Mo(Agr)';'Ch(Oth)-Mo(Oth)'];
set(gca,'XTick',1:16,'XTickLabel',Label);
xtickangle(45)
title('Number of Turns vs. Joint constructs')

% Duration of talking
T1=Duration_Table_Ch{1:4,2:5};
T2=Duration_Table_Mo{1:4,2:5};

figure
subplot(2,1,1)
bar([T1(:),T2(:)])
legend('Child Turn','Mother Turn')
Label=['Ch(Pos)-Mo(Pos)';'Ch(Pos)-Mo(Dys)';'Ch(Pos)-Mo(Agr)';'Ch(Pos)-Mo(Oth)';'Ch(Dys)-Mo(Pos)';'Ch(Dys)-Mo(Dys)';'Ch(Dys)-Mo(Agr)';'Ch(Dys)-Mo(Oth)';...
    'Ch(Agr)-Mo(Pos)';'Ch(Agr)-Mo(Dys)';'Ch(Agr)-Mo(Agr)';'Ch(Agr)-Mo(Oth)';'Ch(Oth)-Mo(Pos)';'Ch(Oth)-Mo(Dys)';'Ch(Oth)-Mo(Agr)';'Ch(Oth)-Mo(Oth)'];
set(gca,'XTick',1:16,'XTickLabel',Label);
xtickangle(45)
title('Duration of Talking vs. Joint constructs')

subplot(2,1,2)
bar([T1(:),T2(:)]./[N1(:)+N2(:),N3(:)+N4(:)])
legend('Child Turn','Mother Turn')
Label=['Ch(Pos)-Mo(Pos)';'Ch(Pos)-Mo(Dys)';'Ch(Pos)-Mo(Agr)';'Ch(Pos)-Mo(Oth)';'Ch(Dys)-Mo(Pos)';'Ch(Dys)-Mo(Dys)';'Ch(Dys)-Mo(Agr)';'Ch(Dys)-Mo(Oth)';...
    'Ch(Agr)-Mo(Pos)';'Ch(Agr)-Mo(Dys)';'Ch(Agr)-Mo(Agr)';'Ch(Agr)-Mo(Oth)';'Ch(Oth)-Mo(Pos)';'Ch(Oth)-Mo(Dys)';'Ch(Oth)-Mo(Agr)';'Ch(Oth)-Mo(Oth)'];
set(gca,'XTick',1:16,'XTickLabel',Label);
xtickangle(45)
title('Normalized Duration of Talking vs. Joint constructs')


% One table to track the pauses
P1=Pause_Table_MM{1:4,2:5};
P2=Pause_Table_MC{1:4,2:5};
P3=Pause_Table_CM{1:4,2:5};
P4=Pause_Table_CC{1:4,2:5};

figure
subplot(2,1,1)
bar([P1(:),P2(:),P3(:),P4(:)])
legend('Mother-to-Mother','Mother-to-Child','Child-to-Mother','Child-to-Child')
Label=['Ch(Pos)-Mo(Pos)';'Ch(Pos)-Mo(Dys)';'Ch(Pos)-Mo(Agr)';'Ch(Pos)-Mo(Oth)';'Ch(Dys)-Mo(Pos)';'Ch(Dys)-Mo(Dys)';'Ch(Dys)-Mo(Agr)';'Ch(Dys)-Mo(Oth)';...
    'Ch(Agr)-Mo(Pos)';'Ch(Agr)-Mo(Dys)';'Ch(Agr)-Mo(Agr)';'Ch(Agr)-Mo(Oth)';'Ch(Oth)-Mo(Pos)';'Ch(Oth)-Mo(Dys)';'Ch(Oth)-Mo(Agr)';'Ch(Oth)-Mo(Oth)'];
set(gca,'XTick',1:16,'XTickLabel',Label);
xtickangle(45)
title('Pauses of Speakers vs. Joint constructs')

subplot(2,1,2)
bar([P1(:),P2(:),P3(:),P4(:)]./[N1(:),N2(:),N3(:),N4(:)])
legend('Mother-to-Mother','Mother-to-Child','Child-to-Mother','Child-to-Child')
Label=['Ch(Pos)-Mo(Pos)';'Ch(Pos)-Mo(Dys)';'Ch(Pos)-Mo(Agr)';'Ch(Pos)-Mo(Oth)';'Ch(Dys)-Mo(Pos)';'Ch(Dys)-Mo(Dys)';'Ch(Dys)-Mo(Agr)';'Ch(Dys)-Mo(Oth)';...
    'Ch(Agr)-Mo(Pos)';'Ch(Agr)-Mo(Dys)';'Ch(Agr)-Mo(Agr)';'Ch(Agr)-Mo(Oth)';'Ch(Oth)-Mo(Pos)';'Ch(Oth)-Mo(Dys)';'Ch(Oth)-Mo(Agr)';'Ch(Oth)-Mo(Oth)'];
set(gca,'XTick',1:16,'XTickLabel',Label);
xtickangle(45)
title('Normalzied Pauses of Speakers vs. Joint constructs')














