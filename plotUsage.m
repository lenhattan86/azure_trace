%% 
clear; clc;   close all;


%%
filename = 'dataset/vmtable.csv';
timestep = 60;
numSteps = 30*24*3600/timestep;
times = 0:timestep:numSteps*timestep;
vmTypes = {'Delay-insensitive','Interactive','Unknown'};
cpuDemand = zeros(length(vmTypes), length(times));
memDemand = zeros(length(vmTypes), length(times));

%%
[vmids,userids,deloyids,createdtimes,deletedtimes,maxcpus,avgcpus,p95cpus,categories,cores,mems] = importVMTables(filename);
%%
for iVM = 1:length(vmids)
  vmStartTime = createdtimes(iVM);
  vmEndTime = deletedtimes(iVM);
  vmCore = cores(iVM);
  vmMemory = mems(iVM);
  
  machineType = find(strcmp(vmTypes,categories(iVM)),1);
  
  % add to cpuDemand
  startId = vmStartTime/timestep+1;
  endId = round(vmEndTime/timestep)+1;
  cpuDemand(machineType, startId:endId) = cpuDemand(machineType, startId:endId) + vmCore;
  memDemand(machineType, startId:endId) = memDemand(machineType, startId:endId) + vmMemory;
  progressbar(iVM/length(vmids))
end
save('plotUsage.mat','cpuDemand','memDemand','numSteps');
%%
close all;
load('plotUsage.mat');
figure
bar(cpuDemand(:,1:numSteps)', 1.0, 'stack')
legend(vmTypes);
ylabel('cpu cores');
xlabel('minutes');

