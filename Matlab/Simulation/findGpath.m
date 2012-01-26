function link = findGpath(gradVal, nList, type, dThresh)
gradLen = length(gradVal);
[d, inds] = sort(gradVal,'descend');
switch(type)
    case 'min'
        [mingpn, dnext] = min(gradVal);
        link = nList(dnext);
    case 'sort'        
        num = ceil(gradLen/2);
        link = nList(inds(num));          
    case 'thresh'
        for r = 1:gradLen
            dEst = d(r)/d(1);
            if(dEst<=dThresh)
                link = nList(inds(r));
                break;
            end
        end
end