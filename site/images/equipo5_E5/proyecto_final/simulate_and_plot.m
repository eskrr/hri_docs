clear

MAX_RPM = 2319;
STEP = 0.7;

k = 0.997967104;
theta = 100;
tao = 10;

sys = tf(k, [tao, 1]);

% PI IAE
[kppiIAE, kipiIAE] = piIAE(k, tao, theta); 
piIAEControlled = feedback(pid(kppiIAE, kipiIAE) * sys, 1);
% PI ITAE
[kppiITAE, kipiITAE] = piITAE(k, tao, theta); 
piITAEControlled = feedback(pid(kppiITAE, kipiITAE) * sys, 1);
% PID IAE
[kppidIAE, kipidIAE, kdpidIAE] = pidIAE(k, tao, theta); 
pidIAEControlled = feedback(pid(kppidIAE, kipidIAE, kdpidIAE) * sys, 1);
% PID ITAE
[kppidITAE, kipidITAE, kdpidITAE] = pidITAE(k, tao, theta); 
pidITAEControlled = feedback(pid(kppidITAE, kipidITAE, kdpidITAE) * sys, 1);
% P IAE
pIAEControlled = feedback(pid(kppiIAE * 5) * sys, 1);
% P ITAE
pITAEControlled = feedback(pid(kppiITAE * 5) * sys, 1);

sys.InputDelay = theta;
piIAEControlled.InputDelay = theta;
piITAEControlled.InputDelay = theta;
pidIAEControlled.InputDelay = theta;
pidITAEControlled.InputDelay = theta;
pIAEControlled.InputDelay = theta;
pITAEControlled.InputDelay = theta;

opt = stepDataOptions('StepAmplitude', STEP * MAX_RPM);
hold on;
step(sys, pIAEControlled, pITAEControlled, piIAEControlled, piITAEControlled, pidIAEControlled, pidITAEControlled, opt);
legend('plant', 'P IAE', 'P ITAE', 'PI IAE', 'PI ITAE', 'PID IAE', 'PID ITAE');


