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
i = 1 ;
c = 0 ;
x= mod(n,16)
while (i<=n)
    if (c < 16)
        pid = [pid; de2bi(c,4), de2bi(15-c,4)];
        c=c+1 ;
    else
        c=0;
        n=n+1;
    end
    i=i+1;
end
n= length(dataFrame(1,:));
pid = pid';
z= abs(15-n);
addd=AddressCRCGenerator(address);
ad = addd(12:16);
addr_CRCmat=repmat(ad,1,n);

DataCRCmat=[];
for c=1:n
    col=dataFrame(:,c);
    columnCRC=DataCRCGenerator(col);
    x=length(columnCRC);
    dataCRCVector = columnCRC(1025:x);
    DataCRCmat=[DataCRCmat,dataCRCVector];
end
usbFrame=[sync_matrix;pid;address_matrix;dataFrame;addr_CRCmat;DataCRCmat]
end

