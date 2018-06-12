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
uID = 14;
userID = userids{uID};%'BSXOcywx8pUU0DueDo6UMol1YzR6tn47KLEKaoXp0a1bf2PpzJ7n7lLlmhQ0OJf9';
machineType = categories{uID}
ids = strcmp(userids, userID);
cpuDemand = zeros(1, length(times));
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
  cpuDemand(startId:endId) = cpuDemand(startId:endId) + vmCore;
end
figure
bar(cpuDemand, 1.0, 'stack')
ylabel('cpu cores');
xlabel('minutes');