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

v.rel = version('-date');
v.year = str2num(v.rel(end-3:end));
v.lim = 2019;

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
 
varargout = ave_input(day,src_path(2,:),[H1,H2,H3,H4,H5,H6]);
H1.ave = varargout(1).ave;
H2.ave = varargout(2).ave;
H3.ave = varargout(3).ave;
H4.ave = varargout(4).ave;
H5.ave = varargout(5).ave;
H6.ave = varargout(6).ave;


%% adjust_data File Data

agg.min5.delta = 5;
agg.min5 = adjust_time(agg.min5,minday,agg.min5.delta,[H1,H2,H3,H4,H5,H6]);


agg.hour1.delta = 60;
agg.hour1 = adjust_time(agg.hour1,minday,agg.hour1.delta,[H1,H2,H3,H4,H5,H6]);


printout(agg.min5,src_path(3,:),"ave_5_min.csv");
printout(agg.hour1,src_path(3,:),"ave_1_hour.csv");


%% Plot

t = (0:(agg.min5.delta/60):(24-(agg.min5.delta/60)))';
t_hour = 0:1:23;

% plot_load_data(agg.min5,t,"5 Min Data");

plot_load_bar(agg.min5,agg.hour1,t,t_hour,"Averaged Load Comparison");


% figure
% subplot(3,1,1)
% hold on
% plot(t,H1.min5.sep,'color','g',"LineWidth",2);
% plot(t,H2.min5.sep,'color','r',"LineWidth",2);
% plot(t,H3.min5.sep,'color','m',"LineWidth",2);
% plot(t,H4.min5.sep,'color','k',"LineWidth",2);
% plot(t,H5.min5.sep,'color','c',"LineWidth",2);
% plot(t,H6.min5.sep,'color','b',"LineWidth",2);
% hold off
% grid on
% title("September")
% ylabel("Power Consumed (kW)");
% xlim([0 24]);
% xticks(0:4:24);
% legend('H1','H2','H3','H4','H5','H6');
% 
% subplot(3,1,2)
% hold on
% plot(t,H1.min5.feb,'color','g',"LineWidth",2);
% plot(t,H2.min5.feb,'color','r',"LineWidth",2);
% plot(t,H3.min5.feb,'color','m',"LineWidth",2);
% plot(t,H4.min5.feb,'color','k',"LineWidth",2);
% plot(t,H5.min5.feb,'color','c',"LineWidth",2);
% plot(t,H6.min5.feb,'color','b',"LineWidth",2);
% hold off
% grid on
% title("February")
% ylabel("Power Consumed (kW)");
% xlim([0 24]);
% xticks(0:4:24);
% 
% subplot(3,1,3)
% hold on
% plot(t,H1.min5.jun,'color','g',"LineWidth",2);
% plot(t,H2.min5.jun,'color','r',"LineWidth",2);
% plot(t,H3.min5.jun,'color','m',"LineWidth",2);
% plot(t,H4.min5.jun,'color','k',"LineWidth",2);
% plot(t,H5.min5.jun,'color','c',"LineWidth",2);
% plot(t,H6.min5.jun,'color','b',"LineWidth",2);
% hold off
% grid on
% title("June")
% ylabel("Power Consumed (kW)");
% xlabel("Time (hrs)");
% xlim([0 24]);
% xticks(0:4:24);


%% Clean Up
% Simulation timer end
clock_time.time(6,:) = clock;


% Output messege 
message_clock(clock_time.time(1,:),clock_time.time(6,:),"");
message_sep();


% Turn off the diary
diary('off');

