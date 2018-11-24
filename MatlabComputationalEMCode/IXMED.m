function M=IXMED(X,Y,Z, WORKING_IMAGE)    
    M=1;
    
     sizeVec=size(WORKING_IMAGE);
     maxX=sizeVec(1,1);
     maxY=sizeVec(1,2);
     
     if(X<maxX && Y<maxY)
        if(WORKING_IMAGE(X,Y)>0 && Z<=23 && Z>=17 )
            M=M+1;
        end
     end
end