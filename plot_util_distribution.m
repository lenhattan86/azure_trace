%% 
clear; clc;   close all;

%%
timelapse = 24*3600;
cpu_util_file = ['cpu_utils_' num2str(timelapse) '.csv'];
cpu_cap_file = ['cpu_caps_' num2str(timelapse) '.csv'];

cpu_utils = import_util_or_cap(cpu_util_file);
cpu_caps = import_util_or_cap(cpu_cap_file);

utils = cpu_utils./cpu_caps;
nUser = length(utils(1,:)) ;
util_99_percentiles = zeros(1, nUser)-1;

n_plot_user = nUser; %nUser
plot_count = 0;
%% plot util ditribution of each user
figure;
for iUser = 1:nUser  
  user_util = utils(:,iUser);  
  user_util=(user_util(~isnan(user_util)));
  if length(user_util) > 0
    util_99_percentiles(iUser) = prctile(user_util,99);
    if plot_count < n_plot_user
      [cdf_values, x] = ecdf(user_util);  
      plot(x,cdf_values,'LineWidth',1)
      hold on;
      plot_count = plot_count + 1;
    end
  end
end
xlabel('utilization (%)');
ylabel('cdf');
xlim([0 100]);
grid off;
title('utilization distribution per user');

%% plot 99 percentile utilization distribution
figure;
util_99_percentiles = (util_99_percentiles(util_99_percentiles>=0));
[cdf_values, x] = ecdf(util_99_percentiles);  
plot(x,cdf_values,'LineWidth',2);
xlabel('utilization (%)');
ylabel('cdf');
xlim([0 100]);
grid off;
title('utilization distribution - 99 percentile');