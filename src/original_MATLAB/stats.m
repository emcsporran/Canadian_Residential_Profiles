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

%% Load

manual = readmatrix(strcat(pwd,delim,"stats.csv"));

X = [ones(size(manual(:,1))) manual(:,6) manual(:,7) manual(:,8)];
Y = manual(:,3);


%% Stats

[b,bint,r,rint,stat_out] = regress(Y,X);


%% My Attempt at calculating B

X_X = transpose(X)*X;
X_Y = transpose(X)*Y;

b_man = X_X\X_Y;


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
