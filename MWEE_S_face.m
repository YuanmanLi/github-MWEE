%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Created by Li Yuanman
%%yuanmanx.li@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;clear;clc;
addpath Data clustering Functions
Occlusion='25'; %'0'

cur_size =  [96,84];%;
K = 2; %[2, 4, 6, 8, 10];
dataset = sprintf('EYaleB_cluster_crop%dx%d_%s_Occlusion', cur_size(1), cur_size(2), Occlusion);
sigma_size = 4;
sigma = (sqrt(cur_size(1)*cur_size(2)/400)*0.5).^1.1;

fprintf('occlusion = %s, image size =[%d, %d], K=%d\n', Occlusion, cur_size(1), cur_size(2), K);
load(dataset)
Ind=find(s<=K);
Y = X(:,Ind); s = s(:,Ind);
Y=NormalizeFea(Y,0);
[C, til_A] = generate_til_A(sigma, sigma_size, Y, cur_size);
%-------------------------------------------------------------------------
%perform classification
lambda=1e-4;
acc    =   MWEE_cluster_face(Y, lambda, 0, s,til_A, C);
fprintf('acc=%.3f\n', acc*100);
            
