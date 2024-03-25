function save_info_energy(manual,path,dates)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    filename = [strcat(path,"_weekday.csv");strcat(path,"_offday.csv")];
    
    
    weekday_temp = zeros(1440,16);
    offday_temp = zeros(1440,16);
    total_week_temp = zeros(1440,4);
    total_off_temp = zeros(1440,4);

    for i = 1:4
        for j = 1:length(dates.fiel)
            weekday_temp(:,i*4-(4 - j)) = manual.(dates.seas.name(i)).(dates.fiel(j))(:,1);
            offday_temp(:,i*4-(4 - j)) = manual.(dates.seas.name(i)).(dates.fiel(j))(:,2);

            total_week_temp(:,j) = total_week_temp(:,j) + weekday_temp(:,i*4-(4 - j));
            total_off_temp(:,j) = total_off_temp(:,j) + offday_temp(:,i*4-(4 - j));
        end
    end

    titles = ["Spring","","","","Summer","","","","Fall","","","",...
        "Winter","","","","Total","","","";...
        "Total","Non-HVAC","AC","Furnace","Total","Non-HVAC","AC","Furnace",...
        "Total","Non-HVAC","AC","Furnace","Total","Non-HVAC","AC","Furnace"...
        "Total","Non-HVAC","AC","Furnace"];


    writematrix(titles,filename(1),'WriteMode','overwrite');
    writematrix([weekday_temp,total_week_temp],filename(1),'WriteMode','append');
    writematrix(titles,filename(2),'WriteMode','overwrite');
    writematrix([offday_temp,total_off_temp],filename(2),'WriteMode','append');


end