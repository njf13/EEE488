function template = gaussian_template(winsize, sigma)

    center=floor(winsize/2)+1;
    sum=0;
    
    for i=1:winsize
        for j=1:winsize
            template(j,i)=exp(- (((j-center)*(j-center))+((i-center)*(i-center)))/(2*sigma*sigma));
            sum=sum+template(j,i);
        end
    end
    template=template/sum;
end