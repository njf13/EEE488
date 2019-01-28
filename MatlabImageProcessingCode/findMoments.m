function [centers] = findMoments(inputImage, targetImage)
    upperTolerance = 1.2;
    lowerTolerance =0.8;
    stride =2;
    
    centers=[]
    [targetSizeX, targetSizeY] = size(targetImage);
    
    [imageMaxX, imageMaxY]=size(inputImage);
    
    targetmu00 = mompq(targetImage, 0,0);
    targetmu20 = mompq(targetImage, 2,0);
    targetmu02 = mompq(targetImage, 0,2);
    targetmu11 = mompq(targetImage, 1,1);
    targetmu30 = mompq(targetImage, 3,0);
    targetmu03 = mompq(targetImage, 0,3);
    targetmu12 = mompq(targetImage, 1,2);
    targetmu21 = mompq(targetImage, 2,1);
    
    gamm = (2+0)/2 + 1;
    targEta20 = targetmu20 / (targetmu00.^gamm);
    gamm = (2+0)/2 + 1;
    targEta02 = targetmu02 / (targetmu00.^gamm);
    gamm = (1+1)/2 + 1;
    targEta11 = targetmu11 / (targetmu00.^gamm);
    gamm = (3+0)/2 + 1;
    targEta30 = targetmu30 / (targetmu00.^gamm);
    gamm = (0+3)/2 + 1;
    targEta03 = targetmu03 / (targetmu00.^gamm);
    gamm = (1+2)/2 + 1;
    targEta12 = targetmu12 / (targetmu00.^gamm);
    gamm = (2+1)/2 + 1;
    targEta21 = targetmu21 / (targetmu00.^gamm);
    
    targM1 = targEta20 + targEta02;
    targM2 = (targEta20 - targEta02).^2 + 4.*targEta11.^2;
    targM3 = (targEta30 - 3.*targEta12).^2 + (3.*targEta21 - targEta03).^2;
    targM4 = (targEta30 + targEta12).^2 + (targEta21 + targEta03).^2;
    targM5 = (targEta30 - targEta12)*(targEta30 + targEta12)*((targEta30 + targEta12).^2 - 3.*(targEta21 + targEta03).^2)+(3*targEta21 - targEta03)*(targEta21 + targEta03)*(3*(targEta30+targEta12).^2 - (targEta21 + targEta03).^2);
    targM6 = (targEta20 - targEta02)*((targEta30 + targEta12).^2 - (targEta21 + targEta03).^2 ) + 4 *targEta11*(targEta30 + targEta12)*(targEta21 + targEta03);
    targM7 = (3*targEta21 - targEta03)*(targEta30 + targEta12)*((targEta30 + targEta12).^2 - 3.*(targEta21 + targEta03).^2) +(3*targEta12 - targEta30)*(targEta21 + targEta03)*(3*(targEta12+targEta30).^2 - (targEta21 + targEta03).^2);
    
    
    for winCenX = targetSizeX/2:stride:imageMaxX-targetSizeX/2
        for winCenY = targetSizeY/2:stride:imageMaxY-targetSizeY/2
            
            subImg = inputImage(winCenX-targetSizeX/2+1:winCenX+targetSizeX/2,winCenY-targetSizeY/2+1:winCenY+targetSizeY/2);

            mu00 = mompq(subImg,0,0);
            mu20 = mompq(subImg,2,0);
            mu02 = mompq(subImg,0,2);
            mu11 = mompq(subImg, 1,1);
            mu30 = mompq(subImg, 3,0);
            mu03 = mompq(subImg, 0,3);
            mu12 = mompq(subImg, 1,2);
            mu21 = mompq(subImg, 2,1);
            
            gamm = (2+0)/2 + 1;
            eta20 = mu20 / (mu00.^gamm);
            gamm = (2+0)/2 + 1;
            eta02 = mu02 / (mu00.^gamm);
            gamm = (1+1)/2 + 1;
            eta11 = mu11 / (mu00.^gamm);
            gamm = (3+0)/2 + 1;
            eta30 = mu30 / (mu00.^gamm);
            gamm = (0+3)/2 + 1;
            eta03 = mu03 / (mu00.^gamm);
            gamm = (1+2)/2 + 1;
            eta12 = mu12 / (mu00.^gamm);
            gamm = (2+1)/2 + 1;
            eta21 = mu21 / (mu00.^gamm);

            M1 = eta20 + eta02;
            M2 = (eta20 - eta02).^2 + 4.*eta11.^2;
            M3 = (eta30 - 3.*eta12).^2 + (3.*eta21 - eta03).^2;
            M4 = (eta30 + eta12).^2 + (eta21 + eta03).^2;
            M5 = (eta30 - eta12)*(eta30 + eta12)*((eta30 + eta12).^2 - 3.*(eta21 + eta03).^2)+(3*eta21 - eta03)*(eta21 + eta03)*(3*(eta30+eta12).^2 - (eta21 + eta03).^2);
            M6 = (eta20 - eta02)*((eta30 + eta12).^2 - (eta21 + eta03).^2 ) + 4 *eta11*(eta30 + eta12)*(eta21 + eta03);
            M7 = (3*eta21 - eta03)*(eta30 + eta12)*((eta30 + eta12).^2 - 3.*(eta21 + eta03).^2) +(3*eta12 - eta30)*(eta21 + eta03)*(3*(eta12+eta30).^2 - (eta21 + eta03).^2);

            
            
            if(M1 > lowerTolerance*targM1 && M1 < upperTolerance*targM1   && ...
                      M2 > lowerTolerance*targM2 && M2 < upperTolerance*targM2)
%                   && ...
%                       M3 > lowerTolerance*targM3 && M3 < upperTolerance*targM3)
                  %&& ...
%                        targM4 > lowerTolerance*M4 && targM4 < upperTolerance*M4)
                   %&& ...
%                     targM5 > lowerTolerance*M5 && targM5 < upperTolerance*M5 && ...
%                     targM6 > lowerTolerance*M6 && targM6 < upperTolerance*M6 && ...
%                     targM7 > lowerTolerance*M7 && targM7 < upperTolerance*M7)
                    
                disp('Found target image...')
                centers = [centers [winCenX;winCenY]];
            end
            
        end
    end


end