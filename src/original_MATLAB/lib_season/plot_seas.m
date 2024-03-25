function plot_seas(manual,title_in,nonHVAC,seas)
%UNTITLED Summary of this function goes here
    
    minday = 24*60;
    delta = 24/minday;
    t = (0:delta:(24-delta))';
    
    figure("Name",title_in + " Compare Data")

    for i = 1:4
    
        subplot(4,1,i)      
        hold on
        
        plot(t,manual.(seas(i)).weekday.total,'color','m',"LineWidth",2);
        plot(t,manual.(seas(i)).offday.total,'color','g',"LineWidth",2);
        legend("Weekday Total","Offday Total");
%         legend(strcat("Weekday Total - Accum Ener: ",sprintf("%2.2e",manual.(seas(i)).weekday.ener_total)),...
%             strcat('Offday Total - Accum Ener: ',sprintf("%2.2e",manual.(seas(i)).offday.ener_total)));
        
        if nonHVAC
            plot(t,manual.(seas(i)).weekday.nonHVAC,'color','k',"LineWidth",2);
            plot(t,manual.(seas(i)).offday.nonHVAC,'color','c',"LineWidth",2);
            legend("Weekday NonHVAC","Offday NonHVAC");
%             legend(strcat("Weekday NonHVAC, Accum Ener: ",sprintf("%2.2e",manual.(seas(i)).weekday.ener_nonHVAC)),...
%                 strcat('Offday NonHVAC, Accum Ener: ',sprintf("%2.2e",manual.(seas(i)).offday.ener_nonHVAC)))
        end
        
        hold off
        grid on
        title(title_in + ": " + seas(i) + " Daily Average");
        subtitle("Weekdays Num: " + sprintf("%d\t|",manual.(seas(i)).weekday.num) +...
            "Offdays Num: " + sprintf("%d",manual.(seas(i)).offday.num));
        ylabel("Power Consumed (kW)");
        ylim([0 5]);
        xlim([0 24]);
        xticks(0:4:24);
    
    end
    xlabel("Time (hrs)");
end