function normalized = histNormalize(image)

sizeVec=size(image)

rows = sizeVec(1,1)
cols = sizeVec(1,2)

minim=min(image)

range=max(image)-minim

for x=1:cols
    for y=1:rows
        normalized(x,y)=floor((image(y,x)+1-minim)*256.0/double(range));
    end
end
end