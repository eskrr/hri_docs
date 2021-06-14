function [kP,kI] = piITAE(k, t0, T)
    kP = (0.586/k)*((t0/T)^(-0.916)) / 5;
    kI = 1 / (T)/(1.03-0.165*(t0 / T));
end

