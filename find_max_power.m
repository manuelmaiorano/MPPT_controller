function [v, P] = find_max_power(map)
%calcolo massimo della potenza
pow = map(:, 1) .* map(:, 2);
[P, idx] = max(pow);
v = map(idx, 1);

end

