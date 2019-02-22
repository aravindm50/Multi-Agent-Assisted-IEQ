%% All variables

% Tdot ? two-dimensional vector matrix of first order derivatives of nodal temperatures.
% T ? two-dimensional vector matrix of interlayer surface temperatures.
% Tbs ? one-dimensional output matrix of temperature of the inner surface of the building envelope.
% A ? Co-efficient matrix
% B ? Vector matrix of input coefficients
% C ? Vector matrix of output coefficients
% D ? Coupling matrix of input and output coefficients
% ?a, Cpa: density (kg/m3) & specific heat capacity (J/kg-K) of air in the building space, respectively
% Qcasual: casual heat (due to occupants) gain (W)
% QHVAC: heat output from HVAC system. +ve if heating and –ve if cooling (W)
% A: Cross-sectional area of respective constructional elements (sq. mt.)
% Tcs: Temprature of the building space to be conditioned by
% HVAC system (deg C)
% Uwin: Window U-value (W/m2-K)
% N: No. of air changes per hour from the HVAC system (per hour).

%% State space Model

A = 

