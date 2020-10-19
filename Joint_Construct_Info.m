clear
clc
close all

load Construct2


%% Individual construct percentage (seperately for children and mothers) - To compare to the marginal probablity 

TEMP=zeros(4,4);

for i=1:160
    
    % Child
    Data_Child=Construct_Child{i};
    Total_Number_Child(i,1)=size(Data_Child,1);
    Total_Time_Child(i,1)=Data_Child.Start_Sec(end)-Data_Child.Start_Sec(1);
    Map_Pos=strcmp(Data_Child.Construct,'Positive');
    Map_Dys=strcmp(Data_Child.Construct,'Dysphoric');
    Map_Agg=strcmp(Data_Child.Construct,'Aggressive');
    Map_Oth=strcmp(Data_Child.Construct,'Other');
    Index_Pos=find(Map_Pos(1:end-1));
    Index_Dys=find(Map_Dys(1:end-1));
    Index_Agg=find(Map_Agg(1:end-1));
    Index_Oth=find(Map_Oth(1:end-1));
    Time_Pos=Data_Child.Start_Sec(Index_Pos+1)-Data_Child.Start_Sec(Index_Pos);
    Time_Dys=Data_Child.Start_Sec(Index_Dys+1)-Data_Child.Start_Sec(Index_Dys);
    Time_Agg=Data_Child.Start_Sec(Index_Agg+1)-Data_Child.Start_Sec(Index_Agg);
    Time_Oth=Data_Child.Start_Sec(Index_Oth+1)-Data_Child.Start_Sec(Index_Oth);
    
    TEMP(1,:)=TEMP(1,:)+[sum(Map_Pos),sum(Map_Dys),sum(Map_Agg),sum(Map_Oth)];
    TEMP(2,:)=TEMP(2,:)+[sum(Time_Pos),sum(Time_Dys),sum(Time_Agg),sum(Time_Oth)];
    
    clear Map_Pos Map_Dys Map_Agg Map_Oth Index_Pos Index_Dys Index_Agg Index_Oth Time_Pos Time_Dys Time_Agg Time_Oth

    % Mother
    Data_Mother=Construct_Mother{i};
    Total_Number_Mother(i,1)=size(Data_Mother,1);
    Total_Time_Mother(i,1)=Data_Mother.Start_Sec(end)-Data_Mother.Start_Sec(1);
    Map_Pos=strcmp(Data_Mother.Construct,'Positive');
    Map_Dys=strcmp(Data_Mother.Construct,'Dysphoric');
    Map_Agg=strcmp(Data_Mother.Construct,'Aggressive');
    Map_Oth=strcmp(Data_Mother.Construct,'Other');
    Index_Pos=find(Map_Pos(1:end-1)); 
    Index_Dys=find(Map_Dys(1:end-1));
    Index_Agg=find(Map_Agg(1:end-1));
    Index_Oth=find(Map_Oth(1:end-1));
    Time_Pos=Data_Mother.Start_Sec(Index_Pos+1)-Data_Mother.Start_Sec(Index_Pos);
    Time_Dys=Data_Mother.Start_Sec(Index_Dys+1)-Data_Mother.Start_Sec(Index_Dys);
    Time_Agg=Data_Mother.Start_Sec(Index_Agg+1)-Data_Mother.Start_Sec(Index_Agg);
    Time_Oth=Data_Mother.Start_Sec(Index_Oth+1)-Data_Mother.Start_Sec(Index_Oth);
    
    TEMP(3,:)=TEMP(3,:)+[sum(Map_Pos),sum(Map_Dys),sum(Map_Agg),sum(Map_Oth)];
    TEMP(4,:)=TEMP(4,:)+[sum(Time_Pos),sum(Time_Dys),sum(Time_Agg),sum(Time_Oth)];
    
    clear Map_Pos Map_Dys Map_Agg Map_Oth Index_Pos Index_Dys Index_Agg Index_Oth Time_Pos Time_Dys Time_Agg Time_Oth

end

figure
subplot(2,2,1)
bar(Total_Number_Child); title('Children Total Number of Constructs'); xlabel('Pair Number'); ylabel('Number of Constructs');
subplot(2,2,3)
bar(Total_Time_Child); title('Children Total Time of Constructs'); xlabel('Pair Number'); ylabel('Time of Constructs');
subplot(2,2,2)
bar(Total_Number_Mother); title('Mothers Total Number of Constructs'); xlabel('Pair Number'); ylabel('Number of Constructs');
subplot(2,2,4)
bar(Total_Time_Mother); title('Mothers Total Time of Constructs'); xlabel('Pair Number'); ylabel('Time of Constructs');


TEMP=[TEMP(1,:);TEMP(1,:)./sum(Total_Number_Child);TEMP(2,:);TEMP(2,:)./sum(Total_Time_Child);...
    TEMP(3,:);TEMP(3,:)./sum(Total_Number_Mother);TEMP(4,:);TEMP(4,:)./sum(Total_Time_Mother)];
TEMP=[TEMP,[sum(Total_Number_Child);100;sum(Total_Time_Child);100;sum(Total_Number_Mother);100;sum(Total_Time_Mother);100]];
First_Col_Label=[{'Child Construct Number  '};{'Percent Child Con Number'};{'Child Construct Time    '};{'Percent Child Con Time  '};...
{'Mother Construct Number '}; {'Percent Mother Con Time '};{'Mother Construct Time   '};{'Percent Mother Con Time '}];
Individual_Table=table(First_Col_Label,TEMP(:,1),TEMP(:,2),TEMP(:,3),TEMP(:,4),TEMP(:,5));
Individual_Table.Properties.VariableNames={'Class','Positive','Dysphoric','Aggressive','Other','TOTAL'};
Individual_Table


%% Finding the constructs with different length for Mother and Child

Cons_Length=zeros(2,2);  % Row: Mother (400-520S), Col: Child (400 - 520S)
for i=1:160
    Data_Child=Construct_Child{i};
    Data_Mother=Construct_Mother{i};
    if (Data_Child{end,4}-Data_Child{1,4})>450
        if (Data_Mother{end,4}-Data_Mother{1,4})>450
           Cons_Length(2,2)= Cons_Length(2,2)+1;
        else
           Cons_Length(1,2)= Cons_Length(1,2)+1;
        end
    else
        if (Data_Mother{end,4}-Data_Mother{1,4})>450
           Cons_Length(2,1)= Cons_Length(2,1)+1;
        else
           Cons_Length(1,1)= Cons_Length(1,1)+1;
        end
    end
    
    clear Data_Child Data_Mother
    
end
Cons_Length

% *******************************%
%%  Calculating Joint Construct  %
%********************************%

Mother=['Mother_Pos';'Mother_Dys';'Mother_Agr';'Mother_Oth'];
Con_Mat_Number=table(Mother,zeros(4,1),zeros(4,1),zeros(4,1),zeros(4,1));
Con_Mat_Number.Properties.VariableNames={'Mother','Child_Pos','Child_Dys','Child_Agr','Child_Oth'};

Con_Mat_Time=table(Mother,zeros(4,1),zeros(4,1),zeros(4,1),zeros(4,1));
Con_Mat_Time.Properties.VariableNames={'Mother','Child_Pos','Child_Dys','Child_Agr','Child_Oth'};

Total_Time=0;
Total_Number=0;

for i=1:length(Construct_Joint)
    Data=Construct_Joint{i};
    Total_Number(i,1)=size(Data,1);
    Total_Time(i,1)=Data.Start_Sec(end)-Data.Start_Sec(1);
    for j=2:size(Data,1)-1
        if strcmp(Data.Mother_Construct{j}(1:3),'Pos')
            Ind_M=1;
        elseif strcmp(Data.Mother_Construct{j}(1:3),'Dys')
            Ind_M=2;
        elseif strcmp(Data.Mother_Construct{j}(1:3),'Agg')
            Ind_M=3;
        else
            Ind_M=4;
        end
        if ~isempty(Data.Child_Construct{j})
            if strcmp(Data.Child_Construct{j}(1:3),'Pos')
                Con_Mat_Number.Child_Pos(Ind_M)=Con_Mat_Number.Child_Pos(Ind_M)+1;
                Con_Mat_Time.Child_Pos(Ind_M)=Con_Mat_Time.Child_Pos(Ind_M)+Data.Start_Sec(j+1)-Data.Start_Sec(j);

            elseif strcmp(Data.Child_Construct{j}(1:3),'Dys')
                Con_Mat_Number.Child_Dys(Ind_M)=Con_Mat_Number.Child_Dys(Ind_M)+1;
                Con_Mat_Time.Child_Dys(Ind_M)=Con_Mat_Time.Child_Dys(Ind_M)+Data.Start_Sec(j+1)-Data.Start_Sec(j);

            elseif strcmp(Data.Child_Construct{j}(1:3),'Agg')
                Con_Mat_Number.Child_Agr(Ind_M)=Con_Mat_Number.Child_Agr(Ind_M)+1;
                Con_Mat_Time.Child_Agr(Ind_M)=Con_Mat_Time.Child_Agr(Ind_M)+Data.Start_Sec(j+1)-Data.Start_Sec(j);

            else
                Con_Mat_Number.Child_Oth(Ind_M)=Con_Mat_Number.Child_Oth(Ind_M)+1;
                Con_Mat_Time.Child_Oth(Ind_M)=Con_Mat_Time.Child_Oth(Ind_M)+Data.Start_Sec(j+1)-Data.Start_Sec(j);
            end
        end
    end
end

% Plotting 

figure
subplot(2,1,1)
bar(Total_Number)
title('Number of Constructs of each Pair')
xlabel('Pairs')
ylabel('Number of Joint Constructs')

subplot(2,1,2)
bar(Total_Time)
title('Total duration of Joint Constructs of each Pair')
xlabel('Pairs')
ylabel('Duration of Joint Constructs')

%% Demonstration of the results in the Command window

Con_Mat_Number
Norm_Con_Mat_Number=Con_Mat_Number;
% Norm_Con_Mat_Number{:,2:5}=100*Norm_Con_Mat_Number{:,2:5}/sum(Total_Number);
Norm_Con_Mat_Number{:,2:5}=100*Norm_Con_Mat_Number{:,2:5}/sum(Norm_Con_Mat_Number{:,2:5}(:));
Norm_Con_Mat_Number
Child_Percent_Num=sum(Norm_Con_Mat_Number{:,2:5},1)
Mother_Percent_Num=sum(Norm_Con_Mat_Number{:,2:5},2)

Con_Mat_Time
Norm_Con_Mat_Time=Con_Mat_Time;
Norm_Con_Mat_Time{:,2:5}=100*Norm_Con_Mat_Time{:,2:5}/sum(Total_Time);
Norm_Con_Mat_Time
Child_Percentage=sum(Norm_Con_Mat_Time{:,2:5},1)
Mother_Percentage=sum(Norm_Con_Mat_Time{:,2:5},2)


































