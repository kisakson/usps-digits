% Kara Isakson
% MATH401 Homework 9 and 10

load('usps_all');
x = double(reshape(data,256,11000)'); % Resize matrix from 3D to 2D. 256 cols, 11000 rows.
ylabel = [1:9 0]; % Create basic vector 1,2,3,4,5,6,7,8,9,0.
y = reshape(repmat(ylabel,1100,1),11000,1); % Resize to align with reshapen data.
clearvars data

%%

% Part 1: select 300 vectors from the total. Sort them in two ways: all of
% one type then do the next time; one value from each set done 30 times to
% get all 300. Check sources for source on some matlab code snippets.

first = x(9901:9930,:); % First vector.
% Zero is a separate case since it comes after all other numbers.
for i = 1:9 % Add 30 of each type of number at a time.
  one = ((i-1)*1100) + 1; % Starting indices include: 1, 1101, 2201, ...
  two = one + 29; % Get 30 of each type of vector.
  first = [first ; x(one:two,:)]; % Add all of the vector chunks together.
end

second = []; % Second vector.
for i = 1:30
  second = [second ; x(i+9900,:)]; % Add a 0 vector.
  second = [second ; x(i,:)]; % Add a 1 vector.
  second = [second ; x(i+1100,:)]; % Add a 2 vector.
  second = [second ; x(i+2200,:)]; % Add a 3 vector.
  second = [second ; x(i+3300,:)]; % Add a 4 vector.
  second = [second ; x(i+4400,:)]; % Add a 5 vector.
  second = [second ; x(i+5500,:)]; % Add a 6 vector.
  second = [second ; x(i+6600,:)]; % Add a 7 vector.
  second = [second ; x(i+7700,:)]; % Add an 8 vector.
  second = [second ; x(i+8800,:)]; % Add a 9 vector.
end

%%

% Part 2: Create a Gram-Schmidt orthogonalization function for 300 vectors
% in dimension 256. Check sources at the end for info on Gram-Schmidt.
% Part 3: I use this code applied to the first and second matrices from
% part 1.

gram1 = zeros(300,256); % Applied to the first matrix.
for i = 1:256
  v = first(:,i);
  for j = 1:i-1
    sub = (gram1(:,j)' * first(:,i))/(gram1(:,j)' * gram1(:,j));
    v = v - (sub * gram1(:,j));
  end
  gram1(:,i) = v;
end

gram2 = zeros(300,256); % Applied to the second matrix.
for i = 1:256
  v = second(:,i);
  for j = 1:i-1
    sub = (gram2(:,j)' * second(:,i))/(gram2(:,j)' * gram2(:,j));
    v = v - (sub * gram2(:,j));
  end
  gram2(:,i) = v;
end

%%

% Visual output of the first matrix through Gram-Schmidt.

figure(1)
for i = 1:20
    subplot(4,5,i)
    imagesc(reshape(gram1(i,:),16,16),[10 35])
    axis off
end
colormap gray

%%

% Visual output of the first matrix without Gram-Schmidt orthogonalization
% (for comparison purposes).

figure(1)
for i = 1:20
    subplot(4,5,i)
    image(reshape(first(i,:),16,16))
    axis off
end
colormap gray

%%

% Visual output of the second matrix through Gram-Schmidt.

figure(1)
for i = 1:20
    subplot(4,5,i)
    imagesc(reshape(gram2(i,:),16,16),[10 35])
    axis off
end
colormap gray

%%

% Visual output of the second matrix without Gram-Schmidt orthogonalization
% (for comparison purposes).

figure(1)
for i = 1:20
    subplot(4,5,i)
    image(reshape(second(i,:),16,16))
    axis off
end
colormap gray

%%
