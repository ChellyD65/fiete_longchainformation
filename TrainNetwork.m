% TrainNetwork.m
% Marcello DiStasio
% March, 2020
%
% Based on:
%
% https://github.com/CarolineHaimerl27/duration_distance_coding
%
% Fiete, I. R., Senn, W., Wang, C. Z. H. & Hahnloser, R. H. R. 
% Spike-Time-Dependent Plasticity and Heterosynaptic Competition Organize Networks to Produce Long Scale-Free Sequences of Neural Activity. 
% Neuron 65, 563–576 (2010).

function [w, xrec] = TrainNetwork(params)

    n=params.n;                  % number of neurons
    ts=params.tmax/params.dt;    % number of time steps to simulate
    
    niter = params.niter;

    beta = params.beta;      % global inhibition strength
    wmax=params.wmax;        % single synapse hard upper bound
    m=params.m;              % Wmax = m*wmax
    pn=params.pn; p=pn/n;    % probability of external stimulation of any neuron at any time
    eta=params.eta;          % learning rate parameter	
    epsilon=params.epsilon;	 % strength of heterosynaptic LTD
    tau=params.tau;          % time-constant of neural adaptation (only used if alpha is not 0)
    alpha=params.alpha;      % strength of neural adaptation

    w=zeros(n); 
    dw=zeros(n); 
    dw2=zeros(n); 
    dw3=zeros(n); 
    x = zeros(n,1); % neuron activity (binary active / inactive)
    y = zeros(n,1); % LPF'd neuron activities
    xdyn=zeros(n,ts); % record of neuron activities
    s=zeros(1,ts); 

    oldx=x;
    oldy=y;


    xrec = cell(niter,1);
    for iter=1:niter

        oldw=w;

        for i = 1:ts

            % Random external stimulation
            b = rand(n,1)>=(1-p);
            binh = rand(n,1)>=(1-p);

            % Update Population activity [Binary Neuron Dyamics - Eqn (1) in paper]
            %---------------------------------------------------
            y = oldy + 1/tau*(-oldy+(oldx)+binh); % y is the low-pass filtered version of x, used for (decrementing) adaptation
            x = (w*oldx-beta*sum(oldx)+b-alpha*y)>0; % x is population activity
            %---------------------------------------------------

            % Learning rules - Eqns (4,5) in paper
            %---------------------------------------------------
            dw = eta*(x*double(oldx)'-double(oldx)*x'); % STDP update rule 
            dw2 = ones(n,1)*max(0, sum(w+dw,1)-m*wmax); % dw2 = theta_i* (outgoing synapses from i) in eq. 5 (competitive hLTD - soft bound; if threshold m*wmax is crossed, then all weights are decreased)
            dw3 = max(0, sum(w+dw,2)-m*wmax)*ones(1,n); % dw3 = theta_*i (incoming synapses to i) in eq. 5 (competitive hLTD)

            w=min(wmax,max(0,w+dw-eta*epsilon*(dw2+dw3)-eye(n)*10000*wmax)); %Total weight update
            %---------------------------------------------------

            % updates
            oldx = x;
            oldy= y;  
            xdyn(:,i)=x;
            xrec{iter} = xdyn;
            
        end
        if mod(iter, 100) == 0
            fprintf("Training network iteration %d of %d\n", iter, niter);
        end
    end
    %save(strcat('Trained_network_',datestr(now,'dd-mmm-yyyy_HH-MM-SS'),'.mat'));
end



