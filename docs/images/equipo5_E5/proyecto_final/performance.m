plantInfo = stepinfo(sys);
pIAEInfo = stepinfo(pIAEControlled);
pITAEInfo = stepinfo(pITAEControlled);
piIAEInfo = stepinfo(piIAEControlled);
piITAEInfo = stepinfo(piITAEControlled);
pidIAEInfo = stepinfo(pidIAEControlled);
pidITAEInfo = stepinfo(pidITAEControlled);

RowNames = {'plant'; 'P IAE'; 'P ITAE'; 'PI IAE';'PI ITAE';'PID IAE';'PID ITAE'};
RiseTime = [plantInfo.RiseTime; pIAEInfo.RiseTime; pITAEInfo.RiseTime; piIAEInfo.RiseTime; piITAEInfo.RiseTime; pidIAEInfo.RiseTime; pidITAEInfo.RiseTime];
Overshoot = [plantInfo.Overshoot; pIAEInfo.Overshoot; pITAEInfo.Overshoot; piIAEInfo.Overshoot; piITAEInfo.Overshoot; pidIAEInfo.Overshoot; pidITAEInfo.Overshoot];
SettlingTime = [plantInfo.SettlingTime; pIAEInfo.SettlingTime; pITAEInfo.SettlingTime; piIAEInfo.SettlingTime; piITAEInfo.SettlingTime; pidIAEInfo.SettlingTime; pidITAEInfo.SettlingTime];
SettlingMin = [plantInfo.SettlingMin; pIAEInfo.SettlingMin; pITAEInfo.SettlingMin; piIAEInfo.SettlingMin; piITAEInfo.SettlingMin; pidIAEInfo.SettlingMin; pidITAEInfo.SettlingMin];
SettlingMax = [plantInfo.SettlingMax; pIAEInfo.SettlingMax; pITAEInfo.SettlingMax; piIAEInfo.SettlingMax; piITAEInfo.SettlingMax; pidIAEInfo.SettlingMax; pidITAEInfo.SettlingMax];
Undershoot = [plantInfo.Undershoot; pIAEInfo.Undershoot; pITAEInfo.Undershoot; piIAEInfo.Undershoot; piITAEInfo.Undershoot; pidIAEInfo.Undershoot; pidITAEInfo.Undershoot];
Peak = [plantInfo.Peak; pIAEInfo.Peak; pITAEInfo.Peak; piIAEInfo.Peak; piITAEInfo.Peak; pidIAEInfo.Peak; pidITAEInfo.Peak];
PeakTime = [plantInfo.PeakTime; pIAEInfo.PeakTime; pITAEInfo.PeakTime; piIAEInfo.PeakTime; piITAEInfo.PeakTime; pidIAEInfo.PeakTime; pidITAEInfo.PeakTime];
performanceTable = table(RiseTime, Overshoot, SettlingTime, SettlingMin, SettlingMax, Undershoot, Peak, PeakTime, 'RowNames', RowNames);

hold on;
uitable('Data',performanceTable{:,:},'ColumnName',performanceTable.Properties.VariableNames,...
    'RowName',performanceTable.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);