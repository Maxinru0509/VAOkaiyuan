function [fitness, KI] = testFunction(x, fhd, fNumber, par, DELTA, DELTAinq)
  
global gvalues; global hvalues; global globalMin; global penalty_coef;
      
[f, g, h] = feval(fhd, x', fNumber);
gnumber=par.g;
hnumber=par.h;  
gnew=g';
hnew=h';
        
    for i=1:size(f,1)
        vio_det(i,:) = violation_2(gnew(i,:)',hnew(i,:)',DELTAinq, gnumber, hnumber, DELTA, 2);
    end   
        
	violation=sum(vio_det,2);

	mean_violation=sum(vio_det,2)/(gnumber+hnumber);
        
	fitness = f + penalty_coef*(violation);      

	if min(fitness) < globalMin
        globalMin = min(fitness); 
        gvalues = g; 
        hvalues = h; 
	end
                   
	KI=vio_det;
       
end
