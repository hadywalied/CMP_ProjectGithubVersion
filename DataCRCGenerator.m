function [Data_CRC] = DataCRCGenerator(data_vector)
%DATACRCGENERATOR Summary of this function goes here
%   Detailed explanation goes here

H_addr = comm.CRCGenerator('Polynomial',[1 1 0 0 0 0 0 0 0 0 0 0 0 1 0 1],'InitialConditions',ones(1,15));
Data_CRC=step(H_addr,data_vector);

end

