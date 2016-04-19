% Model: Kramer 2008, PLoS Comp Bio
% Single compartment version of Kramer model

% simulation controls
tspan=[0 500]; dt=.01; solver='euler'; % euler, rk2, rk4
dsfact=1; % downsample factor, applied after simulation

% number of cells per population
N=2;

% tonic input currents
Jd=23.5; % apical: 23.5(25.5), basal: 23.5(42.5)
Js=-10.5; % -4.5
Ja=-6;   % -6(-.4)

% Poisson IPSPs to IBdb (basal dendrite)
gRAN=125;

% some intrinsic currents
gAR_L=50;  % 50,  LTS - max conductance of h-channel
gAR_d=0; % 155, IBda - max conductance of h-channel

% connection strengths
gad=0;      % IBa -> IBdb, 0(.04)
gsd=.2;     % IBs -> IBda,IBdb
gds=.4;     % IBda,IBdb -> IBs
gas=.3;     % IBa -> IBs
gsa=.3;     % IBs -> IBa
ggja=.002;  % IBa -> IBa

% Compartmental parameters
gM_s = 1;         % Value from axon
gCaH_s = 2;


% constant biophysical parameters
Cm=.9;        % membrane capacitance
ENa=50;      % sodium reversal potential
E_EKDR=-95;  % potassium reversal potential for excitatory cells
IB_Eh=-25;   % h-current reversal potential for deep layer IB cells
ECa=125;     % calcium reversal potential
IC_noise=.01;% fractional noise in initial conditions

spec=[];
i = 0;
i = i + 1;
spec.nodes(i).label = 'IBs';
spec.nodes(i).multiplicity = N;
spec.nodes(i).dynamics = {'V''=(current)/Cm'};
%spec.nodes(i).mechanisms = {'IBs_itonic','IBs_noise','IBs_iNaF','IBs_iKDR','IBda_iAR','IBda_iM','IBda_iCaH','IBs_leak'};
spec.nodes(i).mechanisms = {'IBs_itonic','IBs_noise','IBs_iNaF','IBs_iKDR','IBda_iAR','IB_iM_Mich','IBda_iCaH','IBs_leak'};
spec.nodes(i).parameters = {...
  'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-70,'g_l',1,...
  'stim',Js,'onset',0,'V_noise',0,...
  'gNaF',100,'E_NaF',ENa,'NaF_V0',34.5,'NaF_V1',59.4,'NaF_d1',10.7,'NaF_V2',33.5,'NaF_d2',15,'NaF_c0',.15,'NaF_c1',1.15,...
  'gKDR',80,'E_KDR',E_EKDR,'KDR_V1',29.5,'KDR_d1',10,'KDR_V2',10,'KDR_d2',10,...
  'gAR',gAR_d,'E_AR',IB_Eh,'AR_V12',-87.5,'AR_k',-5.5,'c_ARaM',2.75,'c_ARbM',3,'AR_L',1,'AR_R',1,...
  'gM',gM_s,'E_M',E_EKDR,'c_MaM',1,'c_MbM',1,...
  'gCaH',gCaH_s,'E_CaH',ECa,'tauCaH',1,'c_CaHaM',1,'c_CaHbM',1,...
  };



% process specification and simulate model
data = runsim(spec,'timelimits',tspan,'dt',dt,'dsfact',dsfact,'solver',solver,'coder',0);
% plotv(data,spec,'varlabel','V');
% dnsim(spec);

%% Plot currents
for i = 1:1
    %varlabels = {'V','iKDR_mKDR','iCaH_mCaH','iM_mM','iAR_mAR'};
    varlabels = {'V','iCaH_mCaH','IB_iM_Mich_mM','iAR_mAR'};
    comp2plot=i;
    scale_ylim_flag = 0;
    [fig,lfps,T] = plot_currents(data,spec,varlabels,'comp2plot',comp2plot,'scale_ylim_flag',scale_ylim_flag);

end

% % Plot other currents
% plotv(data,spec,'varlabel','iKDR_mKDR');
% plotv(data,spec,'varlabel','iCaH_mCaH');
% plotv(data,spec,'varlabel','iM_mM');
% plotv(data,spec,'varlabel','iAR_mAR');
% plotv(data,spec,'varlabel','iSYN_sSYNpre');




