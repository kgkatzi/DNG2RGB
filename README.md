# DNG2RGB
Created a MATLAB project to convert raw images in DNG format to RGB

Here is a short readme in English based on the selected text from the current web page:

- **Digital Image Processing**
    - This is a project that aims to convert images from RAW format to RGB.
    - It uses two main functions: `readdng.m` and `dng2rgb.m`.
- **Function readdng.m**
    - This function reads a .DNG file and produces a 2D array of sensor measurements.
    - It also reads the metadata of the image, such as the dimensions, the black and white levels, the white balance coefficients, and the XYZ to camera color space matrix.
    - It returns the 2D array, the white balance coefficients, and the XYZ to camera matrix as outputs.
- **Function dng2rgb.m**
    - This function takes the 2D array, the dimensions, the XYZ to camera matrix, the white balance coefficients, the interpolation method, and the Bayer pattern as inputs.
    - It applies the white balance mask, the interpolation, and the color space conversion to produce the RGB image.
    - It also adjusts the brightness and the gamma correction of the image.
    - It returns the final image as output.
- **Interpolation Methods**
    - The project implements two interpolation methods: 'Nearest' and 'Linear'.
    - The 'Nearest' method assigns the value of the nearest pixel with the same color to the missing values.
    - The 'Linear' method calculates the value of the missing pixels by linear interpolation from the neighboring pixels.
- **Bayer Patterns**
    - The project tests four different Bayer patterns: 'bggr', 'gbrg', 'grbg', and 'rggb'.
    - The 'rggb' pattern is the correct one that produces the true colors of the image.
    - The other patterns result in distorted colors, as the values are assigned to the wrong colors.

