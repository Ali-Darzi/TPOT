clear
clc

load Construct2.mat
load('Turn_152.mat','Turn_Pair_ID','Turn_Both','Turn_Joint')
load('AU_165.mat','AU_Joint','AU_Pair_ID')
load('TPOT_Info.mat','TPOT_General_Info')

load Raw_All_IDs

% Chnaging the format of pairs to CMU format - loosing the fist two digits
My_Pair_All=[];
My_Pair_AU=[];
My_Pair_Con=[];
My_Pair_Turn=[];
for i=1:size(TPOT_General_Info,1)
    A=num2str(TPOT_General_Info{i,1});
    My_Pair_All(i,:)=str2num(A(3:6));
end
for i=1:length(AU_Pair_ID)
    B=num2str(AU_Pair_ID(i));
    My_Pair_AU(i,:)=str2num(B(3:6));
end
for i=1:length(Construct_Pair_ID)
    C=num2str(Construct_Pair_ID(i));
    My_Pair_Con(i,:)=str2num(C(3:6));
end
for i=1:length(Turn_Pair_ID)
    D=num2str(Turn_Pair_ID(i));
    My_Pair_Turn(i,:)=str2num(D(3:6));
end

%%  Comapring the raw facial video names to the list that we have

% FaceCam_ID=[];
% Missed_FaceCam_ID=[];
% Extra_Oregan_Face=[];
% for i=1:length(Raw_Video_Names)
%     TEMP=str2num(Raw_Video_Names(i).name(1:4));
%     FaceCam_ID=[FaceCam_ID;TEMP];
%     if sum(My_Pair_All==TEMP)==0
%         Missed_FaceCam_ID=[Missed_FaceCam_ID;TEMP];
%     end
%     Temp=[];
% end   
% FaceCam_ID=unique(FaceCam_ID);
% Num_FaceCam_Id=length(FaceCam_ID)
% Missed_FaceCam_ID=unique(Missed_FaceCam_ID)
% 
% for i=1:169
%     if sum(FaceCam_ID==My_Pair_All(i))==0
%         Extra_Oregan_Face=[Extra_Oregan_Face;My_Pair_All(i)];
%     end
% end
% Extra_Oregan_Face

%%  Comapring the raw Body video names to the list that we have
% 
% Construct_ID=[];
% Missed_ID_Construct=[];
% Extra_Oregan_BodyCam=[];
% for i=1:length(Raw_BodyCam_Names)
%     TEMP=Raw_BodyCam_Names(i).name;
%     Ind=strfind(TEMP,'EPI');
%     if isempty(Ind)
%         Ind=strfind(TEMP,'PSI');
%     end
%     if ~isempty(Ind)
%         ID=str2num(Raw_BodyCam_Names(i).name(Ind-5:Ind-2));
%         Construct_ID=[Construct_ID;ID];
%         if sum(My_Pair_All==ID)==0
%             Missed_ID_Construct=[Missed_ID_Construct;ID];
%         end
%     end
%    	clear TEMP Ind ID
% end   
% Construct_ID=unique(Construct_ID);
% Missed_ID_Construct=unique(Missed_ID_Construct)
% 
% for i=1:169
%     if sum(Construct_ID==My_Pair_All(i))==0
%         Extra_Oregan_BodyCam=[Extra_Oregan_BodyCam;My_Pair_All(i)];
%     end
% end
% Extra_Oregan_BodyCam


%% Comparing LIFE construct Pairs to the Oregan pairs

Construct_ID=[];
Missed_ID_Construct=[];
Extra_Oregan_Construct=[];
for i=1:length(Raw_Construct_IDs)
    TEMP=str2num(Raw_Construct_IDs(i).name(3:6));
    Construct_ID=[Construct_ID;TEMP];
    if sum(My_Pair_All==TEMP)==0
        Missed_ID_Construct=[Missed_ID_Construct;TEMP];
    end
   	clear TEMP 
end   
Construct_ID=unique(Construct_ID);
Missed_ID_Construct=unique(Missed_ID_Construct)

for i=1:169
    if sum(Construct_ID==My_Pair_All(i))==0
        Extra_Oregan_Construct=[Extra_Oregan_Construct;My_Pair_All(i)];
    end
end
Extra_Oregan_Construct


%% Comparing Segmentation Data Pairs to the Oregan pairs

Turn_ID=[];
Missed_ID_Turn=[];
Extra_Oregan_Turn=[];
for i=1:length(Raw_Segmentation_ID)
    TEMP=str2num(Raw_Segmentation_ID(i).name(1:4));
    Turn_ID=[Turn_ID;TEMP];
    if sum(My_Pair_All==TEMP)==0
        Missed_ID_Turn=[Missed_ID_Turn;TEMP];
    end
   	clear TEMP 
end   
Turn_ID=unique(Turn_ID);
Missed_ID_Turn=unique(Missed_ID_Turn)

for i=1:169
    if sum(Turn_ID==My_Pair_All(i))==0
        Extra_Oregan_Turn=[Extra_Oregan_Turn;My_Pair_All(i)];
    end
end
Extra_Oregan_Turn


%%  Comapring our Pairs to Torston

load Torston_Pairs
TEMP_Pairs=[];
for i=1:length(Torston_Pairs)
    TEMP_Pairs(i,:)=str2num(Torston_Pairs(i,6:9));
end

for i=1:length(Torston_Pairs)
    if sum(My_Pair_All==TEMP_Pairs(i,:))==0
        sprintf('Not found in general pairs: %d',TEMP_Pairs(i,:))
    end
    if sum(My_Pair_AU==TEMP_Pairs(i,:))==0
        sprintf('Not found in AU pairs: %d',TEMP_Pairs(i,:));
    end
    if sum(My_Pair_Con==TEMP_Pairs(i,:))==0
        sprintf('Not found in Construct pairs: %d',TEMP_Pairs(i,:));
    end
    if sum(My_Pair_Turn==TEMP_Pairs(i,:))==0
        sprintf('Not found in Turn pairs: %d',TEMP_Pairs(i,:));
    end
end

%%  