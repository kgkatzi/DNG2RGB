function [rawim ,XYZ2Cam ,wbcoeffs ] = readdng(filename)
% This function reads a Digital Negative (DNG) image file and returns the
% raw image data, and metadata


obj = Tiff(filename ,'r');  
offsets = getTag(obj,'SubIFD');   
setSubDirectory(obj,offsets(1));
rawim = read(obj);
close(obj);

meta_info = imfinfo(filename);
% (x_origin ,y_origin) is the uper left corner of the useful part of the
% sensor and consequently of the array rawim
y_origin = meta_info.SubIFDs{1}.ActiveArea(1)+1;
x_origin = meta_info.SubIFDs{1}.ActiveArea(2)+1;
% width and height of the image (the useful part of array rawim)
width = meta_info.SubIFDs{1}.DefaultCropSize(1);
height = meta_info.SubIFDs{1}.DefaultCropSize(2);
blacklevel = meta_info.SubIFDs{1}.BlackLevel(1); % sensor value corresponding
%to black
 whitelevel = meta_info.SubIFDs{1}.WhiteLevel; % sensor value corresponding to
%white

 wbcoeffs = (meta_info.AsShotNeutral).^-1;
 wbcoeffs = wbcoeffs/wbcoeffs(2); % green channel will be left unchanged
 XYZ2Cam = meta_info.ColorMatrix2;
 XYZ2Cam = reshape(XYZ2Cam ,3,3)';

 rawim = double(rawim(y_origin:y_origin+height-1,x_origin:x_origin+width-1));
 %crops the image to only the useful area with information from the metadata

if isfield(meta_info.SubIFDs{1},'LinearizationTable')
ltab=meta_info.SubIFDs{1}.LinearizationTable
rawim = ltab(rawim+1);
end  %depends on the camera/ linearize

rawim = (rawim-blacklevel)/(whitelevel-blacklevel);
rawim= max(0,min(rawim,1));  %normalize to blavk and white levels


end
