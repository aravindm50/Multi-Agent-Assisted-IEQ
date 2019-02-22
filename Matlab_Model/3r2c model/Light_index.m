function [IEQ_Light,D] = Light_index(C)
% C in LUX
% IEQ
% reference :https://www.noao.edu/education/QLTkit/ACTIVITY_Documents/Safety/LightLevels_outdoor+indoor.pdf
C_hi = 0; C_lo = 0; I_hi = 0; I_lo = 0;

if 400<=C && C<=600
    C_hi = 600; C_lo = 400; I_hi = 50; I_lo = 0;D = 0;
% Moderate Comfortable and on darker side
elseif 200<=C && C <400
    C_hi = 399; C_lo = 200; I_hi = 75; I_lo = 51; D= -1;
% Moderate Comfortable and on brighter side
elseif 600<C && C <1000
    C_hi = 999; C_lo = 601; I_hi = 75; I_lo = 51; D = 1;    
% UnComfortable and Too Bright
elseif C >= 1000 && C<5000
    C_hi =5000; C_lo = 1000; I_hi = 100; I_lo = 76;D = 2;
% UnComfortable and Too Dark
elseif C >= 0 && C<200
    C_hi =199; C_lo = 0; I_hi = 100; I_lo = 76; D = -2;   
end

IEQ_Light = (((I_hi - I_lo)*(C - C_lo))/(C_hi - C_lo)) + I_lo;
        
