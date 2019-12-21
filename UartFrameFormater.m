function [uartFrame] = UartFrameFormater(dataStream,parity,m,numberOfBits)
%UARTFRAMEFORMATER Summary of this function goes here
%   Detailed explanation goes here
dataFrame = DataGenerator(dataStream,numberOfBits);

n = length(dataFrame(1,:));

Parity_Vector = parityGenerator(dataFrame,parity);


uartFrame = [zeros(1,n); dataFrame ;Parity_Vector ;ones(m,n)] ;

end

