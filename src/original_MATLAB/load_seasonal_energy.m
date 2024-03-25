%% load_final_plot
% comparing the simulink model and the BESS object to see the difference.

%% Clean Up
clear all;
close all;
clc 

% Ensure files were not left open in a failed run.
if ~isempty(fopen('all'))
    fclose(fopen('all'));
end


%% Path Setup
% Setup the clock used to demonstrate how long the program takes.
clock_time.time(1,:) = clock;

% In order to make the program more versatile in terms of determining the
% pathing this function finds the OS specific delimitter.
delim = find_delim(1);

% Hard check to make sure Lib is included.
addpath(strcat(pwd,delim,'lib'));

% Path setup
% Path 1: Library path, for external functions.
% Path 2: Data path, for stomanual.update.Rg results and data.
% Path 3: Log path, for stomanual.update.Rg the log of the code run.
% Path 4: IEEE_9_SIM path, for accessing the simulink simulations.
% Path 5: Specific Data path, for stomanual.update.Rg a specifc run of figures.
src_path(1,:) = string(strcat(pwd,delim,'lib'));
src_path(2,:) = string(strcat(pwd,delim,'lib_season'));
src_path(3,:) = string(strcat(pwd,delim,'input_season'));
src_path(4,:) = string(strcat(pwd,delim,'output'));
src_path(5,:) = string(strcat(pwd,delim,'output_season'));

% This fucntion checks and adds the appropriate paths.
chkpth(src_path);

%% Load and Process Load Data
hs_total = 23;
temp = readmatrix(strcat(src_path(3,:),delim,"holiday"));
dates.holi.day = datetime(temp(1:end,1),temp(1:end,2),temp(1:end,3));
temp = readmatrix(strcat(src_path(3,:),delim,"season"));
dates.seas.day = datetime(temp(1:end,1),temp(1:end,2),temp(1:end,3),temp(1:end,4),temp(1:end,5),temp(1:end,6));
dates.seas.name = ["Spring";"Summer";"Fall";"Winter";...
    "Spring";"Summer";"Fall";"Winter";...
    "Spring";"Summer";"Fall";"Winter";...
    "Spring";"Summer";"Fall";"Winter"];
dates.seas.name_short = ["Spring";"Summer";"Fall";"Winter"];
dates.fiel = ["total";"nonHVAC";"ac";"furnace"];
dates.weather = sort_weat(dates,strcat(src_path(3,:),delim,"weather"));

ener.lims = [7.69;14.95;26.52]*277.8;
ener.level = ["Low","Med","Hig"];
for i = 1:length(ener.level)
    
    ener.(ener.level(i)) = setupman(dates.seas.name(1:4,1),dates.fiel);

end
ener.annl = zeros(hs_total,4);
ener.houses = zeros(hs_total,16);
ener.house_count = zeros(1,3);

std_dev = setupman(dates.seas.name(1:4,1),dates.fiel);

manual.name = "H1";
manual.path_in = strcat(src_path(3,:),delim,"H1");
manual.path_save = strcat(src_path(5,:),delim,"H1");

for i = 2:hs_total
    
    manual.name = [manual.name;strcat("H",num2str(i))];
    manual.path_in = [manual.path_in;strcat(src_path(3,:),delim,manual.name(i))];
    manual.path_save = [manual.path_save;strcat(src_path(5,:),delim,manual.name(i))];

end 
hous_star = 1;
hous_leng = 23;

%% Process Houses

% manual.energy = zeros(hous_leng,16);
% manual.ener_tot = zeros(hous_leng,1);
% manual.ener_non = zeros(hous_leng,1);
% manual.ener_ac = zeros(hous_leng,1);
% manual.ener_fur = zeros(hous_leng,1);

for i = hous_star:hous_leng 

    fprintf("Currently Processing House %d / %d\t|",i,hous_leng);
    [house,temp_ener,temp_annl] = process_house_energy(manual.name(i),[manual.path_in(i);manual.path_save(i)],dates,1);
    ener.annl(i,:) = temp_annl;
    ener.houses(i,:) = temp_ener;
     
    ind = find(temp_annl(1,2) > ener.lims(:),1,'last');
    if isempty(ind)
        ind = 1;
    end
    fprintf("The nonHVAC Power is %6.2f GJ and is %s energy\n",temp_annl(1,2)*(1/277.8),ener.level(ind));

    house_num = strcat("H",num2str(i));
    std_dev = merge_level(std_dev,house,dates,house_num);
    ener.(ener.level(ind)) = merge_level(ener.(ener.level(ind)),house,dates,house_num);
    ener.house_count(ind) = ener.house_count(ind) + 1;

end 


%% Save Data

filetemp = strcat(src_path(5,:),"/house_energy.csv");
titles = ["Spring","","","","Summer","","","","Fall","","","",...
    "Winter","","","","Total","","","","Total","","","";...
    "Total (kWh)","Non-HVAC (kWh)","AC (kWh)","Furnace (kWh)",...
    "Total (kWh)","Non-HVAC (kWh)","AC (kWh)","Furnace (kWh)",...
    "Total (kWh)","Non-HVAC (kWh)","AC (kWh)","Furnace (kWh)",...
    "Total (kWh)","Non-HVAC (kWh)","AC (kWh)","Furnace (kWh)",...
    "Total (kWh)","Non-HVAC (kWh)","AC (kWh)","Furnace (kWh)",...
    "Total (GJ)","Non-HVAC (GJ)","AC (GJ)","Furnace (GJ)"];
writematrix(titles,filetemp,'WriteMode','overwrite');
writematrix([(ener.houses),ener.annl,ener.annl*(1/277.8)],filetemp,'WriteMode','append');

%% Extra

temp1 = "";
temp2 = "";
for i = 1:length(dates.seas.name_short)
    for j = 1:length(std_dev.(dates.seas.name_short(i)).name)
        if j == 1
            temp1 = [std_dev.(dates.seas.name_short(i)).name(j),"","",""];
            temp2 = ["Total_week","NonHVAC_week","Total_off","NonHVAC_off"];
        else
            temp1 = [temp1,std_dev.(dates.seas.name_short(i)).name(j),"","",""];
            temp2 = [temp2,"Total_week","NonHVAC_week","Total_off","NonHVAC_off"];
        end
    end
    
    tempname = strcat(src_path(5,:),delim,"daily_energy_",dates.seas.name_short(i),".csv");
    writematrix([temp1;temp2],tempname,'WriteMode','overwrite');
    writematrix(std_dev.(dates.seas.name_short(i)).comb,tempname,'WriteMode','append');

end

%% Plots

plot_seas_energy(ener.Low,"All Low Energy Houses",dates.fiel,dates.seas.name);
plot_seas_energy(ener.Med,"All Medium Energy Houses",dates.fiel,dates.seas.name);
plot_seas_energy(ener.Hig,"All High Energy Houses",dates.fiel,dates.seas.name);


%% Clean Up
% Simulation timer end
clock_time.time(6,:) = clock;


% Output messege 
message_clock(clock_time.time(1,:),clock_time.time(6,:),"");
message_sep();


% Turn off the diary
% diary('off');


% Ensure files were not left open in a failed run.
if ~isempty(fopen('all'))
    fclose(fopen('all'));
end

