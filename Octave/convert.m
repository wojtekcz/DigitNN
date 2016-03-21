% Load Training Data
fprintf('Loading Data ...\n')

load('ex3data1.mat');
m = size(X, 1);

fprintf('\nLoading Saved Neural Network Parameters ...\n')

% Load the weights into variables Theta1 and Theta2
load('ex3weights.mat');

save("-ascii", "X", "X")
save("-ascii", "y", "y")

save("-ascii", "Theta1", "Theta1")
save("-ascii", "Theta2", "Theta2")
