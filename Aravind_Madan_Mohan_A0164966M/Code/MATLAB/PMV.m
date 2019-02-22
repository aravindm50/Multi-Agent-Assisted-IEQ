%Computer program (BASIC) for calculation of
% Predicted Mean Vote (PMV) and Predicted Percentage of Dissatisfaction (PPD)
% in accordance with ISO 7730
% INPUT “ Clothing (clo)” ; CLO
% INPUT “ Metabolic rate (met)” ; MET
% INPUT “ External work, normally around 0 (met)” ; WME
% INPUT “ Air Temperature (DEG K )” ; TA 
% INPUT “ Mean radiant temperature (DEG K )” ; TR
% INPUT “ Relative air velocity (m/s)” : VEL
% INPUT “ Relative humidity ( % )” ; RH


% CLO = 1;  % clothing
% MET = 1.1;  % metabolic rate
% WME = 0  ;  % external work
% TA  = 25.7+273 ;  % air temperature
% TR  = 25.7+273 ;  % mean radiant temperature
% VEL = 0.1;  % relative air velocity
% RH  = 15 ;  % relative humidity

function [PMV_index,PPD] = PMV(CLO,MET,TA,TR,VEL,RH)
TA  = TA - 273;
TR  =TR -273;
FNPS= exp(16.6536-4030.183/(TA + 235)); % saturated vapor pressure KPa
PA  = RH * 10 * FNPS; % water vapor pressure, Pa
ICL = .155 * CLO; % thermal insulation of the clothing in m2K/W
M   = MET * 58.15; % metabolic rate in W/m2
W   = 0; % external work in W/m2
MW  = M - W;  % internal heat production in the human body
% clothing area factor
if (ICL < .078) 
    FCL = 1 + 1.29 * ICL; 
else
    FCL = 1.05+0.645*ICL;
end
HCF = 12.1*sqrt(VEL) ; % heat transf. coefficient by forced convection
TAA = TA + 273; % air temperature in Kelvin
TRA = TR + 273; % mean radiant temperature in Kelvin

%%  CACULATE SURFACE TEMPERATURE OF CLOTHING BY ITERATION - - - - - - - - - - - - - - - -
TCLA = TAA + (35.5-TA) / (3.5*(6.45*ICL+.1)); % first guess for surface temperature of clothing
P1 = ICL * FCL; % calculation term
P2 = P1 * 3.96; % calculation term
P3 = P1 * 100; %calculation term
P4 = P1 * TAA; %calculation term
P5 = 308.7 -.028 * MW +P2 * (TRA/100) ^ 4; % calculation term
XN = TCLA / 100;
XF = XN;
EPS = .00015;% stop criteria in iteration

%% heat transf. coeff. by natural convection
XF = (XF+XN) / 2; 
HCN=2.38*abs(100*XF-TAA)^.25;
if (HCF>HCN)
    HC=HCF; 
else
    HC=HCN;
end
XN=(P5+P4*HC-P2*XF^4) / (100+P3*HC);
TCL = 100*XN - 273; 
while(abs(XN-XF) > EPS)
    XF = (XF+XN) / 2; % heat transf. coeff. by natural convection
    HCN=2.38*abs(100*XF-TAA)^.25;
    if (HCF>HCN)
        HC=HCF; 
    else
        HC=HCN;
    end
    XN=(P5+P4*HC-P2*XF^4) / (100+P3*HC);
    TCL=100*XN-273; % surface temperature of the clothing

end

%%  HEAT LOSS COMPONENTS
HL1 = 3.05*.001*(5733-6.99*MW-PA); % heat loss diff. through skin
% heat loss by sweating (comfort)
if (MW > 58.15) 
    HL2 = .42 * (MW - 58.15);
else
    HL2 =1;
end
% latent respiration heat loss
HL3 = 1.7 * .00001 * M * (5867-PA);
% dry respiration heat loss
HL4 = .0014 * M * (34-TA);
% heat loss by radiation
HL5 = 3.96*FCL*(XN^4-(TRA/100)^4);
% heat loss by convection
HL6 = FCL * HC * (TCL-TA);


%% CALCULATE PMV AND PPD 
% thermal sensation trans. Coeff.
TS = .303 * exp(-.036*M) + 0.028;
% predicted mean vote
PMV_index = TS * (MW-HL1-HL2-HL3-HL4-HL5-HL6);
% predicted percentage dissat.
PPD=100-95*exp(-.03353*PMV_index^4-.2179*PMV_index^2);
end