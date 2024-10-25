function [coef] = Penalty_Coefficient(funcnum)

j=funcnum;

switch j
    case 1
        coef=0.01;
        
    case 2
        coef=100;   
        
    case 3
        coef=5000;
                
    case 4
        coef=100;
                
    case 5
        coef=100; 
        
    case 6
        coef=10000;
                
    case 7
        coef=100;
        
    case 8
        coef=1000;
                
    case 9
        coef=1000; 
        
    case 10
        coef=1000;
        
    case 11
        coef=1000;

        
end
end


