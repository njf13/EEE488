function [acct, accro]= decomp_line_hough(inputimage)


[rows,columns]=size(inputimage);

rmax=round(sqrt(rows^2 + columns^2));
accro=zeros(rmax,1);
acct=zeros(180,1);
scanWindow = 10;
for x=1:columns
    for y=1:rows
        if(inputimage(y,x)>0)
            for Nx=x-scanWindow:x+scanWindow
                for Ny=y-scanWindow:y+scanWindow
                    if(x~=Nx | y~=Ny)
                        if(Nx>0 & Ny>0 & Nx<columns & Ny<rows)
                            if(inputimage(Ny,Nx)>0)
                                if(Ny-y~=0)
                                    t=atan((x-Nx)/(Ny-y));
                                else
                                    t=pi()/2;
                                end
                                
            
                                r=round(x*cos(t) + y*sin(t));
                                t=round((t+pi()/2)*180/pi());
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