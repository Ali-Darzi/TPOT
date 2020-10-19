% function [Input,Output]=Feature_Maker(Win_Length)

clear
clc
close all

Win_Length=1;

load TPOT_Dataset
Valid_Pairs=size(TPOT_Dataset,2);

Frame_Length=Win_Length*30;
Counter=1;

for i=1:Valid_Pairs
    i
    Data= TPOT_Dataset{i};
    Num_Window=floor(size(Data,1)/Frame_Length);
    for j=1:Num_Window
        Start=1+(j-1)*Frame_Length;
        Stop=j*Frame_Length;
        TEMP=Data(Start:Stop,:);
        
        % *** General Information ***     
        G_Info(Counter,:)=All_Pair_ID(i,1:2);
        
        % *** Features based on AU ***
        % 1 - 4: Mean of AU intensities
        % 5 - 8: Std of AU Intensities
        % 9 - 12: Portion of time of intensities >= 2
        AU_Features(Counter,:)=[mean(TEMP{:,3:10}),std(TEMP{:,3:10}),mean(TEMP{:,3:10}>=2)];
        
        % *** Features based on Turn ***
        % 1 & 2: Percent of child and mother talking
        % 3 & 4: Number of changes in child and mother talking
        % 5: Number of changes in overall M2C, M2M, C2C, M
        Turn_Features(Counter,:)=[mean((TEMP{:,13:14})),sum(diff(TEMP{:,13:14})~=0),sum(diff(TEMP{:,13}+2*TEMP{:,14})~=0)];
        
        % *** Making Output ***
        Output(Counter,:)=TEMP(end,11:12);
        
        Counter=Counter+1;
        clear TEMP Start Stop
    end
end

Table_AU=array2table(AU_Features);
Table_AU.Properties.VariableNames={'Mean_AU6_Child','Mean_AU10_Child','Mean_AU12_CHild','Mean_AU14_Child','Mean_AU6_Mother','Mean_AU10_Mother','Mean_AU12_Mother','Mean_AU14_Mother',...
    'Std_AU6_Child','Std_AU10_Child','Std_AU12_Child','Std_AU14_Child','Std_AU6_Mother','Std_AU10_Mother','Std_AU12_Mother','Std_AU14_Mother',...
    'P_AU6_Child','P_AU10_Child','P_AU12_Child','P_AU14_Child','P_AU6_Mother','P_AU10_Mother','P_AU12_Mother','P_AU14_Mother'};
Table_Turn=array2table(Turn_Features);
Table_Turn.Properties.VariableNames={'P_Child','P_Mother','N_Change_Child','N_Change_Mother','N_Change_All'};

Input=[G_Info,Table_AU,Table_Turn];
save IN_OUT Input Output
% end