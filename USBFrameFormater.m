function [usbFrame] = USBFrameFormater(stream)
%USBFRAMEFORMATER Summary of this function goes here
%   Detailed explanation goes here
dataFrame = DataGenerator(stream,1024);
n = length(dataFrame(1,:));
address=[1 1 1 0 0 0 1 1 1 0 0]';
address_matrix=repmat(address , 1,n);
sync=[0 0 0 0 0 0 0 1]';
sync_matrix=repmat(sync,1,n);
pid = [];
i = 0 ;
c = 0 ;
while (i<n)
    if (c < mod(n,16))
        pid = [pid; de2bi(c,4), de2bi(15-c,4)];
        c=c+1 ;
    else c=0;
    end
    i=i+1;
end
pid = pid';
z= abs(15-n);
addd=AddressCRCGenerator(address);
ad = addd(z:n);
addr_CRCmat=repmat(ad,1,n);

DataCRCmat=[];
for c=1:n
    col=dataFrame(:,c);
    columnCRC=DataCRCGenerator(col);
    dataCRCVector = columnCRC(z:n);
    DataCRCmat=[DataCRCmat,dataCRCVector];
end
usbFrame=[sync_matrix;pid;address_matrix;dataFrame;addr_CRCmat;DataCRCmat]
end
