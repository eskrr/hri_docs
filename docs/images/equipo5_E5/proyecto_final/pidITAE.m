function [kP,kI,kD] = pidITAE(k, t0, T)
    kP = (0.965/k)*((t0/T)^(-0.855)) / 5;
    kI = 1 / (T)/(0.796-0.147*(t0 / T));
    kD = 0.348 * T * ((t0 / T) ^ 0.9292);
end

