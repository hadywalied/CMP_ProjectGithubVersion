function [stuffed] = bitStuff(inputFrame)
%BITSTUFF Summary of this function goes here
%   Detailed explanation goes here

inputStream = inputFrame(:);

numberOfOnes = 0 ;
 n = length (inputStream);
 
 for i = 1:n
     if(inputStream(i) == 1)
         numberOfOnes = 0;
     elseif(inputStream(i)==1)
         numberOfOnes = numberOfOnes +1;
     end
     
     if(numberOfOnes == 6 )
     inputStream = [inputStream(1:i); 1 ; inputStream(i+1:n)];
     numberOfOnes = 0;
     end
    
 end
%  x = mod(length(inputStream),1024);
%  if x~=0
%      inputStream= [inputStream; zeros(1,1024-x)'] ;
%  end

 stuffed = inputStream;
 
end

