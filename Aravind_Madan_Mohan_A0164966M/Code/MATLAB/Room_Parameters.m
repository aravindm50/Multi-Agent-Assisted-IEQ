Ts=1;
Duration=36000;
%% Coefficients of Rs and Cs


l1 = 7.37;
b1 = 2.63;
y1 = 0.5;
x1 = 0.33;
y2 = 0.5;
x2 = 0.33;
x3 = 0.33;

l2 = 10.11;
b2 = 2.63;
y3 = 0.5;
x4 = 0.33;
y4 = 0.5;
x5 = 0.33;
x6 = 0.33;

x4_g = 0.5;
x5_g = 0.5;
y3_g = 1;

l3 = 7.37;
b3 = 2.63;
y5 = 0.5;
x7 = 0.33;
y6 = 0.5;
x8 = 0.33;
x9 = 0.33;

l4 = 10.11;
b4 = 2.63;
y7 = 1;
x10 = 0.5;
%y8 = 0.5;
x11 = 0.5;
%x12= 0.33;

l5 = 10.11;
b5 = 7.37;
y9 = 0.5;
x13 = 0.33;
y10 = 0.5;
x14 = 0.33;
x15 = 0.33;

l6 = 10.11;
b6 = 7.37;
y11 = 0.5;
x16 = 0.33;
y12 = 0.5;
x17 = 0.33;
x18 = 0.33;

A1 = l1 * b1;
A2 = l2 * b2;
A3 = l3 * b3;
A4 = l4 * b4;
A5 = l5 * b5;
A6 = l6 * b6;

T1_initial_front=28;
T2_initial_front=27;

T1_initial_left=28;
T2_initial_left=27;

T1_initial_right=28;
T2_initial_right=27;

T1_initial_back=28;
T2_initial_back=27;

T1_initial_roof=28;
T2_initial_roof=27;

T1_initial_floor=28;
T2_initial_floor=27;

ri = 0.1300; % m2 K/W resistance of inner surface of brick wall
rso = 0.04; % m2 K/W resistance of outer surface of the wall

%% Density of Building materials in the room
p_conc    = 1700; % kg/m3 density of concrete
p_pstr     = 1000; % kg/m3 density of plastering
p_gb       = 1100; % kg/m3 density of gypsum board
p_glass    = 2500; % kg/m3 density of glass
p_swood  = 550;   % kg/m3 density of soft-wood

%% Thermal heat capacity of the building materials in the room
c_conc    = 840;  % J/kg K heat capacity of concrete
c_pstr     = 1000;  %J/kg K heat capacity of plastering
c_gb       = 1090; % J/kg K heat capacity of gypsum board
c_glass    = 840;  % J/kg K heat capacity of glass
c_swood  = 1700; % J/kg K heat capacity of soft-wood

%% Thermal conductivity(lamda) of building materials in the room
l_conc    = 0.8;  % W/m K Thermal conductivity of concrete
l_pstr     = 0.013;  % W/m K Thermal conductivity of plastering
l_gb       = 0.35; % W/m K Thermal conductivity of gypsum board
l_glass    = 0.8;  % W/m K Thermal conductivity of glass
l_swood  = 0.08; % W/m K Thermal conductivity of soft-wood

%% Standard thickness of materials used
d_conc = 0.01;  % m Thickness of concrete BCA standard
d_pstr = 0.005; % m Thickness of plastering BCA standard
d_glass = 0.015; % m Thickness of glass wall widely used
d_swood = 0.01; % m Thickness of softwood on the right wall
d_gb = 0.015; % m Thickness of gypsum board

%% Resistance and Capacitance of front Wall
Rth1 =( ri + rso + (d_conc/l_conc) + (d_pstr/l_pstr))/(A1); % Thermal resistance
Cth1 = A1*(d_conc*p_conc*c_conc + d_pstr*p_pstr*c_pstr) ; % Thermal Capacitance

%% Resistance and Capacitance of left Wall concrete
A_conc = A2 * 0.5; % Half of the wall on the left is  glass wall
Rth2 =( ri + rso + (d_conc/l_conc) + (d_pstr/l_pstr))/(A_conc); % Thermal resistance
Cth2 = A_conc*(d_conc*p_conc*c_conc + d_pstr*p_pstr*c_pstr); % Thermal Capacitance

%% Resistance and Capacitance of left Wall glass
A_glass = A2 * 0.5; % Half of the wall on the left is  glass wall
Rth2_g =(d_glass/l_glass) /(A_glass); % Thermal resistance
Cth2_g = A_glass*(d_glass*p_glass*c_glass ); % Thermal Capacitance

%% Resistance and Capacitance of right Wall
Rth3 = ( ri + rso+ (d_conc/l_conc) + (d_swood/l_swood))/(A3);% Thermal resistance
Cth3 = A3*(d_swood*p_swood*c_swood + d_conc*p_conc*c_conc ); % Thermal Capacitance

%% Resistance and Capacitance of back Wall
Rth4 =(d_glass/l_glass) /(A4); % Thermal resistance
Cth4 = A4*(d_glass*p_glass*c_glass ); % Thermal Capacitance

%% Resistance and Capacitance of roof Wall
Rth5 = (d_gb/l_gb)/(A5);% Thermal resistance
Cth5 = A5*(d_gb*p_gb*c_gb ); % Thermal Capacitance

%% Resistance and Capacitance of floor Wall
Rth6 = (d_gb/l_gb)/(A6);% Thermal resistance
Cth6 = A6*(d_gb*p_gb*c_gb ); % Thermal Capacitance

