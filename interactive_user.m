%% 
clear; clc;   close all;


%%
filename = 'dataset/vmtable.csv';
timestep = 60;
numSteps = 30*24*3600/timestep;
times = 0:timestep:numSteps*timestep;
vmTypes = {'Delay-insensitive','Interactive','Unknown'};
cpuDemand = zeros(length(vmTypes), length(times));

%%
[vmids,userids,deloyids,createdtimes,deletedtimes,maxcpus,avgcpus,p95cpus,categories,cores,mems] = importVMTables(filename);

%% a
interactivesIds = strcmp(categories,'Interactive');

users = userids(interactivesIds);
uniqueUsers = cell(0,1);
for iUser =1:length(users)
  if sum(strcmp(uniqueUsers, users{iUser})) == 0
    uniqueUsers{length(uniqueUsers)+1} = users{iUser};
  end
end
% uniqueUsers = unique(cell2mat(users),'rows');

cpuDemand = zeros(length(uniqueUsers), length(times));


for iUser=1:length(uniqueUsers)
  userID = uniqueUsers{iUser};
  ids = strcmp(userids,userID);
  mcreatedtimes = createdtimes(ids);
  mdeletedtimes = deletedtimes(ids);
  mcores= cores(ids);
  mmems = mems(ids);

  for iVM = 1:length(mcreatedtimes)
    vmStartTime = mcreatedtimes(iVM);
    vmEndTime = mdeletedtimes(iVM);
    vmCore = mcores(iVM);
    vmMemory = mmems(iVM);

    % add to cpuDemand
    startId = round(vmStartTime/timestep)+1;
    endId = round(vmEndTime/timestep)+1;
    cpuDemand(iUser, startId:endId) = cpuDemand(iUser, startId:endId) + vmCore;
  end
  progressbar(iUser/length(uniqueUsers))
end

%% find the set of users
close all;
figure
% bar(cpuDemand, 1.0, 'stack')
plot(times, cpuDemand(:,:))
ylabel('cpu cores');
xlabel('minutes');
return

%% filter out the user demand
smallCpuDemand = zeros(0, length(cpuDemand,2));
threshold = 100;
for iUser=1:length(uniqueUsers)
  smallDemand = cpuDemand(iUser,:);
  if max(smallDemand) < threshold
    smallCpuDemand = [smallCpuDemand; smallDemand];
  end
end
close all
figure
% bar(cpuDemand, 1.0, 'stack')
plot(times, smallCpuDemand(:,:))
ylabel('cpu cores');
xlabel('minutes');
