function [house,energy,ener_annual] = process_house_energy(name,path,dates,save_id)
%UNTITLED Summary of this function goes here
    empt_chk = 0;
    rng_strt = 1;
    minday = 24*60;
    seas = ["Spring";"Summer";"Fall";"Winter"];
    fiel = ["total";"nonHVAC";"ac";"furnace"];
    house = setupman(seas,fiel);
    house.name = name;
    ener_annual = zeros(1,4);
    energy = zeros(1,16);
    days = 365;
    count = 0;
    delt = floor(days/10);
    arr = delt:delt:delt*10;
    data.path = path;

    % My original thought was to edit the H8 file but my method wont work
    % as is.
%     if contains(data.path(1),"H8") && ~isfile(strcat(data.path(1),"_adjust.csv"))
%         data.pathDHW = strcat(erase(data.path,"H8"),"H10_DHW.csv");
%         data.path = [strcat(data.path(1),"_adjust.csv");strcat(data.path(2),"_adjust.csv")];
%         add_DHW(path,data.pathDHW,data.path,dates);
%     end
    
    
    while ~empt_chk

        [data,empt_chk] = read_data(path(1),data,rng_strt,minday,dates);
        rng_strt = rng_strt + minday;
        house = sort_day(house,data,dates);

        [seas,seas_id] = chkseas(dates,data.day);
        energy(1,4*seas_id-3) = energy(1,4*seas_id-3) + sum(data.total)*(1/60);
        energy(1,4*seas_id-2) = energy(1,4*seas_id-2) + sum(data.nonHVAC)*(1/60);
        energy(1,4*seas_id-1) = energy(1,4*seas_id-1) + sum(data.ac)*(1/60);
        energy(1,4*seas_id) = energy(1,4*seas_id) + sum(data.furnace)*(1/60);


        ener_annual(1,1) = ener_annual(1,1) + sum(data.total)*(1/60);
        ener_annual(1,2) = ener_annual(1,2) + sum(data.nonHVAC)*(1/60);
        ener_annual(1,3) = ener_annual(1,3) + sum(data.ac)*(1/60);
        ener_annual(1,4) = ener_annual(1,4) + sum(data.furnace)*(1/60);
        count = count + 1;

        if ~isempty(arr)
            arr = printprogress(count,arr);
        end

    end
    fprintf("|\nProcessing: Complete\n");

    if save_id
        save_info_energy(house,data.path(2),dates);
        fprintf("Saving: Complete\n");
    end
    
end


function manual_temp = sort_day(manual_temp,data,dates)

    seas = ["Spring";"Summer";"Fall";"Winter"];
    fiel = ["total";"nonHVAC";"ac";"furnace"];
    [temp,temp_id] = chkseas(dates,data.day);

    index = 1;
    if isweekend(data.day) || chkholi(dates,data.day)
        index = 2;
        if manual_temp.(seas(temp_id)).dail_non(1,1) == 0
            manual_temp.(seas(temp_id)).dail_non = ...
                [sum(data.(fiel(1)))*(1/60), sum(data.(fiel(2)))*(1/60)];
        else
            manual_temp.(seas(temp_id)).dail_non = ...
                [manual_temp.(seas(temp_id)).dail_non(:,1), ...
                manual_temp.(seas(temp_id)).dail_non(:,2);...
                sum(data.(fiel(1)))*(1/60), sum(data.(fiel(2)))*(1/60)];
        end
    else

        if manual_temp.(seas(temp_id)).dail_wee(1,1) == 0
            manual_temp.(seas(temp_id)).dail_wee = ...
                [sum(data.(fiel(1)))*(1/60), sum(data.(fiel(2)))*(1/60)];
        else
            manual_temp.(seas(temp_id)).dail_wee = ...
                [manual_temp.(seas(temp_id)).dail_wee(:,1), ...
                manual_temp.(seas(temp_id)).dail_wee(:,2);...
                sum(data.(fiel(1)))*(1/60), sum(data.(fiel(2)))*(1/60)];
        end
    end


    if isfield(manual_temp,(char(temp)))
        
        manual_temp.(seas(temp_id)).num(index) = manual_temp.(seas(temp_id)).num(index) + 1;


        if sum(sum(manual_temp.(seas(temp_id)).(fiel(1)))) ~= 0
            for i = 1:length(fiel)

                manual_temp.(seas(temp_id)).(fiel(i))(:,index) = (manual_temp.(seas(temp_id)).(fiel(i))(:,index)  + data.(fiel(i)))/2;

            end
        else
            for i = 1:length(fiel)

                manual_temp.(seas(temp_id)).(fiel(i))(:,index) = data.(fiel(i));

            end
        end
    else
        fprintf("\nThis error should not occur!\nIf it does there is a problem with the Manual Struct setup\n");
    end


end


function [data,empt_chk] = read_data(path,data,rng_strt,minday,dates)

    rang = strcat("A",num2str(rng_strt+1),":I",num2str((rng_strt + minday)));
    temp = readmatrix(path,'Range',rang);
    
    data.day = datetime([temp(1,1),temp(1,2),temp(1,3)]);
    data.time = datetime([temp(:,1),temp(:,2),temp(:,3),temp(:,4),temp(:,5),ones(length(temp(:,5)),1)]);
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
    [seas,id] = chkseas(dates,data.day);
%     fprintf("Date: %s\tSeason: %s\n",data.time,seas);

end


function isholi = chkholi(dates,day)

    isholi = 0;
    for i = 1:length(dates.holi.day)
        if day == dates.holi.day(i)
            isholi = 1;
        end
    end

end


function [seas,id] = chkseas(dates,time)
    
    seas_id = find(time > dates.seas.day,1,'last');
    seas = dates.seas.name(seas_id);
    temp = ["Spring";"Summer";"Fall";"Winter"];
    id = find(seas==temp(:),1);
%     fprintf("Date: %s\tSeason: %s\n",data.time,seas);

end

function arr_out = printprogress(count,arr)
    
    if count > arr(1)
        fprintf("*");
        arr_out = arr(2:end);
    else
        arr_out = arr;
    end

end

