RowNames = {'P IAE';'P ITAE';'PI IAE';'PI ITAE';'PID IAE';'PID ITAE'};
kp = [kppiIAE * 5; kppiITAE * 5; kppiIAE; kppiITAE; kppidIAE; kppidITAE];
ki = [0; 0; kipiIAE; kipiITAE; kipidIAE; kipidITAE];
kd = [0; 0; 0; 0; kdpidIAE; kdpidITAE]; 
tuningTable = table(kp, ki, kd, 'RowNames', RowNames);

hold on;
uitable('Data',tuningTable{:,:},'ColumnName',tuningTable.Properties.VariableNames,...
    'RowName',tuningTable.Properties.RowNames,'Units', 'Normalized', 'Position',[0, 0, 1, 1]);