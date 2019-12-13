function [Parity_Vector] = parityGenerator(dataFrame,parity)
%PARITYGENERATOR Summary of this function goes here
%   Detailed explanation goes here
    Parity_Vector = [];    

n = length(dataFrame(1,:));

if parity ==0 %even
    for index = 1:n
        column = dataFrame(:,index);
        Parity_Vector = [Parity_Vector mod(sum(column),2)];
    end
    
elseif parity ==1 %odd
        
    for index = 1:n
        column = dataFrame(:,index);
        Parity_Vector = [Parity_Vector not(mod(sum(column),2))];
    end
        
else parity == -1 %noparity
    Parity_Vector = [];    
end

end

