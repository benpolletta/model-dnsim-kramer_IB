function synapse_direction_error(cluster_flag, compile_flag)

if nargin < 2, compile_flag = []; end
if isempty(compile_flag), compile_flag = 0; end
if nargin < 1, cluster_flag = []; end
if isempty(cluster_flag), cluster_flag = 1; end

%% Defining sim_spec.

sim_spec = struct();

%% Populations.
i=1;
sim_spec.populations(i).name = 'RS';
sim_spec.populations(i).size = 5;
sim_spec.populations(i).equations = {['V''=@current/Cm; V(0)=' num2str(-65) '; monitor functions; monitor V.spikes(0);']};
sim_spec.populations(i).mechanism_list = {'itonicBen','IBiNaF','IBiKDR',... %'IBdbiPoissonExpJason','IBnoise','IBiMMich','IBiCaH','IBleaknoisy',...
    'iPeriodicSpikes', 'iPeriodicSpikes2Freqs',...
    };
sim_spec.populations(i).parameters = {...
    'V_IC',-65,'IC_noise',0.25,'Cm',0.9, 'E_l',-67,'E_l_std',0,'g_l',0.1,...
    'PPstim', 0, 'PPfreq', 4, 'PPwidth', 2, 'PPshift', 0, 'PPonset', 10,...
    'PPoffset', 3000, 'ap_pulse_num', 0, 'ap_pulse_delay', 0, 'pulse_train_preset', 0,...
    'kernel_type', 2, 'width2_rise', 0.75, 'PPFacTau', 200, 'PPFacFactor', 1,...
    'gRAN', 0.005, 'ERAN', 0, 'tauRAN', 2, 'lambda', 1000,...
    'stim', 0, 'onset', 0, 'offset', Inf, 'stim2', 0, 'onset2', 0, 'offset2', Inf,...
    'V_noise', 0.3, 'I_app', 0,...
    'gNaF', 100, 'E_NaF', 50,...
    'gKDR', 80, 'E_KDR', -95,...
    'gM', 0.5, 'E_M', -95,...
    'gCaH', 0, 'E_CaH', 125,...
    'gSpike', 0, 'Sfreq', 7, 'tau_d', 125, 'tau_r', 15, 'jitter', 0,...
    'gSpike2F', 0, 'Sfreq1', 7, 'Sfreq2', 7, 'tau_d2F', 125, 'tau_r2F', 15, 'S2Fjitter', 0,...
    };

i=i+1;
sim_spec.populations(i).name = 'FS';
sim_spec.populations(i).size = 1;
sim_spec.populations(i).equations = {['V''=(@current)/Cm; V(0)=' num2str(-65) '; monitor functions; monitor V.spikes(0);']};
sim_spec.populations(i).mechanism_list = {'iPeriodicPulsesFacilitate','IBitonic','IBnoise','FSiNaF','FSiKDR','IBleaknoisy',...
    'iPeriodicSpikes', 'iPeriodicSpikes2Freqs'};
sim_spec.populations(i).parameters = {...
    'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'E_l_std',FS_Eleak_std,'g_l',0.1,...
    'PPstim',FSPPstim,'PPfreq',PPfreq,'PPwidth',PPwidth,'PPshift',PPshift,'PPonset',PPonset,'PPoffset',PPoffset,'ap_pulse_num',ap_pulse_num,'ap_pulse_delay',ap_pulse_delay,'pulse_train_preset',pulse_train_preset,'kernel_type', kernel_type, 'width2_rise', width2_rise,'PPFacTau',PPFacTau,'PPFacFactor',PPFacFactor,...
    'stim',Jfs,'onset',0,'offset',Inf,...
    'V_noise',FS_Vnoise,...
    'gNaF',100,'E_NaF',ENa,...
    'gKDR',80,'E_KDR',E_EKDR,...
    'gM',FS_gM,'E_M',E_EKDR,...
    'gSpike', 0, 'Sfreq1', 7, 'tau_d', 125, 'tau_r', 15, 'jitter', 0,...
    'gSpike2F', 0, 'Sfreq1', 7, 'Sfreq2', 7, 'tau_d2F', 125, 'tau_r2F', 15, 'S2Fjitter', 0,...
    };
  
i=i+1;
spec.populations(i).name = 'LTS';
spec.populations(i).size = 1;
spec.populations(i).equations = {['V''=@current/Cm; V(0)=' num2str(IC_V) '; monitor functions; monitor V.spikes(0);']};
spec.populations(i).mechanism_list = {'IBitonic','IBnoise','FSiNaF','FSiKDR','IBiMMich','IBleaknoisy',...
    'iPeriodicSpikes', 'iPeriodicSpikes2Freqs'};
spec.populations(i).parameters = {...
    'V_IC',-65,'IC_noise',IC_noise,'Cm',Cm,'E_l',-67,'E_l_std',LTS_Eleak_std,'g_l',0.1,...
    'stim',Jlts,'onset',0,'offset',Inf,...
    'V_noise',LTS_Vnoise,...
    'gNaF',100,'E_NaF',ENa,...
    'gKDR',80,'E_KDR',E_EKDR,...
    'gM',1,'E_M',E_EKDR,...
    'gSpike', 0, 'Sfreq1', 7, 'tau_d', 25, 'tau_r', 5, 'jitter', 0,...
    'gSpike2F', 0, 'Sfreq1', 7, 'Sfreq2', 7, 'tau_d2F', 125, 'tau_r2F', 15, 'S2Fjitter', 0,...
    };

%% Synapses.
i=i+1;
sim_spec.connections(i).direction = 'RS->RS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
sim_spec.connections(i).parameters = {'g_SYN',gAMPA_rsrs,'E_SYN',EAMPA,...
    'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0, 'g_GAP',ggjaRS,...
    };

i=i+1;
sim_spec.connections(i).direction = 'RS->FS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
sim_spec.connections(i).parameters = {'g_SYN',gAMPA_rsfs,'E_SYN',EAMPA,...
    'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0, ...
    };

i=i+1;
sim_spec.connections(i).direction = 'RS->LTS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
sim_spec.connections(i).parameters = {'g_SYN',gAMPA_rsLTS,'E_SYN',EAMPA,...
    'tauDx',tauAMPAd,'tauRx',tauAMPAr,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0, ...
    };

i=i+1;
sim_spec.connections(i).direction = 'FS->FS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed','IBaIBaiGAP'};
sim_spec.connections(i).parameters = {'g_SYN',gGABAa_fsfs,'E_SYN',EGABA,...
    'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0,...
    'g_GAP',ggjFS,...
    };

i=i+1;
sim_spec.connections(i).direction = 'FS->RS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
sim_spec.connections(i).parameters = {'g_SYN',gGABAa_fsrs,'E_SYN',EGABA,...
    'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0,...
    };

i=i+1;
sim_spec.connections(i).direction = 'FS->LTS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
sim_spec.connections(i).parameters = {'g_SYN',gGABAa_fsLTS,'E_SYN',EGABA,...
    'tauDx',tauGABAad,'tauRx',tauGABAar,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0,...
    };

i=i+1;
sim_spec.connections(i).direction = 'LTS->LTS';
sim_spec.connections(i).mechanism_list = {'IBaIBaiGAP'};
sim_spec.connections(i).parameters = {
    'g_GAP',ggjLTS,...
    };

i=i+1;
sim_spec.connections(i).direction = 'LTS->RS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
sim_spec.connections(i).parameters = {'g_SYN',gGABAa_LTSrs,'E_SYN',EGABA,...
    'tauDx',tauGABAaLTSd,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0,...
    };

i=i+1;
sim_spec.connections(i).direction = 'LTS->FS';
sim_spec.connections(i).mechanism_list = {'IBaIBdbiSYNseed'};
sim_spec.connections(i).parameters = {'g_SYN',gGABAa_LTSfs,'E_SYN',EGABA,...
    'tauDx',tauGABAaLTSd,'tauRx',tauGABAaLTSr,'fanout',inf,'IC_noise',0,...
    'g_SYN_hetero',0,...
    };

%% Running simulation.

vary = {'deepRS', 'I_app', [-7 -10];
    'deepRS->RS', 'gNMDA', [0 5]};

Today = datestr(datenum(date),'yy-mm-dd');
Now = clock;
name = sprintf('synapse_direction_error_%s_%g_%g_%.4g', Today, Now(4), Now(5), Now(6));

dsSimulate(sim_spec, 'vary', vary, 'tspan', [0 3000], 'dt', .01, 'downsample_factor', 10, 'solver', 'rk4', 'coder', 0,...
    'random_seed', 2,'verbose_flag', 1, 'cluster_flag', cluster_flag, 'debug_flag', 1, 'compile_flag', compile_flag,...
    'overwrite_flag', 1, 'one_solve_file_flag', 1, 'qsub_mode', 'array',...
    'save_data_flag', 1, 'study_dir', name);
    
end