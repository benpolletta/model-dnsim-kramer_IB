

function plot_AP_timing1_RSFS(data)

    ind = data.time > 1000 & data.time < 1800;
    plot(data.time(ind),data.RS_iPeriodicPulses_Iext(ind,:),'r')
    hold on; plot(data.time(ind),data.RS_FS_IBaIBdbiSYNseed_s(ind,:)*10)
    %xlim([1440,1560])

end