function [kP,kI,kD] = pidIAE(k, t0, T)
    kP = (1.086/k)*((t0/T)^(-0.869)) / 5;
    kI = 1 / (T)/(0.74-0.130*(t0 / T));
    kD = 0.348 * T * ((t0 / T) ^ 0.9292);
end

