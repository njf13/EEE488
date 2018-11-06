function [acct, accro]= decomp_line_hough(inputimage)


[rows,columns]=size(inputimage);

rmax=round(sqrt(rows^2 + columns^2));
accro=zeros(rmax,1);
acct=zeros(91,1);
scanWindow = 5;
for x=1:columns
    for y=1:rows
        if(inputimage(y,x)>0)
            for Nx=x-scanWindow:x+scanWindow
                for Ny=y-scanWindow:y+scanWindow
                    if(x~=Nx | y~=Ny)
                        if(Nx>0 & Ny>0 & Nx<columns & Ny<rows)
                            if(inputimage(Ny,Nx)>0)
                                if(x~=0)
                                    t=abs(atan((-y)/(x)));
                                else
                                    t=pi()/2;
                                end
                                
            
                                r=round(sqrt(x^2 + y^2));
                                t=ceil((t)*180/pi());
                                acct(t) = acct(t) + 1;

                                if(r<rmax & r>0)
                                    accro(r)=accro(r)+1;
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

end