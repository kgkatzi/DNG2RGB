function [Csrgb , Clinear , Cxyz, Ccam] = dng2rgb(rawim , XYZ2Cam , wbcoeffs ,bayertype , method , M, N)
mask=wbmask(M,N,wbcoeffs,bayertype);  %creates a mask that corrects white balance
rawim=rawim.*mask; %mask on rawimage

red=zeros(M,N);
green=zeros(M,N);
blue=zeros(M,N);   %grids of 3 colors
 
x_ones = find(mod(1:M, 2) ==1);
y_ones =find(mod(1:N, 2) ==1);
x_zeros =find(mod(1:M, 2) ==0);
y_zeros= find(mod(1:N, 2) ==0);  %finds the numbers of 2 dimentions that are divided my 2 and the ones that are not
%they are used because the pattern is 2x2
%example: for rggb red is x_ones, y_ones, green is x_ones, y_zeros and
%x_zeros, y_ones, blue is x_zeros, y_zeros

rgb2xyz=[0.4124564 0.3575761 0.1804375; 0.2126729 0.7151522 0.0721750 ; 0.0193339 0.1191920 0.9503041];
%used to tranform from rgb to xyz color space

%not used   T=[3.2406 -1.5372 -0.4986; -0.9689 -0.2040 0.0415; 0.0557 -0.2040 1.0570];

   
if method=='nearest'
    if bayertype=='rggb'
         red(x_ones,y_ones)=rawim(x_ones,y_ones);
         blue(x_zeros,y_zeros)=rawim(x_zeros,y_zeros);
         %values according to the pattern

         red(x_ones, y_zeros)=rawim(x_ones, y_zeros-1);
         red(x_zeros, y_ones)=rawim(x_zeros-1, y_ones);
         red(x_zeros, y_zeros)=rawim(x_zeros-1, y_ones);
         %gives the other pixels that have no value yet, the nearest value


         blue(x_zeros, y_ones)=rawim(x_zeros, y_ones+1);
         blue(x_ones, y_zeros)=rawim(x_ones+1, y_zeros);
         blue(x_ones, y_ones)=rawim(x_ones, y_ones+1);
         %nearest value for blue
    

         green(x_ones,y_zeros) = rawim(x_ones,y_zeros);
         green(x_zeros,y_ones) = rawim(x_zeros,y_ones);
         %according to the pattern
         green(x_ones, y_ones)=rawim(x_ones, y_ones+1);
         green(x_zeros, y_zeros)=rawim(x_zeros-1,y_zeros);
         %nearest value for green

        %same thing for other patterns
     elseif bayertype=='grbg'
         red(x_ones, y_zeros)=rawim(x_ones, y_zeros);
         blue(x_zeros,y_ones)=rawim(x_zeros,y_ones);
         green(x_ones,y_ones)=rawim(x_ones,y_ones);
         green(x_zeros,y_zeros)=rawim(x_zeros,y_zeros);
         

         red(x_zeros,y_zeros)=rawim(x_zeros-1,y_zeros);
         red(x_ones, y_ones)=rawim(x_ones, y_ones+1);
         red(x_zeros,y_ones)=rawim(x_zeros-1,y_ones);

         blue(x_zeros,y_zeros)=rawim(x_zeros,y_zeros-1);
         blue(x_ones,y_ones)=rawim(x_ones, y_ones+1);
         blue(x_ones,y_zeros)=rawim(x_ones,y_zeros-1);

         green(x_ones, y_zeros)=rawim(x_ones, y_zeros-1);
         green(x_zeros,y_ones)=rawim(x_zeros,y_ones+1);


     elseif bayertype=='gbrg'
         red(x_zeros,y_ones)=rawim(x_zeros,y_ones);
         blue(x_ones,y_zeros)=rawim(x_ones,y_zeros);
         green(x_ones,y_ones)=rawim(x_ones,y_ones);
         green(x_zeros,y_zeros)=rawim(x_zeros,y_zeros);

         red(x_zeros,y_zeros)=rawim(x_zeros,y_zeros-1);
         red(x_ones,y_ones)=rawim(x_ones,y_ones+1);
         red(x_ones,y_zeros)=rawim(x_ones,y_zeros-1);

         blue(x_zeros,y_zeros)=rawim(x_zeros-1, y_zeros);
         blue(x_ones,y_ones)=rawim(x_ones,y_ones+1);
         blue(x_zeros,y_ones)=rawim(x_zeros-1,y_ones);

         green(x_ones,y_zeros)=rawim(x_ones,y_zeros-1);
         green(x_zeros,y_ones)=rawim(x_zeros,y_ones+1);
     elseif bayertype=='bggr'
         blue(x_ones,y_ones)=rawim(x_ones,y_ones);
         red(x_zeros,y_zeros)=rawim(x_zeros,y_zeros);
         green(x_ones,y_zeros)=rawim(x_ones,y_zeros);
         green(x_zeros,y_ones)=rawim(x_zeros,y_ones);

         red(x_zeros,y_ones)=rawim(x_zeros,y_ones+1);
         red(x_ones,y_ones)=rawim(x_ones+1,y_ones);
         red(x_ones,y_zeros)=rawim(x_ones,y_zeros-1);

         blue(x_ones,y_zeros)=rawim(x_ones,y_zeros-1);
         blue(x_zeros,y_ones)=rawim(x_zeros-1,y_zeros);
         blue(x_zeros,y_zeros)=rawim(x_zeros-1, y_zeros);

         green(x_zeros,y_zeros)=rawim(x_zeros,y_zeros-1);
         green(x_ones,y_ones)=rawim(x_ones,y_ones+1);
    end


elseif method=='linear '
    if bayertype=='rggb'
         red(x_ones,y_ones)=rawim(x_ones,y_ones);
         blue(x_zeros,y_zeros)=rawim(x_zeros,y_zeros); 
         green(x_ones,y_zeros) = rawim(x_ones,y_zeros);
         green(x_zeros,y_ones) = rawim(x_zeros,y_ones);
         
         %for linear method I gave the other pixels the mean value of the
         %ones next to them. I did this for all the pixels except for the
         %ones on the outline
         %same thing for other colors and other patterns
         red(x_ones,y_zeros(1:length(y_zeros)-1))=(rawim(x_ones,y_zeros(1:length(y_zeros)-1)-1)+rawim(x_ones,y_zeros(1:length(y_zeros)-1)+1))/2;
         red(x_ones,N)=rawim(x_ones,N-1);
         %pixels on the outline must have a different treatment, because
         %they only have other pixels on one side of them
         
        
         red(x_zeros(1:length(x_zeros)-1),y_ones)=(rawim(x_zeros(1:length(x_zeros)-1)-1,y_ones)+rawim(x_zeros(1:length(x_zeros)-1)+1,y_ones))/2;
         red(M,y_ones)=rawim(M-1,y_ones);
        
         %in this position of the pattern, the pixel gets the mean of 4
         %pixels that are next to it
         %again different treatment for every case of outline pixels
        red(x_zeros(1:length(x_zeros)-1),y_zeros(1:length(y_zeros)-1))=(red(x_zeros(1:length(x_zeros)-1)-1, y_zeros(1:length(y_zeros)-1))+red(x_zeros(1:length(x_zeros)-1)+1, y_zeros(1:length(y_zeros)-1))+red(x_zeros(1:length(x_zeros)-1),y_zeros(1:length(y_zeros)-1)+1)+red(x_zeros(1:length(x_zeros)-1),y_zeros(1:length(y_zeros)-1)-1))/4;
        red(x_zeros(1:length(x_zeros)-1),N)=(red(x_zeros(1:length(x_zeros)-1)-1, N)+red(x_zeros(1:length(x_zeros)-1)+1, N)+red(x_zeros(1:length(x_zeros)-1),N-1))/3;
         red(M,y_zeros(1:length(y_zeros)-1))=(red(M-1, y_zeros(1:length(y_zeros)-1))+red(M,y_zeros(1:length(y_zeros)-1)+1)+red(M,y_zeros(1:length(y_zeros)-1)-1))/3;
         red(M,N)=(red(M-1, N)+red(M,N-1))/2;
         

         blue(x_zeros,y_ones(2:length(y_ones)))=(rawim(x_zeros,y_ones(2:length(y_ones))-1)+rawim(x_zeros,y_ones(2:length(y_ones))+1))/2;
          blue(x_zeros,1)=rawim(x_zeros,2);
         

         blue(x_ones(2:length(x_ones)),y_zeros)=(rawim(x_ones(2:length(x_ones))-1,y_zeros)+rawim(x_ones(2:length(x_ones))+1,y_zeros))/2;
         blue(1,y_zeros)=rawim(2,y_zeros);
         

          blue(x_ones(2:length(x_ones)),y_ones(2:length(y_ones)))=(blue(x_ones(2:length(x_ones))-1,y_ones(2:length(y_ones)))+blue(x_ones(2:length(x_ones))+1,y_ones(2:length(y_ones)))+blue(x_ones(2:length(x_ones)),y_ones(2:length(y_ones))-1)+blue(x_ones(2:length(x_ones)),y_ones(2:length(y_ones))+1))/4;
         blue(1,y_ones(2:length(y_ones)))=(blue(2,y_ones(2:length(y_ones)))+blue(1,y_ones(2:length(y_ones))-1)+blue(1,y_ones(2:length(y_ones))+1))/3;
         blue(x_ones(2:length(x_ones)),1)=(blue(x_ones(2:length(x_ones))-1,1)+blue(x_ones(2:length(x_ones))+1,1)+blue(x_ones(2:length(x_ones)),2))/3;
         
 green(x_ones, y_ones(2:length(y_ones)))=(green(x_ones,y_ones(2:length(y_ones))-1)+green(x_ones,y_ones(2:length(y_ones))+1))/2;
 green(x_ones,1)=green(x_ones,2);



green(x_zeros,y_zeros(1:length(y_zeros)-1))=(green(x_zeros,y_zeros(1:length(y_zeros)-1)-1)+green(x_zeros,y_zeros(1:length(y_zeros)-1)+1))/2;
 green(x_zeros,N)=green(x_zeros,N-1);
   
     elseif bayertype=='grbg'
         red(x_ones, y_zeros)=rawim(x_ones, y_zeros);
         blue(x_zeros,y_ones)=rawim(x_zeros,y_ones);
         green(x_ones,y_ones)=rawim(x_ones,y_ones);
         green(x_zeros,y_zeros)=rawim(x_zeros,y_zeros);

         red(x_zeros(1:length(x_zeros)-1),y_zeros)=(rawim(x_zeros(1:length(x_zeros)-1)-1,y_zeros)+rawim(x_zeros(1:length(x_zeros)-1)+1,y_zeros))/2;
        red(M,y_zeros)=rawim(M,y_zeros);
         
         red(x_ones,y_ones(2:length(y_ones)))=(rawim(x_ones,y_ones(2:length(y_ones))-1)+rawim(x_ones,y_ones(2:length(y_ones))+1))/2;
         red(x_ones,1)=rawim(x_ones,2);
         

        red(x_zeros(1:length(x_zeros)-1),y_ones(2:length(y_ones)))=(red(x_zeros(1:length(x_zeros)-1)+1, y_ones(2:length(y_ones)))+red(x_zeros(1:length(x_zeros)-1)-1,y_ones(2:length(y_ones)))+red(x_zeros(1:length(x_zeros)-1),y_ones(2:length(y_ones))+1)+red(x_zeros(1:length(x_zeros)-1),y_ones(2:length(y_ones))-1))/4;
         red(M,y_ones(2:length(y_ones)))=(red(M-1,y_ones(2:length(y_ones)))+red(M,y_ones(2:length(y_ones))+1)+red(M,y_ones(2:length(y_ones))-1))/3;
         red(x_zeros(1:length(x_zeros)-1),1)=(red(x_zeros(1:length(x_zeros)-1)+1, 1)+red(x_zeros(1:length(x_zeros)-1)-1,1)+red(x_zeros(1:length(x_zeros)-1),2))/3;
         red(M,1)=(red(M-1,1)+red(M,2))/2;
        

         
         blue(x_zeros,y_zeros(1:length(y_zeros)-1))=(blue(x_zeros,y_zeros(1:length(y_zeros)-1)-1)+blue(x_zeros,y_zeros(1:length(y_zeros)-1)+1))/2;
         blue(x_zeros,N)=blue(x_zeros,N-1);
        

        blue(x_ones(2:length(x_ones)),y_ones)=(blue(x_ones(2:length(x_ones))+1, y_ones)+blue(x_ones(2:length(x_ones))-1,y_ones))/2;
         blue(1,y_ones)=blue(2,y_ones);
         

        blue(x_ones(2:length(x_ones)),y_zeros(1:length(y_zeros)-1))=(blue(x_ones(2:length(x_ones))+1,y_zeros(1:length(y_zeros)-1))+blue(x_ones(2:length(x_ones))-1,y_zeros(1:length(y_zeros)-1))+blue(x_ones(2:length(x_ones)),y_zeros(1:length(y_zeros)-1)-1)+blue(x_ones(2:length(x_ones)),y_zeros(1:length(y_zeros)-1)+1))/4;
         blue(1,y_zeros(1:length(y_zeros)-1))=(blue(2,y_zeros(1:length(y_zeros)-1))+blue(1,y_zeros(1:length(y_zeros)-1)-1)+blue(1,y_zeros(1:length(y_zeros)-1)+1))/3;
          blue(x_ones(2:length(x_ones)),N)=(blue(x_ones(2:length(x_ones))+1,N)+blue(x_ones(2:length(x_ones))-1,N)+blue(x_ones(2:length(x_ones)),N-1))/3;
        blue(1,N)=(blue(2,N)+blue(1,N-1))/2;
         

         green(x_ones,y_zeros(1:length(y_zeros)-1))=(green(x_ones,y_zeros(1:length(y_zeros)-1)-1)+green(x_ones,y_zeros(1:length(y_zeros)-1)+1))/2;
        green(x_ones,N)=green(x_ones,N-1);
       
        green(x_zeros,y_ones(2:length(y_ones)-1))=(green(x_zeros,y_ones(2:length(y_ones)-1)-1)+green(x_zeros,y_ones(2:length(y_ones)-1)+1))/2;
         green(x_zeros,1)=green(x_zeros,2);
        

       elseif bayertype=='gbrg'
         red(x_zeros,y_ones)=rawim(x_zeros,y_ones);
         blue(x_ones,y_zeros)=rawim(x_ones,y_zeros);
         green(x_ones,y_ones)=rawim(x_ones,y_ones);
         green(x_zeros,y_zeros)=rawim(x_zeros,y_zeros);

         red(x_zeros,y_zeros(1:length(y_zeros)-1))=(red(x_zeros,y_zeros(1:length(y_zeros)-1)-1)+red(x_zeros,y_zeros(1:length(y_zeros)-1)+1))/2;
          red(x_zeros,N)=red(x_zeros,N-1);
         
         red(x_ones(2:length(x_ones)),y_ones)=(red(x_ones(2:length(x_ones))-1,y_ones)+red(x_ones(2:length(x_ones))+1,y_ones))/2;
          red(1,y_ones)=red(2,y_ones);
        

         red(x_ones(2:length(x_ones)),y_zeros(1:length(y_zeros)-1))=(red(x_ones(2:length(x_ones))-1,y_zeros(1:length(y_zeros)-1))+red(x_ones(2:length(x_ones))+1,y_zeros(1:length(y_zeros)-1))+red(x_ones(2:length(x_ones)),y_zeros(1:length(y_zeros)-1)-1)+red(x_ones(2:length(x_ones)),y_zeros(1:length(y_zeros)-1)+1))/4;
         red(1,y_zeros(1:length(y_zeros)-1))=(red(2,y_zeros(1:length(y_zeros)-1))+red(1,y_zeros(1:length(y_zeros)-1)-1)+red(1,y_zeros(1:length(y_zeros)-1)+1))/3;
          red(x_ones(2:length(x_ones)),N)=(red(x_ones(2:length(x_ones))-1,N)+red(x_ones(2:length(x_ones))+1,N)+red(x_ones(2:length(x_ones)),N-1))/3;
          red(1,N)=(red(2,N)+red(1,N-1))/2;
         

         blue(x_zeros(1:length(x_zeros)-1),y_zeros)=(blue(x_zeros(1:length(x_zeros)-1)+1,y_zeros)+blue(x_zeros(1:length(x_zeros)-1)-1,y_zeros))/2;
        blue(M,y_zeros)=blue(M-1,y_zeros);
         
        blue(x_ones,y_ones(2:length(y_ones)))=(blue(x_ones,y_ones(2:length(y_ones))-1)+blue(x_ones,y_ones(2:length(y_ones))+1))/2;
         blue(x_ones,1)=blue(x_ones,2);
        

        blue(x_zeros(1:length(x_zeros)-1),y_ones(2:length(y_ones)))=(blue(x_zeros(1:length(x_zeros)-1)-1,y_ones(2:length(y_ones)))+blue(x_zeros(1:length(x_zeros)-1)+1,y_ones(2:length(y_ones)))+blue(x_zeros(1:length(x_zeros)-1),y_ones(2:length(y_ones))-1)+blue(x_zeros(1:length(x_zeros)-1),y_ones(2:length(y_ones))+1))/4;
        blue(M,y_ones(2:length(y_ones)))=(blue(M-1,y_ones(2:length(y_ones)))+blue(M,y_ones(2:length(y_ones))-1)+blue(M,y_ones(2:length(y_ones))+1))/3;
          blue(x_zeros(1:length(x_zeros)-1),1)=(blue(x_zeros(1:length(x_zeros)-1)-1,1)+blue(x_zeros(1:length(x_zeros)-1)+1,1)+blue(x_zeros(1:length(x_zeros)-1),2))/3;
         blue(M,1)=(blue(M-1,1)+blue(M,2))/2;
        

         green(x_ones,y_zeros(1:length(y_zeros)-1))=(green(x_ones,y_zeros(1:length(y_zeros)-1)-1)+green(x_ones,y_zeros(1:length(y_zeros)-1)+1))/2;
          green(x_ones,N)=green(x_ones,N);
         
         green(x_zeros,y_ones(2:length(y_ones)))=(green(x_zeros,y_ones(2:length(y_ones))+1)+green(x_zeros,y_ones(2:length(y_ones))-1))/2;
         green(x_zeros,1)=green(x_zeros,2);
         
    elseif bayertype=='bggr'
         blue(x_ones,y_ones)=rawim(x_ones,y_ones);
         red(x_zeros,y_zeros)=rawim(x_zeros,y_zeros);
         green(x_ones,y_zeros)=rawim(x_ones,y_zeros);
         green(x_zeros,y_ones)=rawim(x_zeros,y_ones);

        red(x_zeros,y_ones(2:length(y_ones)))=(red(x_zeros,y_ones(2:length(y_ones))-1)+red(x_zeros,y_ones(2:length(y_ones))+1))/2;
        red(x_zeros,1)=red(x_zeros,2);
        

        red(x_ones(2:length(x_ones)),y_zeros)=(red(x_ones(2:length(x_ones))-1,y_zeros)+red(x_ones(2:length(x_ones))+1,y_zeros))/2;
        red(1,y_zeros)=red(2,y_zeros);

        red(x_ones(2:length(x_ones)),y_ones(2:length(y_ones)))=(red(x_ones(2:length(x_ones))-1,y_ones(2:length(y_ones)))+red(x_ones(2:length(x_ones))+1,y_ones(2:length(y_ones)))+red(x_ones(2:length(x_ones)),y_ones(2:length(y_ones))-1)+red(x_ones(2:length(x_ones)),y_ones(2:length(y_ones))+1))/4;
        red(1,y_ones(2:length(y_ones)))=(red(2,y_ones(2:length(y_ones)))+red(1,y_ones(2:length(y_ones))-1)+red(1,y_ones(2:length(y_ones))+1))/3;
        red(x_ones(2:length(x_ones)),1)=(red(x_ones(2:length(x_ones))-1,1)+red(x_ones(2:length(x_ones))+1,1)+red(x_ones(2:length(x_ones)),2))/3;
        red(1,1)=(red(2,1)+red(1,2))/2;
       

        blue(x_zeros(1:length(x_zeros)-1),y_ones)=(blue(x_zeros(1:length(x_zeros)-1)-1,y_ones)+blue(x_zeros(1:length(x_zeros)-1)+1,y_ones))/2;
         blue(M,y_ones)=blue(M-1,y_ones);
        
        blue(x_ones,y_zeros(1:length(y_zeros)-1))=(blue(x_ones,y_zeros(1:length(y_zeros)-1)-1)+blue(x_ones,y_zeros(1:length(y_zeros)-1)+1))/2;
        blue(x_ones,N)=blue(x_ones,N-1);
       

        blue(x_zeros(1:length(x_zeros)-1),y_zeros(1:length(y_zeros)-1))=(blue(x_zeros(1:length(x_zeros)-1)-1,y_zeros(1:length(y_zeros)-1))+blue(x_zeros(1:length(x_zeros)-1)+1,y_zeros(1:length(y_zeros)-1))+blue(x_zeros(1:length(x_zeros)-1),y_zeros(1:length(y_zeros)-1)-1)+blue(x_zeros(1:length(x_zeros)-1),y_zeros(1:length(y_zeros)-1)+1))/4;
        blue(M,y_zeros(1:length(y_zeros)-1))=(blue(M-1,y_zeros(1:length(y_zeros)-1))+blue(M,y_zeros(1:length(y_zeros)-1)-1)+blue(M,y_zeros(1:length(y_zeros)-1)+1))/3;
        blue(x_zeros(1:length(x_zeros)-1),N)=(blue(x_zeros(1:length(x_zeros)-1)-1,N)+blue(x_zeros(1:length(x_zeros)-1)+1,N)+blue(x_zeros(1:length(x_zeros)-1),N-1))/3;
        blue(M,N)=(blue(M-1,N)+blue(M,N-1))/2;
        

      green(x_ones,y_ones(2:length(y_ones)))=(green(x_ones,y_ones(2:length(y_ones))+1)+green(x_ones,y_ones(2:length(y_ones))-1))/2;
      green(x_ones,1)=green(x_ones,2);
      

      green(x_zeros,y_zeros(1:length(y_zeros)-1))=(green(x_zeros,y_zeros(1:length(y_zeros)-1)-1)+green(x_zeros,y_zeros(1:length(y_zeros)-1)+1))/2;
      green(x_zeros,N)=green(x_zeros,N-1);
      
         


    end

end

 
   
Ccam=cat(3,red, green, blue); %unite the color grids to one rgb image
      rgb2cam = XYZ2Cam * rgb2xyz; % these to matrices can be used to go from rgb to camera color space, with xyz step in between
         rgb2cam = rgb2cam ./ repmat(sum(rgb2cam,2),1,3); %normalizes the rows of the rgb2cam matrix such that the sum of the values in each row equals 1.
    cam2rgb = rgb2cam^(-1);  %maps RGB color values to a color appearance model (CAM)
          Cxyz=imfilter(Ccam, XYZ2Cam^(-1)); % get image in XYZ color space

          if bayertype=='rggb'  %these only hapens because I saw better results using each one on these different patterns
        Clinear= apply_cmatrix(Ccam,  cam2rgb ); 
          else
              Clinear = imfilter(Ccam,  cam2rgb );
          end
          %they both apply Camera to RGB matrice to my image

        Clinear = max(0,min(Clinear,1)); % Always keep image clipped between  0-1

        %Brightness and Gamma Correction
         grayim = rgb2gray(Clinear);  % find the mean luminance of the image in grayscale
         grayscale = 0.25/mean(grayim(:));  %scale the image so that the mean luminance is 1/4 the maximum
         Csrgb = min(1,Clinear*grayscale);
         Csrgb = Csrgb.^(1/2.2); %gamma correction
         
   %histograms of color channels
figure
histogram(red,'EdgeColor','r')
title("Histogram of red color",'Color','r')
figure
histogram(green,'EdgeColor','g')
title("Histogram of green color",'Color','g')
figure
histogram(blue,'EdgeColor','b')
title("Histogram of blue color",'Color','b')
 

end