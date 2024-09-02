clc
clear
close all;

%% Problem Definintion
CostFunction = @(x)Sphere(x); 
nVar = 10;             
VarMin = -10;    
VarMax =  10;   

%% GWO Parameters
MaxIt = 100;   
nPop = 50;     

%% Initialization
empty_Gwo.Position = [];
empty_Gwo.Cost = inf;

Gwo = repmat(empty_Gwo,nPop,1);

Alpha = empty_Gwo;
Beta = empty_Gwo;
Delta = empty_Gwo;

for i = 1:nPop
   
    Gwo(i).Position = unifrnd(VarMin,VarMax,[1,nVar]);
    
   
    Gwo(i).Cost = CostFunction(Gwo(i).Position);
    
   
    if Gwo(i).Cost<Alpha.Cost
        Alpha = Gwo(i);
        if Gwo(i).Cost<Beta.Cost
            Beta = Gwo(i);
            if Gwo(i).Cost<Delta.Cost
                Delta = Gwo(i);
            end
        end
    end
    
end

BestCost = zeros(1,MaxIt);
%% GWO Main Loop

for it = 1:MaxIt
    
    a = 2 - it*(2/MaxIt);
    
    for i = 1:nPop
        
       
        r1 = rand(1,nVar);  
        r2 = rand(1,nVar);   
        
        A = 2*a*r1 - a;
        C = 2*r2;
        
        D = abs(C.*(Alpha.Position) - Gwo(i).Position);
        X1 = Alpha.Position - A.*D; 
        
       
        r1 = rand(1,nVar);   
        r2 = rand(1,nVar);   
        
        A = 2*a*r1 - a;
        C = 2*r2;
        
        D = abs(C.*(Beta.Position) - Gwo(i).Position);
        X2 = Beta.Position - A.*D; 
        
        
        
        r1 = rand(1,nVar);   
        r2 = rand(1,nVar);   
        
        A = 2*a*r1 - a;
        C = 2*r2;
        
        D = abs(C.*(Delta.Position) - Gwo(i).Position);
        X3 = Delta.Position - A.*D; 
        
        Gwo(i).Position = (X1 + X2 + X3)/3;
        
         Gwo(i).Position = min(Gwo(i).Position,VarMax);
         Gwo(i).Position = max(Gwo(i).Position,VarMin);
       
        Gwo(i).Cost = CostFunction(Gwo(i).Position);
        
       
        if Gwo(i).Cost<Alpha.Cost
            Alpha = Gwo(i);
            if Gwo(i).Cost<Beta.Cost
                Beta = Gwo(i);
                if Gwo(i).Cost<Delta.Cost
                    Delta = Gwo(i);
                end
            end
        end
        
    end
    
    
    
    BestCost(it) = Alpha.Cost;
    disp(['Iteration ',num2str(it), ', Best Cost = ',num2str(BestCost(it))]);
end


%% Plot Result

figure;
plot(1:MaxIt,BestCost,'LineWidth',2);
xlabel('Iteration')
ylabel('Best Cost')




