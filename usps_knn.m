% Kara Isakson
% MATH401 Midterm 2

load('usps_all');

% Some code below is from a Mathworks page on Machine Learning with the USPS
% set. Usage explained more in my paper.

x = double(reshape(data,256,11000)'); % Resize matrix from 3D to 2D. 256 cols, 11000 rows.
ylabel = [1:9 0]; % Create basic vector 1,2,3,4,5,6,7,8,9,0.
y = reshape(repmat(ylabel,1100,1),11000,1); % Resize to align with reshapen data.
clearvars data % Data has been copied into x, remove this "old" data.
% clearvars is repeatedly used since this program otherwise saves so much
% unnecessary data. Large pieces of data are cleared.

% Align data average with 0 as necessary for the PCA method.
average = x(1,:);
for i = 2:11000
  average = average + x(i,:);  
end
average = double(average/11000);
for i = 1:11000
  x(i,:) = double(x(i,:) - average);
end
clearvars average;

% Use PCA method to reduce dimensionality; some code help from face
% recognition file, cited and explained more in my paper.
XtX = x' * x; % Matrix transpose multiplied by matrix.
[eigVecs, eigVals] = eig(XtX); % Get the eigenvalues and vectors from that.
diagVals = diag(eigVals); % Put eigenvalues into a diagonal vector.
[diagVals, index] = sort(diagVals); % Sort the values and assign an index..
index = flipud(index); % .. with lowest index to highest eigenvalue.

pcaEigVecs = zeros(size(eigVals));
pcaEigVals = zeros(size(eigVals));
for i = 1 : size(eigVals, 1) % Flip the eigenvalues and eigenvectors.
    pcaEigVals(i, i) = eigVals(index(i), index(i));
    pcaEigVecs(:, i) = eigVecs(:, index(i));
end
clearvars XtX; clearvars eigVecs; clearvars eigVals; clearvars diagVals;

newDimension = 22; % Dimensionality reduced from 256 to this value.
lowDim = pcaEigVecs(:,1:newDimension); % Remove unnecessary eigenvectors.
lowDim = lowDim' * x'; %(newDimension x 256 * 256 x 11000 = newDim x 11000) 
x = lowDim'; % Transpose x back to 11000 x newDim.
clearvars lowDim; clearvars pcaEigVecs; clearvars pcaEigVals;

cv = cvpartition(y, 'holdout', .5); % Half are randomly test, the other training.
xtrain = x(cv.training,:); % Create new set of training data, with data and
ytrain = y(cv.training,1); % matching numerical value.
xtest = x(cv.test,:); % Do the same with testing; xtest has the vector while
ytest = y(cv.test,:); % ytest has the corresponding digit it represents.
clearvars x; clearvars ylabel; clearvars y;

correct = 0; % Total number of correct guesses.
incorrect = [1 2 3 4 5 6 7 8 9 0; 0 0 0 0 0 0 0 0 0 0];
distances = ExhaustiveSearcher(xtrain); % Calculates distances between points;
% this is explained more in my paper.
for i = 1:5500
  numneighbors = 20; % Choose the number of nearest neighbors for knn.
  closest = knnsearch(distances,xtest(i,:),'k',numneighbors); % Get nearest neighbors.
  sums = [0 0 0 0 0 0 0 0 0 0]; % Voting array.
  for j = 1:numneighbors
    current = closest(j);
    digit = ytrain(current);
    if (digit == 0) % Add to the voting array. Here I add 1/j.
      sums(10) = sums(10) + (1/j);
    else sums(digit) = sums(digit) + (1/j);
    end
  end
  guess = -1;
  max = -1;
  for k = 1:10 % Find the array spot with the largest sum aka the mode of the array.
    if (sums(k) >= max)
      guess = k;
      max = sums(k);
    end
  end
  sums
  if (guess == 10)
      guess = 0;
  end
  if (guess == ytest(i)) % Check actual value; if guess is correct, increment value.
    correct = correct + 1;
  else % Otherwise, increment the incorrect array in the proper position.
    if (ytest(i) == 0) % If you guess 5 and the digit is a 4, increment the 4th array position.
      incorrect(2,10) = incorrect(2,10) + 1;
    else incorrect(2,ytest(i)) = incorrect(2,ytest(i)) + 1;
    end
  end
end

incorrect % This displays a row 1-9,0 and below each number is the number of incorrect guesses.
correct % This displays the number of correct guesses from a 5500 set.
percent = double(100*correct/5500) % This displays the percentage of correct guesses.



