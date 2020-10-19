function [Acc_SVM,Std_SVM,Acc_LDA,Std_LDA,Acc_EDT,Std_EDT,Acc_Reg,Std_Reg,Worst_Participants]=Multi_Class_One_Leave_Out(X_raw,Y,Participant)
%% Principal Component Analysis
% [COEFF, SCORE, LATENT, TSQUARED, EXPLAINED] = pca(X_raw);
% Accum=cumsum(EXPLAINED);
% Sel_Idx=size(X_raw,2)-sum(Accum>95)+1;
% X=SCORE(:,1:Sel_Idx);
X=X_raw;

%% Main Part of Classification

tSVM = templateSVM('Standardize',1);
tLDA = templateDiscriminant('DiscrimType','pseudolinear');
tTree = templateTree('surrogate','on');
tEnsemble = templateEnsemble('GentleBoost',100,tTree);

Mdl = fitcecoc(X,Y,'Coding','onevsone','Learners',tSVM);
Md2 = fitcensemble(X,Y,'Method','Subspace','Learners',tLDA);
% Md2 = fitcecoc(X,Y,'Coding','onevsone','Learners',tTree);
Md3 = fitcecoc(X,Y,'Coding','onevsone','Learners',tEnsemble);

CVMd1 = crossval(Mdl);
CVMd2 = crossval(Md2);
CVMd3 = crossval(Md3);

Label_1 = kfoldPredict(CVMd1);
Label_2 = kfoldPredict(CVMd2);
Label_3 = kfoldPredict(CVMd3);

ConfMat_SVM = confusionmat(Y,Label_1);
ConfMat_LDA = confusionmat(Y,Label_2);
% ConfMat_DT = confusionmat(Y,Label_2);
ConfMat_DT_Ensemble = confusionmat(Y,Label_3);

Acc_SVM=sum(diag(ConfMat_SVM))/length(Y);
Acc_LDA=sum(diag(ConfMat_LDA))/length(Y);
% Acc_DT=sum(diag(ConfMat_DT))/length(Y);
Acc_EDT=sum(diag(ConfMat_DT_Ensemble))/length(Y);

%% Regression model classification (10-fold) and standard deviation of All methods
Step=round(length(Y)/10);
Label_Reg=[];

STD_S=zeros(10,1); STD_L=zeros(10,1);
STD_E=zeros(10,1); STD_R=zeros(10,1);

for i=1:10
    Map=((i-1)*Step)+1:i*Step;
    if i==10
        Map=((i-1)*Step)+1:length(X);
    end
    te_X=[ones(length(Map),1),X(Map,:)];
%     te_X=X(Map,:);
    te_Y=Y(Map);
    tr_X=[ones(size(X,1),1),X]; 
%     tr_X=X; 
    tr_Y=Y;
    tr_X(Map,:)=[];
    tr_Y(Map)=[];
    Coeff=regress(tr_Y,tr_X);
    Label_Reg=[Label_Reg;round(te_X*Coeff)];
    
    %% Calculation of Standard Error    
    STD_S(i)=sum((te_Y-Label_1(Map))==0)/length(te_Y);
    STD_L(i)=sum((te_Y-Label_2(Map))==0)/length(te_Y);
    STD_E(i)=sum((te_Y-Label_3(Map))==0)/length(te_Y);
    STD_R(i)=sum((te_Y-round(te_X*Coeff))==0)/length(te_Y);
end
ConfMat_Reg = confusionmat(Y,Label_Reg);
Acc_Reg=sum(diag(ConfMat_Reg))/length(Y);

Std_SVM=std(STD_S);
Std_LDA=std(STD_L);
Std_EDT=std(STD_E);
Std_Reg=std(STD_R);

%% Fidning the Worst classified subjects    
T_Var1=Y-Label_1;
T_Var2=Y-Label_2;
T_Var3=Y-Label_3;
T_Var4=Y-Label_Reg;
Wrong=[Participant(T_Var1~=0);Participant(T_Var2~=0);Participant(T_Var3~=0);Participant(T_Var4~=0)];
[Num_Wr,Index]=hist(Wrong,unique(Wrong));
[~,Map]=sort(Num_Wr,'descend');
Worst_Participants=Index(Map);


