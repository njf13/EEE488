function [x1 y1 x2 y2] = get_coords(angle)

    delta = 1E-15;
    
    x1 = ceil((cos(angle + pi()/8)*sqrt(2)) - 0.5 - delta);
    y1 = ceil((-sin(angle - pi()/8)*sqrt(2)) - 0.5 - delta);
    x2 = ceil((cos(angle - pi()/8)*sqrt(2)) - 0.5 - delta);
    y2 = ceil((-sin(angle - pi()/8)*sqrt(2)) - 0.5 - delta);
    
end