function M=IXMED(X,Y,Z)
    M=1;
    
    P1=[39,10,39];
    P2=[39,20,39];
    P3=[33,28,39];
    P4=[45,28,39];
    
    P0=[X,Y,Z];
    
    D12 = norm(cross(P2-P1,P0-P1))/norm(P2-P1);
    D23 = norm(cross(P3-P2,P0-P2))/norm(P3-P2);
    D24 = norm(cross(P4-P2,P0-P2))/norm(P4-P2);
    
    
%     
%     if((X>45)||(X<33))
%         return
%     end
    
    if(D12<2) 
        M=M+1;
        return
    end
    
    if(D23<2)
        M=M+1;
        return
    end
    
    if(D24<2)
        M=M+1;
        return
    end
    
end