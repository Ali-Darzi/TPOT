%   TPOT analysis folder contains various codes as follows:
%
%   1: AU_Format_Conversion: Reads AUs from the files and save them in AU_166.mat
%
%   2: Construct_Format_Conversion: Reads the Construct files and save individual/Both/joint constructs in Construct.mat
%
%   3: Joint_Construct_Info: Answer basic questions regarding Constructs
%
%   4: Turn_Format_Conversion: Reads the Turn information and svae it in Turn_152. mat file
%
%   5: Joint_Turn_Info: Answers basic infomation regarding Turn data
%
%   6: General_Information_Preparation: Prepares basic infomation about
%           the pairs such as mothers' depression history, child's sex 
%
%   7: mmmmmmmmmmmm
%   
%   
%   

load IN_OUT

%% Classification of Child's Constructs

X=Input;
Y=Difficulty(:);
[b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
Sel_F=find(inmodel==1);
if isempty(Sel_F)==0
    Xin=X(:,Sel_F);
else
    Xin=X;
end
[SVM_Difficulty(t,q),Std_SVM_Diff(t,q),LDA_Difficulty(t,q),Std_LDA_Diff(t,q),EDT_Difficulty(t,q),Std_EDT_Diff(t,q),REG_Difficulty(t,q),Std_REG_Diff(t,q),WP_Difficulty]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);
