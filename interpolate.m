
function value = interpolate(map, point)
    if point< map(1, 1) || point > map(end, 1)
        errID = 'MYFUN:BadIndex';
        baseException = MException(errID,'Out of bounds, point: %f', point);
        throw(baseException)
    end
    value = interp1(map(:, 1), map(:, 2), point);
end

