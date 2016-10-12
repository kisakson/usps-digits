function [FERET] = feret(distMat, rank)
%
% PROTOTYPE
% function [FERET] = feret(distMat, rank)
% 
% USAGE EXAMPLE(S)
% pcaResultsCOS = feret(pcaDistMatCos, 50);
% pcaResultsCOS.perc(1)         - gives rank 1 result
% plot(pcaResultsL1.cms)        - plots the CMS curve
%
% GENERAL DESCRIPTION
% Implements the standard FERET performance analysis, with standard FERET
% test sets: fa (gallery), fb, fc, dup1, dup2.
% 
% REFERENCES
% P.J. Phillips, H. Moon, S.A. Rizvi, P.J. Rauss, The FERET Evaluation
% Methodology for Face-Recognition Algorithms, IEEE Trans. on PAMI,
% Vol. 22, No. 10, October 2000, pp. 1090-1104
%
% All references available on http://www.face-rec.org/algorithms/
% 
% INPUTS
% distMat       - distance matrix for a given metric, produced by the
%                 createDistMat function
% rank          - wanted highest rank of a CMS curve
%
% OUTPUTS
% FERET structure with the 4 main elements (fb, fc, dup1 and dup2) and the 
% folowing sub-elements:
% perc          - performance (percentage of correctly recognized images)
%                 at each rank. perc(1) rank 1 result, perc(2) the
%                 improvement at rank 2: (result at rank 1) - (result at rank
%                 2)
% rank1			- rank 1 performance (percentage)
% cms           - CMS curve
% numProbeImgs  - total number of images in a given probe set
%
% NOTES / COMMENTS
% * The following files must either be in the same path as this function
%   or somewhere in Matlab's path:
%       1. listAll.mat          - containing the list of all 3816 FERET images
%       2. feretGallery.mat     - list of gallery images
%       3. fb.mat               - list of fb probe set images       
%       4. fc.mat               - list of fc probe set images  
%       5. dup1.mat             - list of dup1 probe set images       
%       6. dup2.mat             - list of dup2 probe set images  
%
% ** Developed using Matlab 7
%
%
% REVISION HISTORY
% -
% 
% RELATED FUNCTIONS (SEE ALSO)
% pca, createDistMat
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


% Load feretGallery and probe lists
load listAll;
load feretGallery;
load fb;
load fc;
load dup1;
load dup2;

% Constants (number of images in feretGallery and probes)
numGalleryImgs = size   (feretGallery, 1);
numFbImgs = size        (fb, 1);
numFcImgs = size        (fc, 1);
numDup1Imgs = size      (dup1, 1);
numDup2Imgs = size      (dup2, 1);

% Get the list of positions where feretGallery images are located in the list
% of all images and store it in variable index
feretGalleryIndex = getIndex (feretGallery, listAll);

% Get the list of all the probe images
fbIndex = getIndex (fb, listAll);
fcIndex = getIndex (fc, listAll);
dup1Index = getIndex (dup1, listAll);
dup2Index = getIndex (dup2, listAll);

% Calculate ranks for the CMS curve
% The results are stores in a structure
FERET.fb = getResults (distMat, feretGallery, feretGalleryIndex, fb, fbIndex, numFbImgs, rank);
FERET.fc = getResults (distMat, feretGallery, feretGalleryIndex, fc, fcIndex, numFcImgs, rank);
FERET.dup1 = getResults (distMat, feretGallery, feretGalleryIndex, dup1, dup1Index, numDup1Imgs, rank);
FERET.dup2 = getResults (distMat, feretGallery, feretGalleryIndex, dup2, dup2Index, numDup2Imgs, rank);



%**************************************************************************
%   Statistics (CMS curve, total number of probe images) 
%**************************************************************************

function [RESULTS] = getResults (distMat, feretGallery, feretGalleryIndex, probe, probeIndex, numProbeImgs, rank)

for j = 1 : rank
    for i = 1 : numProbeImgs

        position = probeIndex(i);
        currentRow = distMat(position,:);
        reduced = currentRow(1, feretGalleryIndex);
                
        [Y, I] = sort(reduced);
        inx = I(j);
        
        % Determine if G=H based on the first 5 characters of the filename
        G = char(feretGallery(inx));
        H = char(probe(i));
        correct(i) = strncmp(G, H, 5);
        % if G=H correct(i)=1, else 0
        
    end;
    
    % Rank 1 result (percentage)
    if j == 1
    	RESULTS.rank1 = (sum(correct)/numProbeImgs)*100;
    end;
    
    % Percentage of correctly recognized images for a given probe set
    RESULTS.perc(j) = (sum(correct)/numProbeImgs)*100;
    
		% CMS curve
    RESULTS.cms(j) = sum(RESULTS.perc(1:j));
    
end;

% Total number of probe images
RESULTS.numProbeImgs = numProbeImgs;
%**************************************************************************




%**************************************************************************
%   Find positions of probe or feretGallery images in the list of all images 
%**************************************************************************

function [index] = getIndex (sub, all)

num = size (sub, 1);
for i = 1 : num
    index(i) = strmatch(sub(i), all);
end;
%**************************************************************************