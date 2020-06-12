% clear; close all;
% load('../mmd_STDP_hLTD/dg_demo1_sequences.mat','w')

ini = 1.1*rand(size(w,1),1);
[spkFull NetParams V] = SimLIFNet(w,'simTime',35,'tstep',1e-2,...
                                    'offsetCurrents', 0.75*ones(size(w,1),1), ...
                                    'noiseAmplitude', 0.1*ones(size(w,1),1), ...
                                    'initialConditions', ini);
                                
                                
ini = 1.1*rand(size(w,1),1);
[spkFull NetParams V] = SimLIFNet(w,'simTime',200,'tstep',1e-2,...
                                    'offsetCurrents', 0.6*ones(size(w,1),1), ...
                                    'noiseAmplitude', 0.2*ones(size(w,1),1), ...
                                    'initialConditions', ini);