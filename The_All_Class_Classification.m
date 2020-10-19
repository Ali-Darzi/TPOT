clear
clc
close all
%% loading the data
% load('Feature_Baseline_Subtracted.mat')
load('ShQ_All_Exp.mat')
Difficulty=ShQ_All_Exp(1:6:480,:);
Enjoy=ShQ_All_Exp(2:6:480,:);
Pos_Neg=ShQ_All_Exp(3:6:480,:);
Intensity=ShQ_All_Exp(4:6:480,:); 
Speed_Change=ShQ_All_Exp(5:6:480,:);
Paddle_Change=ShQ_All_Exp(6:6:480,:);
Participant_All=repmat((1:80)',[9,1]);

t=1;
for q=1:7
    % Categories:
    % 1- Physiological features Only
    % 2- Personality features Only
    % 3- Perfromance features Only
    % 4- Physiological and Personality
    % 5- Physiological and Perfromance
    % 6- Personality and Perfromance
    % 7- All features 

    %% Classification : Preparation of the input
    All_9_Features=[];
    for i=1:9
        All_Features{i}=All_Feature_Maker(i,q,0);           % The third number indicates the Normalization
        All_9_Features=[All_9_Features;All_Features{i}];
    end

    %% Classification of the Difficulty level

    X=All_9_Features;
    Y=Difficulty(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Difficulty(t,q),Std_SVM_Diff(t,q),LDA_Difficulty(t,q),Std_LDA_Diff(t,q),EDT_Difficulty(t,q),Std_EDT_Diff(t,q),REG_Difficulty(t,q),Std_REG_Diff(t,q),WP_Difficulty]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);


    %% Classification for the Enjoy 

    X=All_9_Features;
    Y=Enjoy(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Enjoy(t,q),Std_SVM_Enjoy(t,q),LDA_Enjoy(t,q),Std_LDA_Enjoy(t,q),EDT_Enjoy(t,q),Std_EDT_Enjoy(t,q),REG_Enjoy(t,q),Std_REG_Enjoy(t,q),WP_Enjoy]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Pos_Neg 

    X=All_9_Features;
    Y=Pos_Neg(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Pos_Neg(t,q),Std_SVM_PN(t,q),LDA_Pos_Neg(t,q),Std_LDA_PN(t,q),EDT_Pos_Neg(t,q),Std_EDT_PN(t,q),REG_Pos_Neg(t,q),Std_REG_PN(t,q),WP_PosNeg]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Intensity 

    X=All_9_Features;
    Y=Intensity(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Intensity(t,q),Std_SVM_Int(t,q),LDA_Intensity(t,q),Std_LDA_Int(t,q),EDT_Intensity(t,q),Std_EDT_Int(t,q),REG_Intensity(t,q),Std_REG_Int(t,q),WP_Intensity]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);


    %% Classification for the Speed_Change 

    X=All_9_Features;
    Y=Speed_Change(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Speed(t,q),Std_SVM_Speed(t,q),LDA_Speed(t,q),Std_LDA_Speed(t,q),EDT_Speed(t,q),Std_EDT_Speed(t,q),REG_Speed(t,q),Std_REG_Speed(t,q),WP_Speed]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Paddle_Change 

    X=All_9_Features;
    Y=Paddle_Change(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Paddle(t,q),Std_SVM_Paddle(t,q),LDA_Paddle(t,q),Std_LDA_Paddle(t,q),EDT_Paddle(t,q),Std_EDT_Paddle(t,q),REG_Paddle(t,q),Std_REG_Paddle(t,q),WP_Paddle]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Order 

    % X=All_9_Features;
    % Y=(Order(:)<4)+2*((Order(:)<7).*(Order(:)>3))+3*(Order(:)>6);
    % [b,se,pval,inmodel,stats]=stepwisefit(X,Y);  % the results shows
    % Sel_F=find(inmodel==1);
    % Xin=X(:,Sel_F);
    % [SVM_Order,LDA_Order,EDT_Order]=K_Fold_Cross_Validation(Xin,Y);

end


%% Classification using normalized physiological signals
  
for s=1:4
    if s==1
        q=1;
    elseif s==2
        q=4;
    elseif s==3
        q=5;
    else
        q=7;
    end
    % Categories:
    % 1- Physiological features Only
    % 2- Personality features Only
    % 3- Perfromance features Only
    % 4- Physiological and Personality
    % 5- Physiological and Perfromance
    % 6- Personality and Perfromance
    % 7- All features 

    %% Classification : Preparation of the input
    All_9_Features=[];
    for i=1:9
        All_Features{i}=All_Feature_Maker(i,q,1);           % The third number indicates the Normalization
        All_9_Features=[All_9_Features;All_Features{i}];
    end

    %% Classification of the Difficulty level

    X=All_9_Features;
    Y=Difficulty(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Difficulty_N(t,q),Std_SVM_Diff_N(t,q),LDA_Difficulty_N(t,q),Std_LDA_Diff_N(t,q),EDT_Difficulty_N(t,q),Std_EDT_Diff_N(t,q),REG_Difficulty_N(t,q),Std_REG_Diff_N(t,q),WP_Difficulty]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);


    %% Classification for the Enjoy 

    X=All_9_Features;
    Y=Enjoy(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Enjoy_N(t,q),Std_SVM_Enjoy_N(t,q),LDA_Enjoy_N(t,q),Std_LDA_Enjoy_N(t,q),EDT_Enjoy_N(t,q),Std_EDT_Enjoy_N(t,q),REG_Enjoy_N(t,q),Std_REG_Enjoy_N(t,q),WP_Enjoy]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Pos_Neg 

    X=All_9_Features;
    Y=Pos_Neg(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Pos_Neg_N(t,q),Std_SVM_PN_N(t,q),LDA_Pos_Neg_N(t,q),Std_LDA_PN_N(t,q),EDT_Pos_Neg_N(t,q),Std_EDT_PN_N(t,q),REG_Pos_Neg_N(t,q),Std_REG_PN_N(t,q),WP_PosNeg]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Intensity 

    X=All_9_Features;
    Y=Intensity(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Intensity_N(t,q),Std_SVM_Int_N(t,q),LDA_Intensity_N(t,q),Std_LDA_Int_N(t,q),EDT_Intensity_N(t,q),Std_EDT_Int_N(t,q),REG_Intensity_N(t,q),Std_REG_Int_N(t,q),WP_Intensity]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);


    %% Classification for the Speed_Change 

    X=All_9_Features;
    Y=Speed_Change(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Speed_N(t,q),Std_SVM_Speed_N(t,q),LDA_Speed_N(t,q),Std_LDA_Speed_N(t,q),EDT_Speed_N(t,q),Std_EDT_Speed_N(t,q),REG_Speed_N(t,q),Std_REG_Speed_N(t,q),WP_Speed]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Paddle_Change 

    X=All_9_Features;
    Y=Paddle_Change(:);
    [b,se,pval,inmodel,stats]=stepwisefit(X,Y,'PENTER',0.1);   % the results shows
    Sel_F=find(inmodel==1);
    if isempty(Sel_F)==0
        Xin=X(:,Sel_F);
    else
        Xin=X;
    end
    [SVM_Paddle_N(t,q),Std_SVM_Paddle_N(t,q),LDA_Paddle_N(t,q),Std_LDA_Paddle_N(t,q),EDT_Paddle_N(t,q),Std_EDT_Paddle_N(t,q),REG_Paddle_N(t,q),Std_REG_Paddle_N(t,q),WP_Paddle]=Multi_Class_One_Leave_Out(Xin,Y,Participant_All);

    %% Classification for the Order 

    % X=All_9_Features;
    % Y=(Order(:)<4)+2*((Order(:)<7).*(Order(:)>3))+3*(Order(:)>6);
    % [b,se,pval,inmodel,stats]=stepwisefit(X,Y);  % the results shows
    % Sel_F=find(inmodel==1);
    % Xin=X(:,Sel_F);
    % [SVM_Order,LDA_Order,EDT_Order]=K_Fold_Cross_Validation(Xin,Y);

end

    
Difficulty_Accuracy=[mean(SVM_Difficulty,1);mean(LDA_Difficulty,1);mean(EDT_Difficulty,1);mean(REG_Difficulty,1)]
Enjoy_Accuracy=[mean(SVM_Enjoy,1);mean(LDA_Enjoy,1);mean(EDT_Enjoy,1);mean(REG_Enjoy,1)]
PosNeg_Accuracy=[mean(SVM_Pos_Neg,1);mean(LDA_Pos_Neg,1);mean(EDT_Pos_Neg,1);mean(REG_Pos_Neg,1)]
Intensity_Accuracy=[mean(SVM_Intensity,1);mean(LDA_Intensity,1);mean(EDT_Intensity,1);mean(REG_Intensity,1)]
Speed_Accuracy=[mean(SVM_Speed,1);mean(LDA_Speed,1);mean(EDT_Speed,1);mean(REG_Speed,1)]
Paddle_Accuracy=[mean(SVM_Paddle,1);mean(LDA_Paddle,1);mean(EDT_Paddle,1);mean(REG_Paddle,1)]

Difficulty_Accuracy=[mean(SVM_Difficulty_N,1);mean(LDA_Difficulty_N,1);mean(EDT_Difficulty_N,1);mean(REG_Difficulty_N,1)]
Enjoy_Accuracy=[mean(SVM_Enjoy_N,1);mean(LDA_Enjoy_N,1);mean(EDT_Enjoy_N,1);mean(REG_Enjoy_N,1)]
PosNeg_Accuracy=[mean(SVM_Pos_Neg_N,1);mean(LDA_Pos_Neg_N,1);mean(EDT_Pos_Neg_N,1);mean(REG_Pos_Neg_N,1)]
Intensity_Accuracy=[mean(SVM_Intensity_N,1);mean(LDA_Intensity_N,1);mean(EDT_Intensity_N,1);mean(REG_Intensity_N,1)]
Speed_Accuracy=[mean(SVM_Speed_N,1);mean(LDA_Speed_N,1);mean(EDT_Speed_N,1);mean(REG_Speed_N,1)]
Paddle_Accuracy=[mean(SVM_Paddle_N,1);mean(LDA_Paddle_N,1);mean(EDT_Paddle_N,1);mean(REG_Paddle_N,1)]


Difficulty_Std=[mean(Std_SVM_Diff,1);mean(Std_LDA_Diff,1);mean(Std_EDT_Diff,1);mean(Std_REG_Diff,1)]
Enjoy_Std=[mean(Std_SVM_Enjoy,1);mean(Std_LDA_Enjoy,1);mean(Std_EDT_Enjoy,1);mean(Std_REG_Enjoy,1)]
PosNeg_Std=[mean(Std_SVM_PN,1);mean(Std_LDA_PN,1);mean(Std_EDT_PN,1);mean(Std_REG_PN,1)]
Intensity_Std=[mean(Std_SVM_Int,1);mean(Std_LDA_Int,1);mean(Std_EDT_Int,1);mean(Std_REG_Int,1)]
Speed_Std=[mean(Std_SVM_Speed,1);mean(Std_LDA_Speed,1);mean(Std_EDT_Speed,1);mean(Std_REG_Speed,1)]
Paddle_Std=[mean(Std_SVM_Paddle,1);mean(Std_LDA_Paddle,1);mean(Std_EDT_Paddle,1);mean(Std_REG_Paddle,1)]

Difficulty_Std=[mean(Std_SVM_Diff_N,1);mean(Std_LDA_Diff_N,1);mean(Std_EDT_Diff_N,1);mean(Std_REG_Diff_N,1)]
Enjoy_Std=[mean(Std_SVM_Enjoy_N,1);mean(Std_LDA_Enjoy_N,1);mean(Std_EDT_Enjoy_N,1);mean(Std_REG_Enjoy_N,1)]
PosNeg_Std=[mean(Std_SVM_PN_N,1);mean(Std_LDA_PN_N,1);mean(Std_EDT_PN_N,1);mean(Std_REG_PN_N,1)]
Intensity_Std=[mean(Std_SVM_Int_N,1);mean(Std_LDA_Int_N,1);mean(Std_EDT_Int_N,1);mean(Std_REG_Int_N,1)]
Speed_Std=[mean(Std_SVM_Speed_N,1);mean(Std_LDA_Speed_N,1);mean(Std_EDT_Speed_N,1);mean(Std_REG_Speed_N,1)]
Paddle_Std=[mean(Std_SVM_Paddle_N,1);mean(Std_LDA_Paddle_N,1);mean(Std_EDT_Paddle_N,1);mean(Std_REG_Paddle_N,1)]



