% Load Training Data
fprintf('Loading Data ...\n')

load('ex3data1.mat');
m = size(X, 1);

fprintf('Loading Saved Neural Network Parameters ...\n')

% Load the weights into variables Theta1 and Theta2
load('ex3weights.mat');

fprintf('Exporting data and NN parameters as JSON files ...\n')

addpath('./lib/jsonlab');
savejson('X', X, "X.json");
savejson('y', y, "y.json");

savejson('Theta1', Theta1, "Theta1.json");
savejson('Theta2', Theta2, "Theta2.json");
