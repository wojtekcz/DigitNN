% Load Training Data
fprintf('Loading Data ...\n')

load('ex3data1.mat');
m = size(X, 1);

fprintf('\nLoading Saved Neural Network Parameters ...\n')

% Load the weights into variables Theta1 and Theta2
load('ex3weights.mat');

save("-ascii", "X.txt", "X")
save("-ascii", "y.txt", "y")

save("-ascii", "Theta1.txt", "Theta1")
save("-ascii", "Theta2.txt", "Theta2")
