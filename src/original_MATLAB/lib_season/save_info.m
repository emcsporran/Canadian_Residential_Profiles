function save_info(manual,path,dates)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    filename = [strcat(path,"_weekday.csv");strcat(path,"_offday.csv")];

    weekday_temp = zeros(1440,8);
    offday_temp = zeros(1440,8);

    for i = 1:4
        weekday_temp(:,i*2-1) = manual.(dates.seas.name(i)).weekday.total;
        weekday_temp(:,i*2) = manual.(dates.seas.name(i)).weekday.nonHVAC;
        offday_temp(:,i*2-1) = manual.(dates.seas.name(i)).offday.total;
        offday_temp(:,i*2) = manual.(dates.seas.name(i)).offday.nonHVAC;

    end

    titles = ["Spring","","Summer","","Fall","","Winter","";...
        "Total","Non-HVAC","Total","Non-HVAC","Total","Non-HVAC","Total","Non-HVAC"];


    writematrix(titles,filename(1),'WriteMode','overwrite');
    writematrix(weekday_temp,filename(1),'WriteMode','append');
    writematrix(titles,filename(2),'WriteMode','overwrite');
    writematrix(offday_temp,filename(2),'WriteMode','append');


end