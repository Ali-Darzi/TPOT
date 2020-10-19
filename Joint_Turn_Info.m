clear
clc
close all

load Turn_152
Valid_Pairs=size(Turn_Both,2);
% set(0,'defaultAxesFontSize',12)

%% An Example of plotting for turn info

Desired_Pair=100017;                    % Insert your desired pair to plot

Index=find(Turn_Pair_ID==Desired_Pair);
Data=Turn_Joint{Index};
figure
bar(Data{:,1},Data.Child_Turn,'b'); 
hold on
bar(Data{:,1},Data.Mother_Turn,'g');
Simultanously=1*(Data{:,3}==1).*(Data{:,4}==1);
bar(Data{:,1},Simultanously,'r'); 
legend('Child','Mother','Both')
title(sprintf('The Turn plot of Pair %d',Desired_Pair))
xlabel('Seconds of the video')
ylabel('1 Means talking')
axis([min(Data{:,1})-10 max(Data{:,1})+10 -0.2 1.2])

%% The whole length of Transcription / Turn
Valid_Pairs=size(Turn_Both,2);

Length_Transcription=[];

for i=1:Valid_Pairs
   Data=Turn_Both{i};
   Length_Transcription(i,:)=[min(Data.Start_Sec),max(Data.Stop_Sec)];
end

figure
subplot(2,2,[1,3])
barh(Length_Transcription(:,2))
hold on
barh(Length_Transcription(:,1),'w')
xlabel('Seconds of Video')
ylabel('Pairs')
title('Coded part of each video (each pair)')
subplot(1,2,2)
bar(Length_Transcription(:,2)-Length_Transcription(:,1))
xlabel('Pair')
ylabel('Second')
title('Transcription duration for each pair')

%% Numebr and Time of Turn for Mothers and Children

Num_Turn_Mother=0;
Num_Turn_Child=0;
Time_Turn_Mother=0;
Time_Turn_Child=0;

for i=1:Valid_Pairs
   Data_Mother=Turn_Mother{i};
   Data_Child=Turn_Child{i};
   
   Num_Turn_Mother(i)=size(Data_Mother,1);
   Num_Turn_Child(i)=size(Data_Child,1);
   
   Time_Turn_Mother(i)=sum(Data_Mother.Duration_Sec);
   Time_Turn_Child(i)=sum(Data_Child.Duration_Sec);
end

figure
subplot(2,2,1);  bar(Num_Turn_Child); 
xlabel('Pair');  ylabel('Number of Turns');
title('Number of Turns of Children');
ylim([0 250])
subplot(2,2,2);  bar(Num_Turn_Mother); 
xlabel('Pair');  ylabel('Number of Turns');
title('Number of Turns of Mothers');
ylim([0 250])
subplot(2,2,3);  bar(Time_Turn_Child); 
xlabel('Pair');  ylabel('Time (second)');
title('Time of Turns of Children');
subplot(2,2,4);  bar(Time_Turn_Mother); 
xlabel('Pair');  ylabel('Time (second)');
title('Time of Turns of Mothers');

%% Box and Wisker plot: Number and duration of Turn vs. Depression and Child Gender

load TPOT_Info

Info_Table=[];

for i=1:length(Turn_Pair_ID)
    Index=find(TPOT_General_Info{:,1}==Turn_Pair_ID(i));
    Info_Table=[Info_Table;TPOT_General_Info(Index,:)];
    A=Info_Table.Dep_Hist(end,:);
    B=Info_Table.Child_Gender(end);
    Map_Dep_Gender(i,:)=sprintf('%s_%c',A{1},B{1});
    clear A B
end

% Map_Dep=strcmp(Info_Table.Dep_Hist,'DEP');
% Map_Male=strcmp(Info_Table.Child_Gender,'M');

figure

% subplot(3,4,1)
% boxplot(Num_Turn_Child,Info_Table.Dep_Hist)
% title('Child number of Turns vs. Dep Hist')
% subplot(3,4,2)
% boxplot(Num_Turn_Mother,Info_Table.Dep_Hist)
% title('Mothers number of Turns vs. Dep Hist')
% subplot(3,4,3)
% boxplot(Num_Turn_Child,Info_Table.Child_Gender)
% title('Child number of Turns vs. Child Gender')
% subplot(3,4,4)
% boxplot(Num_Turn_Mother,Info_Table.Child_Gender)
% title('Mothers number of Turns vs. Child Gender')

subplot(2,4,1)
boxplot(Time_Turn_Child,Info_Table.Dep_Hist)
title('Child duration of talking vs. Dep Hist')
ylabel('Duration in seconds')
subplot(2,4,2)
boxplot(Time_Turn_Mother,Info_Table.Dep_Hist)
title('Mother duration of talking vs. Dep Hist')
ylabel('Duration in seconds')
subplot(2,4,3)
boxplot(Time_Turn_Child,Info_Table.Child_Gender)
title('Child duration of talking vs. Child Gender')
ylabel('Duration in seconds')
subplot(2,4,4)
boxplot(Time_Turn_Mother,Info_Table.Child_Gender)
title('Mother duration of talking vs. Child Gender')
ylabel('Duration in seconds')

subplot(2,4,5:6)
boxplot(Time_Turn_Child,Map_Dep_Gender)
title('Child duration of talking vs. Dep Hist and Child Gender')
ylabel('Duration in seconds')
subplot(2,4,7:8)
boxplot(Time_Turn_Mother,Map_Dep_Gender)
title('Mother duration of talking vs. Dep Hist and Child Gender')
ylabel('Duration in seconds')

%% Number and Intra- and inter subject pauses 

for i=1:Valid_Pairs
    Data_Both=Turn_Both{i};
    Map=strcmp(Data_Both.Speaker,'Parent');
    Map_MM=(Map(1:end-1)==1).*(Map(2:end)==1);
    Map_CC=(Map(1:end-1)==0).*(Map(2:end)==0);
    Map_MC=(Map(1:end-1)==1).*(Map(2:end)==0);
    Map_CM=(Map(1:end-1)==0).*(Map(2:end)==1);

    Num_Mother_2_Mother(i,1)=sum(Map_MM);
    Pause_Mother_2_Mother(i,1)=mean(Data_Both{[0;Map_MM]==1,3}-Data_Both{[Map_MM;0]==1,5});
    
    Num_Child_2_Child(i,1)=sum(Map_CC);
    Pause_Child_2_Child(i,1)=mean(Data_Both{[0;Map_CC]==1,3}-Data_Both{[Map_CC;0]==1,5});
    
    Num_Mother_2_Child(i,1)=sum(Map_MC);
    Pause_Mother_2_Child(i,1)=mean(Data_Both{[0;Map_MC]==1,3}-Data_Both{[Map_MC;0]==1,5});
    
    Num_Child_2_Mother(i,1)=sum(Map_CM);
    Pause_Child_2_Mother(i,1)=mean(Data_Both{[0;Map_CM]==1,3}-Data_Both{[Map_CM;0]==1,5});
    
end

Labels=[repmat('M_2_M',[Valid_Pairs,1]);repmat('C_2_C',[Valid_Pairs,1]);repmat('M_2_C',[Valid_Pairs,1]);repmat('C_2_M',[Valid_Pairs,1])];

figure
subplot(2,1,1)
boxplot([Num_Mother_2_Mother;Num_Child_2_Child;Num_Mother_2_Child;Num_Child_2_Mother],Labels)
title('Number of Turns- M: Mother, and C: Child')
ylabel('Number of turns')

subplot(2,1,2)
boxplot([Pause_Mother_2_Mother;Pause_Child_2_Child;Pause_Mother_2_Child;Pause_Child_2_Mother],Labels)  
axis([0.5 4.5 -1.5 3])   
title('Duration of Turns- M: Mother, and C: Child')
ylabel('Duration in seconds')

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
