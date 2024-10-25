function x=pareto(a,b,m,n)
%**************************************************************************************************
% Note: We obtained the MATLAB source code from 
% https://www.mathworks.com/matlabcentral/fileexchange/47269-pareto-m
% provided by by Sarojkumar.
%**************************************************************************************************
%==========================================================================
% This function generates a sequence of pareto random variables 
% of size (m,n)
% Syntax 
% x=pareto(a,b,m,n)
% where a=scale parameter and b=location parameter 
%==========================================================================
    u=rand(m,n);
    x1=(1-u).^(1/a);
    x=b./x1;
end

%==========================================================================