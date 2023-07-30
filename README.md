###matlab

#Step 1, run csi_gesture.m for 3σ removal, wavelet noise reduction, and feature extraction
#Step 2, run data_pocess.m, perform normalization
#Step 3, call New_fisher.m, perform fisher algorithm by new_FS2, choose score greater than 0.12, use improved New_fisher algorithm
#Step 4, run PCA.m, perform PCA, choose 95%
#Step 5, run SVM_Stacking.m, divide the samples into training set and test set, where 70% is training set and 30% is test set, and the training set is divided into secondary training set and secondary test set, where 70% is secondary training set and 30% is secondary test set, the secondary training set is used to train the primary model, and the secondary test set is used for the primary model prediction
#The prediction vectors are averaged and used as the training set for the secondary model to get the overall training model. The test set is first put into the primary training model to get two prediction vectors and averaged, and then put into the secondary model to get the final result.

###dataset
#The dataset contains 5 testers, 6 different gestures in one experimental environment, 100 instances of each gestures
user-a-b.dat
#a denotes the type of gesture
#b denotes the number of instances
