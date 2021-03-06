x = ones(17,12)*100;

%% Table 1 Lux
x(4,11)  =   270;    
x(4,10)  =   325;    
x(4,9)  =   316;    
x(4,8)  =   337;    
x(7,11)  =   210;    
x(7,10)  =   240;    
x(7,9)  =   260;    
x(7,8)  =   352;    

%% Table 2 Lux

x(12,11)  =   315;    
x(12,10)  =   488;    
x(12,9) =   670;    
x(12,8)  =   830;
x(14,11)  =   292;    
x(14,10)  =   502;    
x(14,9)  =   635;    
x(14,8)  =   740; 
x(15,11)  =   229;    
x(15,10)  =   337;    
x(15,9)  =   370;    
x(15,8)  =   518;

%% Table 3 Lux

x(12,4)  =   742;    
x(12,3)  =   665;    
x(12,2)  =   550;    
x(12,1)  =   390;
x(15,4)  =   625;    
x(15,3)  =   480;    
x(15,2)  =   250;    
x(15,1)  =   210;

%% Table 4 Lux

x(4,4)  =   445;    
x(4,3)  =   405;    
x(5,2)  =   288;    
x(5,1)  =   230;
x(7,4)  =   340;    
x(7,3)  =   325;    
x(7,2)  =   290;    
x(7,1)  =   217;

% for i= [1,17]
%     for j = 1:12
%         x(i,j) = 0;
%     end
% end
% for j= [1,12]
%     for i = 1:17
%         x(i,j) = 0;
%     end
% end
x = interp2(x);

h = heatmap(x);
