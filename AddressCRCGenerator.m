function [ADDRCRC] = AddressCRCGenerator(address_vector)
%ADDRESSCRCGENERATOR Summary of this function goes here
%   Detailed explanation goes here

H_addr = comm.CRCGenerator('Polynomial',[1 0 0 1 0 1],'InitialConditions',ones(1,5));
ADDRCRC=step(H_addr,address_vector);

end

