function [value, isterminal, direction] = odeevent(t,x)
global CclSim
if CclSim
    value = 1;
else
    value = 0;
end
isterminal = 1;
direction = 0;
end
