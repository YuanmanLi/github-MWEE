%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Created by Li Yuanman
%%yuanmanx.li@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;clear;clc;
addpath Data Functions
Method = 'Proposed';

Occlusion = '40'; %{'50', '40', '30', '20'};
im_shape = [96,84]; % {[24,21],[32,28], [48,42], [64,56], [96,84]};
fea_dim = im_shape(1)*im_shape(2);
sigma_size = 4;
sigma = (sqrt(fea_dim/400)*0.5).^1.1;
lambda=1e-4;

K = 30;  %10, 20, 30, 38 the number of classes
fprintf('Occlusion=%s, K=%d, im_shape=[%d, %d]\n', Occlusion, K, im_shape(1), im_shape(2))
%%construct training and test set---Normalize data to have unit L2 norm-------------------
data_file = sprintf('EYaleB_crop%dx%d_%s_Occlusion', im_shape(1),im_shape(2),Occlusion);
load(data_file)
Ind=find(trls<=K);tr_dat=tr_dat(:,Ind);trls=trls(:,Ind);
Ind=find(ttls<=K);tt_dat=tt_dat(:,Ind);ttls=ttls(:,Ind);
%[sigma_size, sigma] =  adaptive_sigma(im_shape,tr_dat,tt_dat); 
tr_dat=NormalizeFea(tr_dat,0);tt_dat=NormalizeFea(tt_dat,0);

%%%generate til_A and C%%%%%%%%%%%%%%%%%%
fprintf('Generate C and til_A.......\n')
[C, til_A] = generate_til_A(sigma, sigma_size, tr_dat, im_shape);

%%%Recognition%%%%%%%%%%%%%%%%%%
fprintf('Recognizing......\n')
[n,m] = size(tr_dat);
N=size(tt_dat,2);ID = zeros(1,N);
for indTest = 1:N
    if mod(indTest,100) == 0
        fprintf('%d/%d,  ', indTest,N)
    end
    til_y   =   sum(repmat(tt_dat(:,indTest),1,n).*C,1);
    [id]    =   MWEEC(tr_dat,tt_dat(:,indTest),trls,lambda,til_A,til_y');
    ID(indTest)      =   id;
end
cornum    =   sum(ID==ttls);
Rec         =   cornum/length(ttls)*100; 
fprintf('\nRecogniton rate is %.3f\n', Rec);
