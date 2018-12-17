%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Created by Li Yuanman
%%yuanmanx.li@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;clc;
addpath Data Functions

%-------------------------------------------------------------------------
%load data 
load EYaleB_crop96x84_40_Occlusion


indTest = 1; %index of the test image
%-------------------------------------------------------------------------
%Normalize data to have unit Euclidean norm
tr_dat=NormalizeFea(tr_dat,0);  tt_dat=NormalizeFea(tt_dat,0);
[n,m] = size(tr_dat);
%-------------------------------------------------------------------------
sigma_size = 4;
cur_size = [96, 84];
dim_len = cur_size(1)*cur_size(2);
assert(size(tr_dat,1)==dim_len);
sigma = (sqrt(dim_len/400)*0.5).^1.1;

%%%generate til_A and C%%%%%%%%%%%%%%%%%%
fprintf('Generate C and til_A.......\n')
til_A_name = sprintf('til_A_C_%d_%d.mat', cur_size(1), cur_size(2));
if exist(til_A_name, 'file') == 2
    load(til_A_name)
else 
    [C, til_A] = generate_til_A(sigma, sigma_size, tr_dat, cur_size);
    save  'til_A_C_96_84.mat' C til_A
end

%-------------------------------------------------------------------------
%parameter setting
lambda=1e-4;
%Perform reconstruction
test_im = tt_dat(:,indTest);
tic;
til_y   =   sum(repmat(test_im,1,n).*C,1);
[id,coef]    = MWEEC(tr_dat,test_im,trls,lambda,til_A,til_y');
toc;
Recon=tr_dat*coef;
 
%-------------------------------------------------------------------------
%Show results
Orig=reshape(tt_dat(:,indTest),cur_size);
Recon=reshape(Recon,cur_size);
Error=Orig-Recon;
Orig=rescale(Orig);Recon=rescale(Recon);Error=rescale(Error);
 
close all
figure;
Space = 0.01;
set(gcf,'Position',[300,100,96*8,96*5]);
subaxis(1,3,1, 'Spacing', Space, 'Padding', 0, 'Margin',  0.05);
imshow(uint8(Orig), 'border', 'tight');
subaxis(1,3,2, 'Spacing', Space, 'Padding', 0, 'Margin',  0.05);
imshow(uint8(Recon), 'border', 'tight');
subaxis(1,3,3, 'Spacing', Space, 'Padding', 0, 'Margin',  0.05);
imshow(uint8(Error), 'border', 'tight');


