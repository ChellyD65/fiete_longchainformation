%% Playback of learned activity sequences: 
% -----------------------------------------------------

function [xrec, brec] = PlaybackNetwork(params, w)

    n = params.n;
    ts=params.tmax/params.dt;    % number of time steps to simulate
    
    pn=params.pn; p=pn/n;    % probability of external stimulation of any neuron at any time
    b = rand(n,1)>=(1-p);
    beta = params.beta;      % global inhibition strength
    eta=params.eta;          % learning rate parameter	
    epsilon=params.epsilon;	 % strength of heterosynaptic LTD
    tau=params.tau;          % time-constant of neural adaptation (only used if alpha is not 0)
    alpha=params.alpha;      % strength of neural adaptation

    oldx = zeros(n,1); % neuron activity (binary active / inactive)
    oldy = zeros(n,1); % LPF'd neuron activities
    
    
    % External inputs
    if isfield(params,'B')
        B = params.B;
    else
        if isfield(params,'pp')
            pp = params.pp; % probability of any activity per given time step
        else
            pp = 0.1;
        end

    end    
    
    if isfield(params,'niter')
        niter = params.niter;
    else
        niter = 1;
    end
    
    for iter=1:niter
        if mod(iter, 20) == 0
            fprintf("Playback iteration %d of %d\n", iter, niter);
        end

    	oldw=w;

        B = repmat((rand(1,ts) <= pp),n,1) .* rand(n,ts)>=(1-p); 
        
        for i = 1:ts

            b = B(:,i);            
            
            binh = rand(n,1)>=(1-p);
            y=oldy+1/tau*(-oldy+(oldx)+binh);

            x = (w*oldx-beta*sum(oldx)+b-alpha*y)>0;

            oldx = x;
            oldy= y;  
            xdyn(:,i)=x;
            bdyn(:,i)=b;

        end
        xrec{iter} = xdyn;
        brec{iter} = bdyn;
    end
    % save(strcat('Trained_network_playback',datestr(now,'dd-mmm-yyyy_HH-MM-SS'),'.mat'));

end