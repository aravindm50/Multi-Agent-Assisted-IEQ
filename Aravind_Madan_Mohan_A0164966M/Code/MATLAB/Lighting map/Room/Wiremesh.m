y = zeros(12,17)
k =1;
for i = (1:12)
    for j = (1:17)
        y(i,j)= k;
        k = k+1;
    end   
end
x = ones(12,17)*300;
%x = [530,695;434,565,600,928,810,720,840,530,810,590,535,730,680,530];
x(4,10)  =   530;    %tabel 1
x(4,8)  =   695;    %tabel 2
x(6,8)  =   434;    %tabel 3
x(6,10)  =   565;    %tabel 4
x(8,10)  =   600;    %tabel 5
x(8,8)  =   928;    %tabel 6
x(10,8) =   810;    %tabel 7
x(10,10) =   720;    %tabel 8
x(10,2)  =   840;    %tabel 9
x(10,4)  =   530;    %tabel 10
x(8,2) =   810;    %tabel 11
x(8,4) =   590;    %tabel 12
x(6,2)  =   535;    %tabel 13
x(6,4)  =   730;    %tabel 14
x(4,4)  =   680;    %tabel 15
x(4,2)  =   530;    %tabel 16


surf(x,y)
%colormap(default)
%ylim([0 1000])
%heatmap(x,y)
