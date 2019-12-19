function [stuffed] = bitStuff(inputFrame)
%BITSTUFF Summary of this function goes here
%   Detailed explanation goes here

inputStream = inputFrame(:);

numberofzeros = 0 ;
 n = length (inputStream);
 
 for i = 1:n
     if(inputStream(i) == 1)
         numberofzeros = 0;
     elseif(inputStream(i)==0)
         numberofzeros = numberofzeros +1;
     end
     
     if(numberofzeros == 6 )
     inputStream = [inputStream(1:i); 1 ; inputStream(i+1:n)];
     numberofzeros = 0;
     end
    
 end
%  x = mod(length(inputStream),1024);
%  if x~=0
%      inputStream= [inputStream; zeros(1,1024-x)'] ;
%  end

 stuffed = inputStream;
 
end

