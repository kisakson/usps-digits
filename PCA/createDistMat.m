function distMat = createDistMat (proj, metric)
%
% PROTOTYPE
% function distMat = createDistMat (proj, metric)
% 
% USAGE EXAMPLE(S)
% pcaDistMatCos = createDistMat(pcaProj, 'COS');
%
% GENERAL DESCRIPTION
% Calculates distance matrix. Creates a matrix of distances between any
% pair of images (vectors) given the metric. L1 (City Block), L2
% (Euclidean) and COS (Cosine Angle) are supported. Once the distance
% matrix for a given metric is calculated, feret tests (with specific
% gallery and probe test sets) or some other tests (e.g. various permutation
% tests) are easily implemented.
% 
% REFERENCES
% -
% 
% INPUTS:
% proj      - projection matrix (all images projected onto a subspace)
%							if using pca.m, give pcaProj as the input
% metric    - metric (L1, L2, MAH and COS supported)
%
% OUTPUTS:
% distMat   - distance matrix where (i,j) element is the distance between
%             i-th and j-th image projection given the metric, class
%             double, size (number of images)^2
%
% NOTES / COMMENTS
% * Developed using Matlab 7
%
% REVISION HISTORY
% -
% 
% RELATED FUNCTIONS (SEE ALSO)
% pdist (Matlab), squareform (Matlab), feret, pca
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


% Memory allocation
distMat = zeros(max(size(proj)));

switch (metric)
    
    case 'L1'
        distMat = pdist(proj', 'cityblock');
    case 'L2'
        distMat = pdist(proj', 'euclidean');
    case 'COS'
        distMat = pdist(proj', 'cosine');
        
    otherwise
        error('%s metric not supported.', metric);

end;    % switch (metric) ends here

distMat = squareform(distMat);