function [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% --------------------------------------------------------------------
% This code is based on the paper entitled                     
% "An Energy-based Method for Orientation Correction
% of EMG Bracelet Sensors in Hand Gesture Recognition Systems"
% by Victor Hugo Vimos T.
%
% *Victor Hugo Vimos T / victor.vimos@epn.edu.ec
% --------------------------------------------------------------------


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'WMoos_F1_Ms1', 'WMoos_F1_Ms2', 'WMoos_F1_Ms3', 'WMoos_F1_Ms4', 'WMoos_F1_Ms5', 'WMoos_F1_Ms6', 'WMoos_F1_Ms7', 'WMoos_F1_Ms8', 'WMoos_F2_Ms1', 'WMoos_F2_Ms2', 'WMoos_F2_Ms3', 'WMoos_F2_Ms4', 'WMoos_F2_Ms5', 'WMoos_F2_Ms6', 'WMoos_F2_Ms7', 'WMoos_F2_Ms8', 'WMoos_F3_Ms1', 'WMoos_F3_Ms2', 'WMoos_F3_Ms3', 'WMoos_F3_Ms4', 'WMoos_F3_Ms5', 'WMoos_F3_Ms6', 'WMoos_F3_Ms7', 'WMoos_F3_Ms8', 'WMoos_F4_Ms1', 'WMoos_F4_Ms2', 'WMoos_F4_Ms3', 'WMoos_F4_Ms4', 'WMoos_F4_Ms5', 'WMoos_F4_Ms6', 'WMoos_F4_Ms7', 'WMoos_F4_Ms8', 'WMoos_F5_Ms1', 'WMoos_F5_Ms2', 'WMoos_F5_Ms3', 'WMoos_F5_Ms4', 'WMoos_F5_Ms5', 'WMoos_F5_Ms6', 'WMoos_F5_Ms7', 'WMoos_F5_Ms8'};
predictors = inputTable(:, predictorNames);
response = inputTable.activity;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 3, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    predictors, ...
    response, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', categorical({'waveOut'; 'waveIn'; 'fist'; 'open'; 'pinch'; 'noGesture'}, {'waveOut' 'waveIn' 'fist' 'open' 'pinch' 'noGesture'}));

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(classificationSVM, x);
trainedClassifier.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedClassifier.RequiredVariables = {'WMoos_F1_Ms1', 'WMoos_F1_Ms2', 'WMoos_F1_Ms3', 'WMoos_F1_Ms4', 'WMoos_F1_Ms5', 'WMoos_F1_Ms6', 'WMoos_F1_Ms7', 'WMoos_F1_Ms8', 'WMoos_F2_Ms1', 'WMoos_F2_Ms2', 'WMoos_F2_Ms3', 'WMoos_F2_Ms4', 'WMoos_F2_Ms5', 'WMoos_F2_Ms6', 'WMoos_F2_Ms7', 'WMoos_F2_Ms8', 'WMoos_F3_Ms1', 'WMoos_F3_Ms2', 'WMoos_F3_Ms3', 'WMoos_F3_Ms4', 'WMoos_F3_Ms5', 'WMoos_F3_Ms6', 'WMoos_F3_Ms7', 'WMoos_F3_Ms8', 'WMoos_F4_Ms1', 'WMoos_F4_Ms2', 'WMoos_F4_Ms3', 'WMoos_F4_Ms4', 'WMoos_F4_Ms5', 'WMoos_F4_Ms6', 'WMoos_F4_Ms7', 'WMoos_F4_Ms8', 'WMoos_F5_Ms1', 'WMoos_F5_Ms2', 'WMoos_F5_Ms3', 'WMoos_F5_Ms4', 'WMoos_F5_Ms5', 'WMoos_F5_Ms6', 'WMoos_F5_Ms7', 'WMoos_F5_Ms8'};
trainedClassifier.ClassificationSVM = classificationSVM;
trainedClassifier.About = 'This struct is a trained model using Matlab R2019a.';
trainedClassifier.Author = sprintf('Victor Hugo Vimos T / victor.vimos@epn.edu.ec');

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'WMoos_F1_Ms1', 'WMoos_F1_Ms2', 'WMoos_F1_Ms3', 'WMoos_F1_Ms4', 'WMoos_F1_Ms5', 'WMoos_F1_Ms6', 'WMoos_F1_Ms7', 'WMoos_F1_Ms8', 'WMoos_F2_Ms1', 'WMoos_F2_Ms2', 'WMoos_F2_Ms3', 'WMoos_F2_Ms4', 'WMoos_F2_Ms5', 'WMoos_F2_Ms6', 'WMoos_F2_Ms7', 'WMoos_F2_Ms8', 'WMoos_F3_Ms1', 'WMoos_F3_Ms2', 'WMoos_F3_Ms3', 'WMoos_F3_Ms4', 'WMoos_F3_Ms5', 'WMoos_F3_Ms6', 'WMoos_F3_Ms7', 'WMoos_F3_Ms8', 'WMoos_F4_Ms1', 'WMoos_F4_Ms2', 'WMoos_F4_Ms3', 'WMoos_F4_Ms4', 'WMoos_F4_Ms5', 'WMoos_F4_Ms6', 'WMoos_F4_Ms7', 'WMoos_F4_Ms8', 'WMoos_F5_Ms1', 'WMoos_F5_Ms2', 'WMoos_F5_Ms3', 'WMoos_F5_Ms4', 'WMoos_F5_Ms5', 'WMoos_F5_Ms6', 'WMoos_F5_Ms7', 'WMoos_F5_Ms8'};
predictors = inputTable(:, predictorNames);
response = inputTable.activity;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Set up holdout validation
cvp = cvpartition(response, 'Holdout', 0.15);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :);
trainingIsCategoricalPredictor = isCategoricalPredictor;

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
template = templateSVM(...
    'KernelFunction', 'polynomial', ...
    'PolynomialOrder', 3, ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true);
classificationSVM = fitcecoc(...
    trainingPredictors, ...
    trainingResponse, ...
    'Learners', template, ...
    'Coding', 'onevsone', ...
    'ClassNames', categorical({'waveOut'; 'waveIn'; 'fist'; 'open'; 'pinch'; 'noGesture'}, {'waveOut' 'waveIn' 'fist' 'open' 'pinch' 'noGesture'}));

% Create the result struct with predict function
svmPredictFcn = @(x) predict(classificationSVM, x);
validationPredictFcn = @(x) svmPredictFcn(x);

% Compute validation predictions
validationPredictors = predictors(cvp.test, :);
validationResponse = response(cvp.test, :);
[validationPredictions, validationScores] = validationPredictFcn(validationPredictors);

% Compute validation accuracy
correctPredictions = (validationPredictions == validationResponse);
isMissing = ismissing(validationResponse);
correctPredictions = correctPredictions(~isMissing);
validationAccuracy = sum(correctPredictions)/length(correctPredictions);
