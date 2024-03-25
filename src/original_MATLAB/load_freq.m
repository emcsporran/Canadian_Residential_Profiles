%% load_edit
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


H1.name = ["H1_2009_9";"H1_2010_2";"H1_2010_6"];
H2.name = ["H2_2009_9";"H2_2010_2";"H2_2010_6"];
H3.name = ["H3_2009_9";"H3_2010_2";"H3_2010_6"];
H4.name = ["H4_2009_9";"H4_2010_2";"H4_2010_6"];
H5.name = ["H5_2009_9";"H5_2010_2";"H5_2010_6"];
H6.name = ["H6_2009_9";"H6_2010_2";"H6_2010_6"];

message_sep();


%% Load Files
delta = 1;
minday = 24*60;
day = 8;
rang = strcat("A1:E",num2str(minday*day));

H1 = read_in(src_path,H1,rang,delim);
H2 = read_in(src_path,H2,rang,delim);
H3 = read_in(src_path,H3,rang,delim);
H4 = read_in(src_path,H4,rang,delim);
H5 = read_in(src_path,H5,rang,delim);
H6 = read_in(src_path,H6,rang,delim);


H1 = adjust_data(H1,minday,delta);
H2 = adjust_data(H2,minday,delta);
H3 = adjust_data(H3,minday,delta);
H4 = adjust_data(H4,minday,delta);
H5 = adjust_data(H5,minday,delta);
H6 = adjust_data(H6,minday,delta);


%% FFT Frequency Analysis 
filt_fft(H1.ave,"H1 FFT Analysis");


%% Evaluate an Array of Frequencies (Low Pass Filter)
rate = 1;
Fz_lp = 0.004:0.002:0.018;
name = "Low Pass Frequencies Analysis";
show_plot = 0;

filt_array = filt_lp_plot(rate,Fz_lp,name,H1.ave,show_plot);


%% Process Data at Selected Frequency
freq_id = 3;

H1.filt = filt_lp(rate,Fz_lp(freq_id),H1.ave);
H2.filt = filt_lp(rate,Fz_lp(freq_id),H2.ave);
H3.filt = filt_lp(rate,Fz_lp(freq_id),H3.ave);
H4.filt = filt_lp(rate,Fz_lp(freq_id),H4.ave);
H5.filt = filt_lp(rate,Fz_lp(freq_id),H5.ave);
H6.filt = filt_lp(rate,Fz_lp(freq_id),H6.ave);

agg.sep = H1.filt.sep.data + H2.filt.sep.data + H3.filt.sep.data +...
    H4.filt.sep.data + H5.filt.sep.data + H6.filt.sep.data;
agg.feb = H1.filt.feb.data + H2.filt.feb.data + H3.filt.feb.data +...
    H4.filt.feb.data + H5.filt.feb.data + H6.filt.feb.data;
agg.jun = H1.filt.jun.data + H2.filt.jun.data + H3.filt.jun.data +...
    H4.filt.jun.data + H5.filt.jun.data + H6.filt.jun.data;

plot_load_data(agg,(0:24/minday:24-(24/minday))',["Aggregated Filtered Load";strcat("Using LP Freq of ", num2str(Fz_lp(freq_id)))]);


%% Outputs

printout(agg,src_path(3,:),"filt_1_min.csv");


%% Clean Up
% Simulation timer end
clock_time.time(6,:) = clock;


% Output messege 
message_clock(clock_time.time(1,:),clock_time.time(6,:),"");
message_sep();


% Turn off the diary
diary('off');

