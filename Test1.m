clear
clc
close all

% s = hdfinfo('TPOT_0017_1_1.hdf')
% A=hdfread('')pfsx
% readtable('00170_02_ELAN_HL.eaf')

Current_Dir=pwd;
Index=strfind(Current_Dir,'TPOT_Dataset');
Dir1=sprintf('%s/Data/',Current_Dir(1:Index+12));
Test_Info=xlsread(sprintf('%s%s',Dir1,'DatasetInfo.xlsx'));
Org_Dataset = readtable(sprintf('%s%s',Dir1,'Multimodal_TPOT.csv'));
Org_Dataset(170:end,:)=[];
Test_Info(170:end,:)=[];

Temp={''};
Counter=1;
Names=table(repmat(Temp,[4*169,1]));
Names.Properties.VariableNames={'OUR_ID'};

for i=1:169
    Counter
    TT=num2str(Org_Dataset{i,1});
    Names.OUR_ID(Counter)={sprintf('%s1_01',TT(3:end))};
    Counter=Counter+1;
    Names.OUR_ID(Counter)={sprintf('%s1_02',TT(3:end))};
    Counter=Counter+1;
    Names.OUR_ID(Counter)={sprintf('%s2_01',TT(3:end))};
    Counter=Counter+1;
    Names.OUR_ID(Counter)={sprintf('%s2_02',TT(3:end))};
    Counter=Counter+1;
end
Counter

xlswrite('Test.xls',Names)
