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
src_path(2,:) = string(strcat(pwd,delim,'input'));
src_path(3,:) = string(strcat(pwd,delim,'output'));

% This fucntion checks and adds the appropriate paths.
chkpth(src_path);

%% Load and Process Load Data

H1.name = ["H1_2009_9";"H1_2010_2";"H1_2010_6"];
H2.name = ["H2_2009_9";"H2_2010_2";"H2_2010_6"];
H3.name = ["H3_2009_9";"H3_2010_2";"H3_2010_6"];
H4.name = ["H4_2009_9";"H4_2010_2";"H4_2010_6"];
H5.name = ["H5_2009_9";"H5_2010_2";"H5_2010_6"];
H6.name = ["H6_2009_9";"H6_2010_2";"H6_2010_6"];
 
varargout = ave_input(8,src_path(2,:),[H1,H2,H3,H4,H5,H6]);
H1.ave = varargout(1).ave;
H2.ave = varargout(2).ave;
H3.ave = varargout(3).ave;
H4.ave = varargout(4).ave;
H5.ave = varargout(5).ave;
H6.ave = varargout(6).ave;


%% Load and Process Temp Data

temp.name = ["ottawa_weather_2009_09";"ottawa_weather_2010_02";"ottawa_weather_2010_06"];
minday = 24*60;
day = 8;
temp.rng = strcat("A1:E",num2str(minday*day));
temp = read_in(src_path(2,:),temp,temp.rng,delim);
temp = weat_data(temp,src_path(3,:),"temp_1_hour.csv");


%% Filter Load Data

agg_filt.rate = 1;
agg_filt.Fz = 0.004:0.002:0.018;
agg_filt.freq = agg_filt.Fz(3);
agg_filt = filt_var(agg_filt,minday,0,[H1,H2,H3,H4,H5,H6]);
printout(agg_filt,src_path(3,:),"filt_1_min.csv");

% If you want to see the data filtered at various frequencies.
% This function only supports one data set at a time.
filt_temp.showplot = 1;
filt_temp.data = filt_lp_plot(agg_filt.rate,agg_filt.Fz,...
    "Low Pass Frequency Analysis",H1.ave,filt_temp.showplot);


%% Average Load Data - 5 Min

agg_ave.five.delta = 5;
agg_ave.five = adjust_time(agg_ave.five,minday,agg_ave.five.delta,[H1,H2,H3,H4,H5,H6]);
printout(agg_ave.five,src_path(3,:),"ave_5_min.csv");


%% Average Load Data - 1 hour

agg_ave.hour.delta = 60;
agg_ave.hour = adjust_time(agg_ave.hour,minday,agg_ave.hour.delta,[H1,H2,H3,H4,H5,H6]);
printout(agg_ave.hour,src_path(3,:),"ave_1_hour.csv");


%% Load

ave_hour1 = readmatrix(strcat(src_path(3,:),delim,"ave_1_hour.csv"));
ave_min5 = readmatrix(strcat(src_path(3,:),delim,"ave_5_min.csv"));
filt_min1 = readmatrix(strcat(src_path(3,:),delim,"filt_1_min.csv"));


%% Plots

delta = 5;
t_5 = (0:(delta/60):(24-(delta/60)))';
delta = 1;
t_1 = (0:(delta/60):(24-(delta/60)))';
t_bar = 0:1:23;

figure("Name","Compare Data")
subplot(3,1,1)
hold on
b = bar(t_bar,ave_hour1(:,1),'histc');
b.FaceColor = "#77AC30";    % 'g'
plot(t_5,ave_min5(:,1),'color','k',"LineWidth",2);
plot(t_1,filt_min1(:,1),'color','m',"LineWidth",2);
hold off
grid on
title("September Daily Power Consumption (1 week average)");
ylabel("Power Consumed (kW)");
ylim([0 15]);
xlim([0 24]);
xticks(0:4:24);
legend("Ave 1 Hour","Ave 5 Min","Filt 1 Min " + "LP:" + ...
    num2str(agg_filt.freq) + newline + "Ave RMSE: " ...
    + num2str(agg_filt.RMSE_ave(1)) + newline + "Tot RMSE: " ...
    + num2str(agg_filt.RMSE_tot(1)));

subplot(3,1,2)
hold on
b = bar(t_bar,ave_hour1(:,2),'histc');
b.FaceColor = "#A2142F";    % 'r'
plot(t_5,ave_min5(:,2),'color','k',"LineWidth",2);
plot(t_1,filt_min1(:,2),'color','m',"LineWidth",2);
hold off
grid on
title("February Daily Power Consumption (1 week average)");
ylabel("Power Consumed (kW)");
ylim([0 15]);
xlim([0 24]);
xticks(0:4:24);
legend("Ave 1 Hour","Ave 5 Min","Filt 1 Min " + "LP:" + ...
    num2str(agg_filt.freq) + newline + "Ave RMSE: " ...
    + num2str(agg_filt.RMSE_ave(2)) + newline + "Tot RMSE: " ...
    + num2str(agg_filt.RMSE_tot(2)));

subplot(3,1,3)
hold on
b = bar(t_bar,ave_hour1(:,3),'histc');
b.FaceColor = "#0072BD";    % 'b'
plot(t_5,ave_min5(:,3),'color','k',"LineWidth",2);
plot(t_1,filt_min1(:,3),'color','m',"LineWidth",2);
hold off
grid on
title("June Daily Power Consumption (1 week average)");
ylabel("Power Consumed (kW)");
xlabel("Time (hrs)");
ylim([0 15]);
xlim([0 24]);
xticks(0:4:24);
legend("Ave 1 Hour","Ave 5 Min","Filt 1 Min " + "LP:" + ...
    num2str(agg_filt.freq) + newline + "Ave RMSE: " ...
    + num2str(agg_filt.RMSE_ave(3)) + newline + "Tot RMSE: " ...
    + num2str(agg_filt.RMSE_tot(3)));


%% Clean Up
% Simulation timer end
clock_time.time(6,:) = clock;


% Output messege 
message_clock(clock_time.time(1,:),clock_time.time(6,:),"");
message_sep();


% Turn off the diary
diary('off');
