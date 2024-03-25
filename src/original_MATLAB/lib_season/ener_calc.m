function [manual,mat_out] = ener_calc(manual,seas)
%UNTITLED Summary of this function goes here


        time = 60;
        [manual,mat_out] = totl_ener(manual,seas,time);
%         manual = hour_ener(manual,seas);



end


function [manual,mat_out] = totl_ener(manual,seas,time)
    mat_out = zeros(1,4*2);
    for i = 1:4

        manual.(seas(i)).weekday.ener_nonHVAC = sum(manual.(seas(i)).weekday.nonHVAC*time);
        manual.(seas(i)).weekday.ener_total = sum(manual.(seas(i)).weekday.total*time);
        manual.(seas(i)).offday.ener_nonHVAC = sum(manual.(seas(i)).offday.nonHVAC*time);
        manual.(seas(i)).offday.ener_total = sum(manual.(seas(i)).offday.total*time);
        mat_out(2*i-1) = manual.(seas(i)).weekday.ener_total;
        mat_out(2*i) = manual.(seas(i)).offday.ener_total;
    end

end


function manual = hour_ener(manual,seas)

    dim = length(manual.(seas(1)).weekday.nonHVAC); % Should be 1440mins (24hrsx60mins)
    points = 60;
    hour = 3600; % 1 hour is 3600s
    

    for i = 1:4

        for j = 1:dim/points
            id_s = j*points - points + 1;
            id_e = j*points;

            manual.(seas(i)).weekday.ener_hr_nonHVAC(j,1) = sum(manual.(seas(i)).weekday.nonHVAC(id_s:id_e))*hour;
            manual.(seas(i)).weekday.ener_hr_total(j,1) = sum(manual.(seas(i)).weekday.total(id_s:id_e))*hour;
            manual.(seas(i)).offday.ener_hr_nonHVAC(j,1) = sum(manual.(seas(i)).offday.nonHVAC(id_s:id_e))*hour;
            manual.(seas(i)).offday.ener_hr_total(j,1) = sum(manual.(seas(i)).offday.total(id_s:id_e))*hour;

        end

    end

end