%% Main Program

% function VAOZImain()

    clc;
    clear;
    close all;
    warning('off');
 
dim = 20; % 维度，可选 10, 20
number=1;  % 函数名： 1 - 12
[lb,ub,dim,fobj] = Get_Functions_cec2022(number,dim);


%       F='F23'; 
%      [lb,ub,dim,fobj]= Functions(F);




    nVar =dim;            % Number of Decision Variables
    VarSize = [1 nVar];        % Decision Variables Matrix Size
    VarMin =lb;              % Decision Variables Lower Bound
    VarMax =ub;               % Decision Variables Upper Bound
       
    %%
 

    MaxIt = 500;               % Maximum Number of Iterations
    nPop = 35 ;                 % Number of Plants

    omega = randi([1 3], 1) * 0.1;
    psi = randi([1 3], 1) * 0.1;
    lambda = randi([10 30], 1) * 0.10;
    mu = 0.2;
    mu_damp = 0.98;
    delta = 0.05 * (VarMax - VarMin);


    num_experiments = 30;  

 for b = 1:num_experiments
        avg_value = 0;  % 初始化平均值
 
%
    
         CostFunction = fobj;

 
       BestCost1 = RODVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
       BestCost2 = VAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
       [best_score,best_pos,BestCost3]=GRO(nVar,MaxIt,VarMin,VarMax,fobj );
       [Best_flame_score,Best_flame_pos,BestCost4]=MFO(nPop,MaxIt, VarMin, VarMax,dim,fobj); 
       [Best_score,Best_pos,BestCost5]=ZOA(MaxIt,VarMin,VarMax,dim,fobj);
       [Alpha_score,Alpha_pos,BestCost6]=GWO(MaxIt,VarMin,VarMax,dim,fobj);
       [Score7,Position7,BestCost7]=rso(MaxIt,VarMin,VarMax,dim,fobj);
       [Rabbit_Energy,Rabbit_Location,BestCost8]=HHO(nPop,MaxIt, VarMin, VarMax,dim,fobj);




%        [BestCost2,mu_history2] = CVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, delta);
%        [BestCost3,mu_history3] = LDVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu,delta);
%        [BestCost4,mu_history4] = ODVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu,delta);
%        [BestCost5,mu_history5] = SDVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu,delta);
%        [BestCost6,mu_history6] = ESVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu,delta);
%        [BestCost7,mu_history7] = ECVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta); 

       
    
      
      
       
       
%        BestCost2 = RLDVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost3 = RODVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost4 = RECVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost5 = TLDVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost6 = TODVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost7 = TECVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);



      
       
           
%        BestCost2 = randVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost3= randnVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost4= trndVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);
%        BestCost5 = logisticVAO(CostFunction, dim, VarSize, VarMin, VarMax, MaxIt, nPop, omega, psi, lambda, mu, mu_damp, delta);

       
        c1(b,:)=BestCost1;
        c2(b,:)=BestCost2;
        c3(b,:)=BestCost3; 
        c4(b,:)=BestCost4;
        c5(b,:)=BestCost5;
        c6(b,:)=BestCost6;
        c7(b,:)=BestCost7;
        c8(b,:)=BestCost8;

        
 end
%   end
    avg1=mean(c1);
    avg2=mean(c2);
    avg3=mean(c3);
    avg4=mean(c4);
    avg5=mean(c5);
    avg6=mean(c6);
    avg7=mean(c7);
    avg8=mean(c8);

    
    Bestavg1 = (avg1(:,MaxIt));%十次运行最好结果的均值
    Bestavg2 = (avg2(:,MaxIt));%十次运行最好结果的均值
    Bestavg3 = (avg3(:,MaxIt));
    Bestavg4 = (avg4(:,MaxIt));
    Bestavg5 = (avg5(:,MaxIt));
    Bestavg6 = (avg6(:,MaxIt));
    Bestavg7 = (avg7(:,MaxIt));
    Bestavg8 = (avg8(:,MaxIt));

    
    std1 = std(c1(:,MaxIt));
    std2 = std(c2(:,MaxIt)); 
    std3 = std(c3(:,MaxIt));
    std4 = std(c4(:,MaxIt));
    std5 = std(c5(:,MaxIt));
    std6 = std(c6(:,MaxIt));
    std7 = std(c7(:,MaxIt));
    std8 = std(c8(:,MaxIt));



          semilogy(avg1,'DisplayName','RODVAO','color','r','Marker','*','markerindices',(1:16:500),'MarkerSize',6,'linewidth',1.3);
          hold on; 
          semilogy(avg2,'DisplayName','VAO','color','b','LineStyle','--','Marker','*','markerindices',(1:25:MaxIt),'MarkerSize',6,'linewidth',1.3);
          hold on;
          semilogy(avg3,'DisplayName','GRO','color','#9933FA','Marker','o','markerindices',(1:22:MaxIt),'MarkerSize',7,'linewidth',1.3);
          hold on;
          semilogy(avg4,'DisplayName','MFO','color','g','Marker','x','markerindices',(1:20:MaxIt),'MarkerSize',6,'linewidth',1.3);
          hold on;
          semilogy(avg5,'DisplayName','ZOA','color','#FFD700','Marker','p','markerindices',(1:29:MaxIt),'MarkerSize',6,'linewidth',1.3);
          hold on;
          semilogy(avg6,'DisplayName','GWO','color','#FF6100','LineStyle','-.','Marker','<','markerindices',(1:20:MaxIt),'MarkerSize',6,'linewidth',1.3);
          hold on;
          semilogy(avg7,'DisplayName','RSO','color','#5E2612','LineStyle',':','Marker','^','markerindices',(1:26:MaxIt),'MarkerSize',6,'linewidth',1.3);
          hold on;
          semilogy(avg8,'DisplayName','HHO','color','c','Marker','>','markerindices',(1:21:MaxIt),'MarkerSize',6,'linewidth',1.3);
          hold on;
          xlabel('Iteration');
          ylabel('Best fitness obtained so far');
          legend('RODVAO','VAO','GRO','MFO','ZOA','GWO','RSO','HHO');
        




%         semilogy(avg1,'DisplayName','VAO','color','b','LineStyle',':','Marker','*','markerindices',(1:25:500),'MarkerSize',6);
%         hold on;
%         semilogy(avg2,'DisplayName','RLDVAO','color','b','LineStyle','--','Marker','o','markerindices',(1:20:500),'MarkerSize',6,'LineWidth',1);
%         hold on;
%         semilogy(avg3,'DisplayName','RODVAO','color','g','LineStyle','--','Marker','d','markerindices',(1:20:500),'MarkerSize',6,'LineWidth',1);
%         hold on;
%         semilogy(avg4,'DisplayName','RECVAO','color','m','LineStyle','--','Marker','s','markerindices',(1:20:500),'MarkerSize',6,'LineWidth',1);
%         hold on;
%         semilogy(avg5,'DisplayName','TLDVAO','color','k','Marker','h','markerindices',(1:20:500),'MarkerSize',6);
%         hold on;
%         semilogy(avg6,'DisplayName','TODVAO','color','b','Marker','p','markerindices',(1:20:500),'MarkerSize',6);
%         hold on;
%         semilogy(avg7,'DisplayName','TECVAO','color','c','Marker','>','markerindices',(1:20:500),'MarkerSize',6);
% 
%         xlabel('Iteration');
%         ylabel('Best fitness obtained so far');
%         legend('VAO','RLDVAO','RODVAO','RECVAO','TLDVAO','TODVAO','TECVAO');

     

%         semilogy(avg2,'DisplayName','randVAO','color','g','LineStyle',':','Marker','o','markerindices',(1:20:500),'MarkerSize',6);
%         hold on;
%         semilogy(avg3,'DisplayName','randnVAO','color','b','LineStyle',':','Marker','d','markerindices',(1:20:500),'MarkerSize',6);
%         hold on;
%         semilogy(avg4,'DisplayName','trndVAO','color','m','LineStyle',':','Marker','s','markerindices',(1:20:500),'MarkerSize',6);
%         hold on;
%         semilogy(avg5,'DisplayName','logisticVAO','color','k','LineStyle',':','Marker','x','markerindices',(1:20:500),'MarkerSize',6);
%         hold on;


       


        
        
        
        
        