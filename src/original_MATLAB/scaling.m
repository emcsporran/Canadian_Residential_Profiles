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

details = readtable("stats.csv");
temp = readmatrix(strcat(src_path(3,:),delim,"holiday"));
dates.holi.day = datetime(temp(1:end,1),temp(1:end,2),temp(1:end,3));
temp = readmatrix(strcat(src_path(3,:),delim,"season"));
dates.seas.day = datetime(temp(1:end,1),temp(1:end,2),temp(1:end,3),temp(1:end,4),temp(1:end,5),temp(1:end,6));
dates.seas.name = ["Spring";"Summer";"Fall";"Winter";...
    "Spring";"Summer";"Fall";"Winter";...
    "Spring";"Summer";"Fall";"Winter";...
    "Spring";"Summer";"Fall";"Winter"];
dates.weather = sort_weat(dates,strcat(src_path(3,:),delim,"weather"));
manual.name = "H1";
manual.path_in = strcat(src_path(3,:),delim,"H1");
manual.path_save = strcat(src_path(5,:),delim,"H1");

for i = 2:23
    
    manual.name = [manual.name;strcat("H",num2str(i))];
    manual.path_in = [manual.path_in;strcat(src_path(3,:),delim,manual.name(i))];
    manual.path_save = [manual.path_save;strcat(src_path(5,:),delim,manual.name(i))];

end

hous_leng = 23; % length(manual.name)



%% Processing Metric
appl_prop = {'Stove';'Fridge';'Washer';'Dryer';'Dishwasher';...
    'Fridge';'Freezer'};

appl = zeros(7,1);
appl(1,1) = mean2(details.Stove);
appl(1,2) = mean2(details.Fridge);
appl(1,3) = mean2(details.Washer);
appl(1,4) = mean2(details.Dryer);
appl(1,5) = mean2(details.Dishwasher);
appl(1,6) = mean2(details.Fridge);
appl(1,7) = mean2(details.Freezer);

appl_tb = table(appl,appl_prop);

%% Plots

% plot_seas(manual,"All Houses",0,dates.seas.name);


%% Clean Up
% Simulation timer end
clock_time.time(6,:) = clock;


% Output messege 
message_clock(clock_time.time(1,:),clock_time.time(6,:),"");
message_sep();


% Turn off the diary
diary('off');


% Ensure files were not left open in a failed run.
if ~isempty(fopen('all'))
    fclose(fopen('all'));
end

