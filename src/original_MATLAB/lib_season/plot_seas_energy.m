function plot_seas_energy(manual,title_in,fiel,seas)
%UNTITLED Summary of this function goes here
    
    minday = 24*60;
    delta = 24/minday;
    t = (0:delta:(24-delta))';
    
    cmap = colormap("turbo");
    dim = size(cmap);
    leng = dim(1)/length(fiel);
    figure("Name",title_in + " Compare Data")

    for i = 1:4
    

        subplot(4,2,2*i-1)      
        hold on
        for j = 1:length(fiel)
            plot(t,manual.(seas(i)).(fiel(j))(:,1),"LineWidth",2,"Color",cmap(leng*j,:));
        end
%         legend(fiel(:));
        hold off
        title(title_in + ": " + seas(i) + " Daily Average");
        subtitle("Averaged Number of Weekdays: " + sprintf("%d\t",sum(manual.(seas(i)).num(:,2))));
        grid on
        ylabel("Power Consumed (kW)");
        ylim([0 4]);
        xlim([0 24]);
        xticks(0:4:24);
        if i == 4
            xlabel("Time (hrs)");
            legend(fiel(:)');
            legend('Location','northeast','Orientation','horizontal','Box','on');
        end


        subplot(4,2,2*i)      
        hold on
        for j = 1:length(fiel)
            plot(t,manual.(seas(i)).(fiel(j))(:,2),"LineWidth",2,"Color",cmap(leng*j,:));
        end
        hold off
        title(title_in + ": " + seas(i) + " Daily Average");
        subtitle("Averaged Number of Offdays: " + sprintf("%d",sum(manual.(seas(i)).num(:,2))));
        grid on
        ylabel("Power Consumed (kW)");
        ylim([0 4]);
        xlim([0 24]);
        xticks(0:4:24);
        if i == 4
            xlabel("Time (hrs)");
            legend(fiel(:)');
            legend('Location','northeast','Orientation','horizontal','Box','on');
        end
    
    end

end