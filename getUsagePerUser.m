%% 
clear; clc;   close all;


%%
filename = 'dataset/vmtable.csv';
timestep = 5; % mins
numSteps = 30*24*3600/timestep;
times = 0:timestep:numSteps*timestep;
vmTypes = {'Delay-insensitive','Interactive','Unknown'};


%%
[vmids,userids,deloyids,createdtimes,deletedtimes,maxcpus,avgcpus,p95cpus,categories,cores,mems] = importVMTables(filename);

%% a
uniqueUserIds = uniquecell(userids);
timestamps = 

cpuUtils = cell(length(uniqueUserIds),1);
cpuCapacity = cell(length(uniqueUserIds),1);

dataLen = 100; %length(createdtimes)
progressbar(0);
for iVM = 1:dataLen
  userIdStr = userids{iVM};
  index = find(ismember(uniqueUserIds, userIdStr));
  if (~exist(cpuUtils{index}))
    cpuUtils{index} = 0;
    cpuCapacity{index} = 0;
  end
  cpuUtils{index} = avgcpus(iVM);
  
  progressbar(iVM/length(dataLen))
end
progressbar(1)