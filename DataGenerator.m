function [Data] = DataGenerator(stream,bitsnumber)
%DATACREATOR Summary of this function goes here
%   Detailed explanation goes here
streamLength= length(stream);
x = mod(streamLength,bitsnumber);
if x~=0 
   stream= [stream, zeros(1,bitsnumber-x)] ;
end
Data = reshape(stream,bitsnumber,[]);
end

