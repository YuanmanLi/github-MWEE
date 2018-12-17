%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Created by Li Yuanman
%%yuanmanx.li@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear;clc;
addpath Data Functions
dataset = 'Yale';
cur_size = [48,48];
lambda=1e-4;
K= 15;
cur_corrup = 50; %10, 30, 50, 70
dataset_file = sprintf('%s_%dx%d_%d_Corruption%d.mat',dataset, cur_size(1), cur_size(2), cur_corrup, 1);
fprintf('corruption = %d, image size =[%d, %d]\n', cur_corrup, cur_size(1), cur_size(2));

 %%construct training and test set---Normalize data to have unit L2 norm-------------------
load(dataset_file)
Ind=find(trls<=K);tr_dat=tr_dat(:,Ind);trls=trls(Ind);
Ind=find(ttls<=K);tt_dat=tt_dat(:,Ind);ttls=ttls(Ind);
[sigma_size, sigma] =    adaptive_sigma(cur_size,tr_dat,tt_dat); 
tr_dat=NormalizeFea(tr_dat,0); tt_dat=NormalizeFea(tt_dat,0);

%%%generate til_A and C%%%%%%%%%%%%%%%%%%
fprintf('Generate C and til_A.......\n')
[C, til_A] = generate_til_A(sigma, sigma_size, tr_dat, cur_size);

%%%Recognition%%%%%%%%%%%%%%%%%%
fprintf('Recognizing......\n')
[n,m] = size(tr_dat);
N=size(tt_dat,2);ID = zeros(N,1);
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



