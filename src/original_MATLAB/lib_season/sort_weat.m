function manual = sort_weat(manual,name)
%UNTITLED Summary of this function goes here

    rng_strt = 1;
    year = 2012;
    leap = chk_leapyear(year);  % Function 'leapyear' REQUIRES AEROSPOACE TOOLBOX
    if leap
        day = 366;
    else
        day = 365;
    end
    
    data = read_data(name,rng_strt,day);
    manual = sort_day(manual,data);

    
end


function manual = sort_day(manual,data)

    manual.ave = zeros(4,1);
    manual.max = manual.ave;
    manual.min = manual.ave;
    for i = 1:length(data.time)
        if ~isnan(data.avetemp(i))
            j = chk_seas(manual,data.time(i));
            manual.ave(j) = (manual.ave(j) + data.avetemp(i))/2;
            manual.max(j) = max(manual.max(j),data.avetemp(i));
            manual.min(j) = min(manual.min(j),data.avetemp(i));
        end
    end
 

end


function data = read_data(name,rng_strt,day)

    rang = strcat("A",num2str(rng_strt+1),":G",num2str((rng_strt + day)));
    temp = readmatrix(name,'Range',rang);
    data.time = datetime(temp(:,1),temp(:,2),temp(:,3));
    data.avetemp = temp(:,6);

end


function id = chk_seas(manual,time)
    
    seas_id = find(time > manual.seas.day,1,'last');
    seas = manual.seas.name(seas_id);
    temp = ["Spring";"Summer";"Fall";"Winter"];
    id = find(seas==temp(:),1);
%     fprintf("Date: %s\tSeason: %s\n",data.time,seas);

end

