[rawim ,XYZ2Cam ,wbcoeffs ] =readdng("RawImage.DNG");

%select one
% bayertype='bggr'
%bayertype='gbrg'
%bayertype='grbg'
 bayertype='rggb'

 %select one
 %method='nearest'
method='linear '

 [Csrgb , Clinear , Cxyz, Ccam] = dng2rgb(rawim , XYZ2Cam , wbcoeffs ,bayertype,method,size(rawim,1), size(rawim,2));
 
figure;
 imshow(Ccam);
 figure;
 imshow(Cxyz);
 figure;
 imshow(Clinear);
 figure;
 imshow(Csrgb);
 title("Image with method " + method+ " and bayer pattern "+bayertype);