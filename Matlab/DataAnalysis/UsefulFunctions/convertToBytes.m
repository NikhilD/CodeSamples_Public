function byteVal = convertToBytes(val)
if(val<0)
    if(val>=(-128))
        val = typecast(int8(val),'uint8');
    elseif((val>=-32768)&&(val<-128))
        val = typecast(int16(val),'uint16');
    else
        val = typecast(int32(val),'uint32');
    end
end
if(val<=255)
    byteVal = uint8(val);
elseif((val>255)&&(val<=65535))
    byteVal(1) = uint8(bitand(uint16(val), 255));
    byteVal(2) = uint8(bitshift(uint16(val), -8));
else
    byteVal(1) = uint8(bitand(uint32(val), 255));
    byteVal(2) = uint8(bitand(bitshift(uint32(val), -8), 255));
    byteVal(3) = uint8(bitand(bitshift(uint32(val), -16), 255));
    byteVal(4) = uint8(bitand(bitshift(uint32(val), -24), 255));
end