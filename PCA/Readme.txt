INTRODUCTION

This package implements basic Principal Component Analysis in Matlab and
tests is with grayscale portion of the FERET database. Images are not
preprocessed and it is up to the user to preprocess the images as wanted,
not changing the filenames.

"pca.m" and "createDistMat.m" can be used on any database following the 
same principles described in the header of the files. "feret.m" is specific
for the FERET database but can easily be transformed to be generic if needed.

In addition to the three .m files, standard FERET gallery and probe set lists
are given, along with a list of randomly chosen 500 images that can be used
for testing:

Training set: trainList.mat
Gallery: feretGallery.mat
Probe sets: fb.mat; fc.mat; dup1.mat; dup2.mat


------------------------------------------------------------------------------------

WHEN PUBLISHING A PAPER AS A RESULT OF RESEARCH CONDUCTED BY USING THIS CODE
OR ANY PART OF IT, MAKE A REFERENCE TO THE FOLLOWING PAPER:

Delac K., Grgic M., Grgic S., Independent Comparative Study of PCA, ICA, and LDA 
on the FERET Data Set, International Journal of Imaging Systems and Technology,
Vol. 15, Issue 5, 2006, pp. 252-260

------------------------------------------------------------------------------------

GENERAL INSTRUCTIONS

Run the function pca to create a variable pcaProj.
Input variable pcaProj to the function createDistMat, thus creating a distance
matrix that you then use as an input to the function feret. See headers of
all three functions for more details. The sequence should look something like this:

>> load trainList.mat
>> pca ('C:/FERET_Normalised/', trainList, 200);
>> pcaDistMatCos = createDistMat(pcaProj, 'COS');
>> pcaResultsCOS = feret(pcaDistMatCos, 50);

>> pcaResultsCOS.perc(1)         % gives rank 1 result
>> plot(pcaResultsL1.cms)        % plots the CMS curve

------------------------------------------------------------------------------------


LICENSE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details: http://www.gnu.org/licenses/gpl.txt

