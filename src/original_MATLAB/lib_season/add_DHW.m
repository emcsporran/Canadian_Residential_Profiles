function add_DHW(path,path2,path3,dates)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    temp = readmatrix(path(1));
    data.H8.time = datetime([temp(:,1),temp(:,2),temp(:,3),temp(:,4),temp(:,5),ones(length(temp(:,5)),1)]);
    data.H8.nonHVAC = temp(:,6);
    data.H8.total = temp(:,7);
    data.H8.ac = temp(:,8);
    data.H8.furnace = temp(:,9);

    temp = readmatrix(path2(1));
    data.DHW.time = datetime([temp(:,1),temp(:,2),temp(:,3),temp(:,4),temp(:,5),ones(length(temp(:,5)),1)]);
    data.DHW.data = temp(:,6);

    fprintf("*|\nNeed to adjust H8 nonHVAC data.");%\t|
%     div = 1:length(data.DHW.data)/10:length(data.DHW.data);
    for j = 1:length(data.DHW.time)
        if data.DHW.data(j) ~= 0
            tim_temp = (data.H8.time(data.H8.time(:) == data.DHW.time(j)));
            if isempty(tim_temp)

                data.DHW.time(j) = datetime([year(data.DHW.time(j))-1,...
                    month(data.DHW.time(j)),day(data.DHW.time(j)),...
                    hour(data.DHW.time(j)),minute(data.DHW.time(j)), ...
                    second(data.DHW.time(j))]);
                tim_temp = (data.H8.time(data.H8.time(:) == data.DHW.time(j)));

            end
            if j == 480964
            fprintf("leng ind %d \t leng tim_temp %d\n",j,length(tim_temp));
            end
            ind = find(data.H8.time == tim_temp,1,'last');
            data.H8.nonHVAC(ind) = data.H8.nonHVAC(ind) - data.DHW.data(j);
        end

%         if j == div(1)
%             fprintf("*");
%             div = div(2:end);
%         end
    end


    times = [year(data.H8.time),month(data.H8.time),day(data.H8.time),...
        hour(data.H8.time),minute(data.H8.time)];
    titles = ["Year","Month","Day","Hour","Minute", ...
        "Non-HVAC (kW)","Main (kW)","AC (kW)","Furnace (kW)"];


    writematrix(titles,path3(1),'WriteMode','overwrite');
    writematrix([times,data.H8.nonHVAC,data.H8.total,data.H8.ac,...
        data.H8.furnace],path3(1),'WriteMode','append');

    fprintf("Saving: H8 Adjusted Complete\n");
    fprintf("Continuing Processing \t\t\t|");

end