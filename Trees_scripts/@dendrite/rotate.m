% A function to rotate the dendite in X, Y, and Z. 
function y = rotate( obj, X_degrees, Y_degrees, Z_degrees)
    % Will rotate X then Y then Z. If you want to rotate in a
    % different order, you'll need to run the function more than
    % one time.
    startXYZ = [obj.X, obj.Y, obj.Z]
    RX = [1 0 0;
        0 cosd(X_degrees) sind(X_degrees);
        0 -sind(X_degrees) cosd(X_degrees);];

    RY = [cosd(Y_degrees) 0 -sind(Y_degrees);
        0 1 0;
        sind(Y_degrees) 0 cosd(Y_degrees);];

    RZ = [cosd(Z_degrees) sind(Z_degrees) 0;
        -sind(Z_degrees) cosd(Z_degrees) 0;
        0 0 1];

    endX  = zeros(length(obj.X),1);
    endY = endX;
    endZ = endX;

    for i = 1:length(endX)
        size(RX)
        size(RY)
        size(RZ)
        size(startXYZ)
        startXYZ'
        endXYZ = RZ*RY*RX*startXYZ( i,:)';
        endX(i) = endXYZ(1);
        endY(i) = endXYZ(2);
        endZ(i) = endXYZ(3);
    end
    obj.X = endX;
    obj.Y = endY;
    obj.Z = endZ;
end