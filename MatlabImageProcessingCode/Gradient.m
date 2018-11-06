function [difx, dify]=Gradient(img)

    [difx, dify] = gradient(cast(img, 'double'));
end