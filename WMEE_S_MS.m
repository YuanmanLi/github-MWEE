%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Created by Li Yuanman
%%yuanmanx.li@gmail.com
%%% most of the codes are borrowed from SSC (Ehsan Elhamifar, 2012)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc, clear all, close all 
dbstop if error
addpath clustering 

Dataset = 'Hopkins155';

alpha = 800;
maxNumGroup = 5;
num = zeros(1, maxNumGroup);

d = dir(Dataset);
d=d(~ismember({d.name},{'.','..'}) & [d.isdir]);
result_test = zeros(length(d), 2);

for i = 1:length(d)
    fprintf('cur_video=%d/%d\n', i,length(d));
    filepath = d(i).name;
    f = dir(fullfile(Dataset, filepath,'*_truth.mat')); 
    assert(length(f)>0)
    eval(['load ' fullfile(Dataset, filepath,f(1).name)]);
    
    n = max(s);   
    N = size(x,2);
    F = size(x,3);
    D = 2*F;                                                      
    X = reshape(permute(x(1:2,:,:),[1 3 2]),D,N);  
                                                                                                                                   
    if N > 300
        sigma_size = 6;   %set 10
        sigma = 10;
    else
         sigma_size = 6;
         sigma = 1;
    end

    %%%original dimension 
    rho = 0.7;           
    [~, til_A] = generate_til_A_MS(sigma, sigma_size, X,1);
    [missrate1,C1] = MWEE_SSC(X,alpha,rho,s, til_A);
    
    %%4n dimension
    r = 4*n; 
    Xp = DataProjection(X,r);   
    if N > 300                      %%the noise is very low after projection, 
        sigma_size = 2;
        sigma = 10;
    else
         sigma_size = 2;
         sigma = 0.5;
    end   
    [~, til_A] = generate_til_A_MS(sigma, sigma_size, Xp,2);
    [missrate2,C2] = MWEE_SSC(Xp,alpha,rho,s, til_A);
    fprintf('current missrate: missrate1=%.2f, missrate2=%.2f\n', missrate1, missrate2);
    num(n) = num(n) + 1;
    missrateTot1{n}(num(n)) = missrate1;
    missrateTot2{n}(num(n)) = missrate2;
    result_test(i,:) = [missrate1, missrate2];

end   

L = [2 3];
motion2_rate   =  [mean(missrateTot1{2}),median(missrateTot1{2}), std(missrateTot1{2}); ... 
                           mean(missrateTot1{3}), median(missrateTot1{3}), std(missrateTot1{3}); ...
                           mean([missrateTot1{2}, missrateTot1{3}]), median([missrateTot1{2}, missrateTot1{3}]), std([missrateTot1{2}, missrateTot1{3}])]*100;

motion3_rate   =  [mean(missrateTot2{2}),median(missrateTot2{2}), std(missrateTot2{2}); ... 
                           mean(missrateTot2{3}), median(missrateTot2{3}), std(missrateTot2{3}); ...
                           mean([missrateTot2{2}, missrateTot2{3}]), median([missrateTot2{2}, missrateTot2{3}]), std([missrateTot2{2}, missrateTot2{3}])]*100;

