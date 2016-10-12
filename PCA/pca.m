function pca (path, trainList, subDim)
%
% PROTOTYPE
% function pca (path, trainList, subDim)
% 
% USAGE EXAMPLE(S)
% pca ('C:/FERET_Normalised/', trainList500Imgs, 200);
%
% GENERAL DESCRIPTION
% Implements the standard Turk-Pentland Eigenfaces method. As a final
% result, this function saves pcaProj matrix to the disk with all images
% projected onto the subDim-dimensional subspace found by PCA.
% 
% REFERENCES
% M. Turk, A. Pentland, Eigenfaces for Recognition, Journal of Cognitive
% Neurosicence, Vol. 3, No. 1, 1991, pp. 71-86
% 
% M.A. Turk, A.P. Pentland, Face Recognition Using Eigenfaces, Proceedings
% of the IEEE Conference on Computer Vision and Pattern Recognition,
% 3-6 June 1991, Maui, Hawaii, USA, pp. 586-591
%
% All references available on http://www.face-rec.org/algorithms/
% 
% INPUTS:
% path          - full path to the normalised images from FERET database
% trainList     - list of images to be used for training. names should be
%                 without extension and .pgm will be added automatically
% subDim        - Numer of dimensions to be retained (the desired subspace
%                 dimensionality). if this argument is ommited, maximum
%                 non-zero dimensions will be retained, i.e. (number of training images) - 1
%
% OUTPUTS:
% Function will generate and save to the disk the following outputs:
% DATA          - matrix where each column is one image reshaped into a vector
%               - this matrix size is (number of pixels) x (number of images), uint8
% imSpace       - same as DATA but only images in the training set
% psi           - mean face (of training images)
% zeroMeanSpace - mean face subtracted from each row in imSpace
% pcaEigVals    - eigenvalues
% w             - lower dimensional PCA subspace
% pcaProj       - all images projected onto a subDim-dimensional space
%
% NOTES / COMMENTS
% * The following files must either be in the same path as this function
%   or somewhere in Matlab's path:
%       1. listAll.mat - containing the list of all 3816 FERET images
%
% ** Each dimension of the resulting subspace is normalised to unit length
%
% *** Developed using Matlab 7
%
%
% REVISION HISTORY
% -
% 
% RELATED FUNCTIONS (SEE ALSO)
% createDistMat, feret
% 
% ABOUT
% Created:        03 Sep 2005
% Last Update:    -
% Revision:       1.0
% 
% AUTHOR:   Kresimir Delac
% mailto:   kdelac@ieee.org
% URL:      http://www.vcl.fer.hr/kdelac
%
% WHEN PUBLISHING A PAPER AS A RESULT OF RESEARCH CONDUCTED BY USING THIS CODE
% OR ANY PART OF IT, MAKE A REFERENCE TO THE FOLLOWING PAPER:
% Delac K., Grgic M., Grgic S., Independent Comparative Study of PCA, ICA, and LDA 
% on the FERET Data Set, International Journal of Imaging Systems and Technology,
% Vol. 15, Issue 5, 2006, pp. 252-260
%



% If subDim is not given, n - 1 dimensions are
% retained, where n is the number of training images
if nargin < 3
    subDim = dim - 1;
end;


disp(' ')

load listAll;

% Constants
numIm = 3816;


% Memory allocation for DATA matrix
fprintf('Creating DATA matrix\n')
tmp = imread ( [path char(listAll(1)) '.pgm'] );
[m, n] = size (tmp);                    % image size - used later also!!!
DATA = uint8 (zeros(m*n, numIm));       % Memory allocated
clear str tmp;

% Creating DATA matrix
for i = 1 : numIm
    im = imread ( [path char(listAll(i)) '.pgm'] );
    DATA(:, i) = reshape (im, m*n, 1);
end;
save DATA DATA;
clear im;

% Creating training images space
fprintf('Creating training images space\n')
dim = length (trainList);
imSpace = zeros (m*n, dim);
for i = 1 : dim
    index = strmatch (trainList(i), listAll);
    imSpace(:, i) = DATA(:, index);
end;
save imSpace imSpace;
clear DATA;

% Calculating mean face from training images
fprintf('Zero mean\n')
psi = mean(double(imSpace'))';
save psi psi;

% Zero mean
zeroMeanSpace = zeros(size(imSpace));
for i = 1 : dim
    zeroMeanSpace(:, i) = double(imSpace(:, i)) - psi;
end;
save zeroMeanSpace zeroMeanSpace;
clear imSpace;

% PCA
fprintf('PCA\n')
L = zeroMeanSpace' * zeroMeanSpace;         % Turk-Pentland trick (part 1)
[eigVecs, eigVals] = eig(L);

diagonal = diag(eigVals);
[diagonal, index] = sort(diagonal);
index = flipud(index);
 
pcaEigVals = zeros(size(eigVals));
for i = 1 : size(eigVals, 1)
    pcaEigVals(i, i) = eigVals(index(i), index(i));
    pcaEigVecs(:, i) = eigVecs(:, index(i));
end;

pcaEigVals = diag(pcaEigVals);
pcaEigVals = pcaEigVals / (dim-1);
pcaEigVals = pcaEigVals(1 : subDim);        % Retaining only the largest subDim ones

pcaEigVecs = zeroMeanSpace * pcaEigVecs;    % Turk-Pentland trick (part 2)

save pcaEigVals pcaEigVals;

% Normalisation to unit length
fprintf('Normalising\n')
for i = 1 : dim
    pcaEigVecs(:, i) = pcaEigVecs(:, i) / norm(pcaEigVecs(:, i));
end;

% Dimensionality reduction. 
fprintf('Creating lower dimensional subspace\n')
w = pcaEigVecs(:, 1:subDim);
save w w;
clear w;

% Subtract mean face from all images
load DATA;
load psi;
zeroMeanDATA = zeros(size(DATA));
for i = 1 : size(DATA, 2)
    zeroMeanDATA(:, i) = double(DATA(:, i)) - psi;
end;
clear psi;
clear DATA;

% Project all images onto a new lower dimensional subspace (w)
fprintf('Projecting all images onto a new lower dimensional subspace\n')
load w;
pcaProj = w' * zeroMeanDATA;
clear w;
clear zeroMeanDATA;
save pcaProj pcaProj;