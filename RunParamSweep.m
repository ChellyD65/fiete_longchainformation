%% RunParamSweep.m
clear;  close all;

params.n = 50;           % number of neurons
params.frames = 200;     % time-frames in one "iteration". Each time-step is ~ 1 frame (e.g. SWR).

params.beta = .25;       % global inhibition strength
params.wmax = 1;         % single synapse weight hard upper bound
params.m = 1;            % Wmax = m*wmax
params.pn = 2;           % number of neurons likely to receive external stimulation of any neuron at any time (p_stim=pn/n);
params.eta = 0.125;      % learning rate parameter	
params.epsilon = 0.05;   % strength of heterosynaptic LTD
params.tau = 4;          % time-constant of neural adaptation (only used if alpha is not 0)
params.alpha = 0;        % strength of neural adaptation



% TRAIN -------------------------------------
[w, xrec_train] = TrainNetwork(params);


% PLAYBACK ----------------------------------
params_playback = params;
params_playback.pn = 1;
[xrec_play] = PlaybackNetwork(params_playback, w);

% Plots -----------------------------------
figure();
for iter = [1:80]
    x_iter = xrec_play{iter};
    [p, q] = find(x_iter);
    qq = zeros(params.n,1);
    for i = [1:params.n]
       qq(i) = min([size(x_iter,2);q(p==i)]); 
    end
    [~,B] = sort(qq);
    subplot(8,10,iter)
    imagesc(x_iter(B,:)); colormap(hot); 
end

figure();
subplot(1,2,1); 
imagesc(w,[0,params.wmax]); colormap(hot); colorbar
title('W'); xlabel('neuron index'); ylabel('neuron index');

subplot(1,2,2); 
imagesc(w'*w,[0,params.wmax^2]); colormap(hot); colorbar
title('W^T*W'); xlabel('neuron index'); ylabel('neuron index');
