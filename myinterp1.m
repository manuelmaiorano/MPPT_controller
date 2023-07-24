function pp = myinterp1(x,y,v)

idx1 = 1;
idx2 = numel(x);

while idx1 < idx2
    if idx2-idx1 == 1
        break;
    end
    mid = floor((idx1+idx2)/2);
    if v < x(mid)
        idx2 = mid;
    else
        idx1 = mid;
    end
end
pp = (y(idx2)-y(idx1))/(x(idx2)-x(idx1))*(v-(x(idx1)))+y(idx1);
end

