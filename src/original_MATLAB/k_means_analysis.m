%% stat_analysis
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
message_sep();


%% Variables
alph = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';


%% Annual Consumption
fprintf("Plotting Annual Consumption\n");
ener.fiel = ["Spring_KWH","Summer_KWH","Fall_KWH","Winter_KWH","Annual_KWH","Annual_GJ"];
lev = [4813;8156;13011]*(1/277.8);
for i = 1:6
    
    rang = strcat(alph(i*4-3),num2str(3),":",alph(i*4),num2str(23+2));
    
    ener.(ener.fiel(i)) = readmatrix(strcat(src_path(5,:),delim,"house_energy.csv"),"Range",rang);
    
end

labels = strings(1,23);
for i = 1:23
    labels(i) = strcat("H",num2str(i));
end

ener.std_GJ = std(ener.(ener.fiel(6)));
temp = ones(1,length(ener.(ener.fiel(6))(:,1)));

max_std = max(ener.(ener.fiel(6))(:,1) + ener.std_GJ(1));
max_std = max([max_std, max(ener.(ener.fiel(6))(:,1) + ener.std_GJ(1))]);

figure("Name","Annual Consumption")
hold on
plot(1:23,ener.Annual_GJ(:,1),'Color','blue',"LineWidth",2);
plot(1:23,ener.Annual_GJ(:,2),'Color','red',"LineWidth",2);
% plot(1:23,ones(1,23)*lev(1),"Color",'black','LineStyle','--',"LineWidth",2);
% text(2,lev(1)+2,'Low Energy');
% plot(1:23,ones(1,23)*lev(2),"Color",'black','LineStyle','--',"LineWidth",2);
% text(2,lev(2)+2,'Med Energy');
% plot(1:23,ones(1,23)*lev(3),"Color",'black','LineStyle','--',"LineWidth",2);
% text(2,lev(3)+2,'Hig Energy');
hold off
grid on
xlim([1 23]);
xticks(1:23);
set(gca,'XTickLabel',labels)
title("Annual Consumption");
ylabel("Power Consumption (GJ)");
legend(["Total","NonHVAC"]);

message_sep();


%% DHW
fprintf("DHW Analysis\n");

DHW.data = readmatrix(strcat(src_path(3,:),delim,"H10_DHW.csv"));
DHW.AnnGJ = sum(DHW.data(:,end))*(1/60)*(1/277.8);

message_sep();


%% K-Means
fprintf("K-Means Analysis\n");
man_kmean.k = 3; % How may centroids do we want to look for.
% May want to to 
[man_kmean.idx,man_kmean.C] = kmeans(ener.Annual_GJ(:,2),man_kmean.k,'Distance','cityblock');   % Annual GJ is Non-HVAC because of the indices.
man_kmean.col = ["r*";"b*";"m*"];
man_kmean.txt = ["Low Energy Centroid: ";"Medium Energy Centroid: ";"High Energy Centroid: "];
man_kmean.t = 1:23;
man_kmean.C = sort(man_kmean.C);
fprintf("Low: %2.2f GJ\tMedium: %2.2f GJ\tHigh: %2.2f GJ\n",man_kmean.C);

figure
hold on
for i = 1:man_kmean.k

    plot(man_kmean.t(man_kmean.idx==i),ener.Annual_GJ(man_kmean.idx==i,2),man_kmean.col(i),'MarkerSize',12,'LineWidth',2);
    plot(1:23,ones(1,23).*man_kmean.C(i,1),'k--','LineWidth',3);
    text(2,man_kmean.C(i)+2,strcat(man_kmean.txt(i), num2str(man_kmean.C(i))," GJ"));

end
hold off;
ylabel("Annual Non-HVAC Consumption (GJ)");
grid on
xlim([1 23]);
xticks(1:23);
set(gca,'XTickLabel',labels)
title('K-Means Clustering');

fprintf("Note that K-Means results vary so if the results seem incorrect then run again.\n");

message_sep();


%% Daily
fprintf("Plotting Seasonal Daily Averages\n");

houses = 23;
alph2 = createrange(alph);
std_man.seas = ["Spring","Summer","Fall","Winter"];
for i = 1:length(std_man.seas)
    std_man.(std_man.seas(i)).std_dev = zeros(houses,4);
    std_man.(std_man.seas(i)).std_mean = zeros(houses,4);
    std_man.(std_man.seas(i)).std_max = zeros(houses,4);
    std_man.(std_man.seas(i)).std_min = zeros(houses,4);
    std_man.(std_man.seas(i)).std_num = zeros(houses,4);

    for j = 1:houses 
        rang = strcat(alph2(j*4-3),":",alph2(j*4));
    
        temp_imp = readmatrix(strcat(src_path(5,:),delim,...
            "daily_energy_",std_man.seas(i),".csv"),"Range",rang);
        
        for k = 1:4
            std_man.(std_man.seas(i)).std_dev(j,k) = std(nonzeros(temp_imp(3:end,k)));  % Format is [Total_Week, NonHVAC_Week, Total_Off, NonHVAC_Off] repeated for each house.
            std_man.(std_man.seas(i)).std_mean(j,k) = mean2(nonzeros(temp_imp(3:end,k)));
            std_man.(std_man.seas(i)).std_max(j,k) = max(nonzeros(temp_imp(3:end,k)));
            std_man.(std_man.seas(i)).std_min(j,k) = min(nonzeros(temp_imp(3:end,k)));
            std_man.(std_man.seas(i)).std_num(j,k) = length(nonzeros(temp_imp(3:end,k)));
        end
    end

end


figure("Name","Average Daily Consumption kWh")
color_arr = ['-b';'-r';'-b';'-r'];
for i = 1:4
    subplot(4,2,2*i-1)
    hold on

    for j = 1:2
        y = std_man.(std_man.seas(i)).std_mean(:,j)';
        y_std = std_man.(std_man.seas(i)).std_dev(:,j)';
        H = shadedErrorBar(1:23,y,[y_std;y_std],'lineprops',{color_arr(j,:),'LineWidth',2},'patchSaturation',0.33);
    end

    hold off
    grid on
    xlim([1 23]);
    xticks(1:23);
    ylim([0 90]);
    yticks(0:15:90);
    set(gca,'XTickLabel',labels)
    title(strcat(std_man.seas(i)," Daily Average (Weekday)"));
    subtitle(strcat("Min Nonzero Samples per House = ",num2str(min(min(std_man.(std_man.seas(i)).std_num(:,1:2))))));
    ylabel("Power (kWh)");
    if i == 4
        legend(["Total","NonHVAC"]);
    end

    subplot(4,2,2*i)
    hold on

    for j = 3:4
        y = std_man.(std_man.seas(i)).std_mean(:,j)';
        y_std = std_man.(std_man.seas(i)).std_dev(:,j)';
        H = shadedErrorBar(1:23,y,[y_std;y_std],'lineprops',{color_arr(j,:),'LineWidth',2},'patchSaturation',0.33);
    end

    hold off
    grid on
    xlim([1 23]);
    xticks(1:23);
    ylim([0 90]);
    yticks(0:15:90);
    set(gca,'XTickLabel',labels)
    title(strcat(std_man.seas(i)," Daily Average (Off-day)"));
    subtitle(strcat("Min Nonzero Samples per House = ",num2str(min(min(std_man.(std_man.seas(i)).std_num(:,3:4))))));
    ylabel("Power (kWh)");
    if i == 4
        legend(["Total","NonHVAC"]);
    end
end
message_sep();


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


%% Functions

function alph2 = createrange(alph)
    ind = 4;
    alph2 = strings(length(alph)*ind,1);
    for j = 1:ind
        for i = 1:length(alph)
            ind = i + (length(alph)*(j-1));
            if ((j - 1) > 0)
                alph2(ind) = convertCharsToStrings(strcat(alph(j-1),alph(i)));
            else
                alph2(ind) = convertCharsToStrings(alph(i));
            end
        end
    end

end
