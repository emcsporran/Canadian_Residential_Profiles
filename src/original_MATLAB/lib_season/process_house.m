function manual = process_house(manual,name,path,dates,save_id,id)
%UNTITLED Summary of this function goes here
    empt_chk = 0;
    rng_strt = 1;
    minday = 24*60;
    house.name = name;
    
    while ~empt_chk

        [data,empt_chk] = read_data(manual,path(1),rng_strt,minday);
        rng_strt = rng_strt + minday;
        house = sort_day(house,data,dates);
        manual = sort_day(manual,data,dates);

        [seas,seas_id] = chk_seas(dates,data.time);
        manual.dail(:,1) = [manual.dail(:,1); sum(data.total)*(1/60)];
        manual.dail(:,2) = [manual.dail(:,2); sum(data.total)*(1/60)];
        manual.energy(id,4*seas_id-3) = manual.energy(id,4*seas_id-3) + sum(data.total)*(1/60);
        manual.energy(id,4*seas_id-2) = manual.energy(id,4*seas_id-2) + sum(data.nonHVAC)*(1/60);
        manual.energy(id,4*seas_id-1) = manual.energy(id,4*seas_id-1) + sum(data.ac)*(1/60);
        manual.energy(id,4*seas_id) = manual.energy(id,4*seas_id) + sum(data.furnace)*(1/60);
        manual.ener_tot(id) = manual.ener_tot(id) + sum(data.total)*(1/60);
        manual.ener_non(id) = manual.ener_non(id) + sum(data.nonHVAC)*(1/60);
        manual.ener_ac(id) = manual.ener_ac(id) + sum(data.ac)*(1/60);
        manual.ener_fur(id) = manual.ener_fur(id) + sum(data.furnace)*(1/60);

    end

    if save_id
        save_info(house,path(2),dates);
    end
    
end


function manual = sort_day(manual,data,dates)

    [temp,temp_id] = chk_seas(dates,data.time);
    if isweekend(data.time) || chk_holiday(dates,data.time)
        if isfield(manual,(char(temp)))
            if isfield(manual.(char(temp)),'offday')
                manual.(char(temp)).offday.num = manual.(char(temp)).offday.num + 1;
                manual.(char(temp)).offday.total = (manual.(char(temp)).offday.total + data.total)/2;
                manual.(char(temp)).offday.nonHVAC = (manual.(char(temp)).offday.nonHVAC + data.nonHVAC)/2;
                manual.(char(temp)).offday.ac = (manual.(char(temp)).offday.ac + data.ac)/2;
                manual.(char(temp)).offday.furnace = (manual.(char(temp)).offday.furnace + data.furnace)/2;
            else
                manual.(char(temp)).offday.num = 1;
                manual.(char(temp)).offday.total = data.total;
                manual.(char(temp)).offday.nonHVAC = data.nonHVAC;
                manual.(char(temp)).offday.ac = data.ac;
                manual.(char(temp)).offday.furnace = data.furnace;
            end
        else
            manual.(char(temp)).offday.num = 1;
            manual.(char(temp)).offday.total = data.total;
            manual.(char(temp)).offday.nonHVAC = data.nonHVAC;
            manual.(char(temp)).offday.ac = data.ac;
            manual.(char(temp)).offday.furnace = data.furnace;
        end
    else
        if isfield(manual,(char(temp))) 
            if isfield(manual.(char(temp)),'weekday')
                manual.(char(temp)).weekday.num = manual.(char(temp)).weekday.num + 1;
                manual.(char(temp)).weekday.total = (manual.(char(temp)).weekday.total + data.total)/2;
                manual.(char(temp)).weekday.nonHVAC = (manual.(char(temp)).weekday.nonHVAC + data.nonHVAC)/2;
                manual.(char(temp)).weekday.ac = (manual.(char(temp)).weekday.ac + data.ac)/2;
                manual.(char(temp)).weekday.furnace = (manual.(char(temp)).weekday.furnace + data.furnace)/2;
            else
                manual.(char(temp)).weekday.num = 1; 
                manual.(char(temp)).weekday.total = data.total;
                manual.(char(temp)).weekday.nonHVAC = data.nonHVAC;
                manual.(char(temp)).weekday.ac = data.ac;
                manual.(char(temp)).weekday.furnace = data.furnace;
            end
        else
            manual.(char(temp)).weekday.num = 1;
            manual.(char(temp)).weekday.total = data.total;
            manual.(char(temp)).weekday.nonHVAC = data.nonHVAC;
            manual.(char(temp)).weekday.ac = data.ac;
            manual.(char(temp)).weekday.furnace = data.furnace;
        end
    end

end


function [data,empt_chk] = read_data(manual,path,rng_strt,minday)

    rang = strcat("A",num2str(rng_strt+1),":I",num2str((rng_strt + minday)));
    temp = readmatrix(path,'Range',rang);
    data.time = datetime(temp(1,1),temp(1,2),temp(1,3),temp(1,4),temp(1,5),0);
    data.nonHVAC = temp(:,6);
    data.total = temp(:,7);
    data.ac = temp(:,8);
    data.furnace = temp(:,9);

    rang = strcat("A",num2str((rng_strt + minday)+2),":G",num2str((rng_strt + 2*minday)+1));
    temp = readmatrix(path,'Range',rang);
    if isempty(temp)
        empt_chk = 1;
    else
        empt_chk = 0;
    end

end


function isholi = chk_holiday(dates,day)

    isholi = 0;
    for i = 1:length(dates.holi.day)
        if day == dates.holi.day(i)
            isholi = 1;
        end
    end

end


function [seas,id] = chk_seas(dates,time)
    
    seas_id = find(time > dates.seas.day,1,'last');
    seas = dates.seas.name(seas_id);
    temp = ["Spring";"Summer";"Fall";"Winter"];
    id = find(seas==temp(:),1);
%     fprintf("Date: %s\tSeason: %s\n",data.time,seas);

end

