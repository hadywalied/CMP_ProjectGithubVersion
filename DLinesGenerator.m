function [D_Plus,D_minus] = DLinesGenerator(stuffed)
%DPLUSGENERATOR Summary of this function goes here
%   Detailed explanation goes here
stuffedStream = stuffed(:);
n=length(stuffedStream);
D_Plus = ones(1,n);
for i = (2:n)
    if (stuffedStream(i) == 0)
        D_Plus(i) = ~D_Plus(i-1);
    elseif (stuffedStream(i) == 1)
        D_Plus(i) = D_Plus(i-1);
    end
end

D_Plus = [1,D_Plus, 1]; %Adding idleState 1 at the end of the D_plus vector
m=length(D_Plus);
D_minus = [D_Plus(1),~D_Plus(2:m-1),D_Plus(m)];%Creating the D_minus and Adding idleState 1 at the end of the D_minus vector
end

