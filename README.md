# fiete_longchainformation
Model of sequence generation in neural networks based on STDP and hLTD.  

Based on Fiete, I. R., Senn, W., Wang, C. Z. H. & Hahnloser, R. H. R. Spike-Time-Dependent Plasticity and Heterosynaptic Competition Organize Networks to Produce Long Scale-Free Sequences of Neural Activity.  Neuron 65, 563–576 (2010).

Implemented in MATLAB.  Run with (for example):

```
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

```

See also `RunParamSweep.m`

There is also code that models sequence formation based on the same principles in a network of leaky-integrate-and-fire (LIF) neurons.  The numerical integration is run by [SimLIFNet.m](https://github.com/cgh2797/Integrate-and-fire-model).
