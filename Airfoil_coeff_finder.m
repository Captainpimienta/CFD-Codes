%% IMPORTING DATA, IN THIS CASE CHORD VS Cp viscous and inviscid and Q viscous and inviscid
% In this case the file has been generated from xflr5 and imported as a
% table through the matlab wizard
Name=input("Enter airfoil name: \n","s")
Re=input("Enter data's Re: \n");
AoA=input("Enter airfoil's angle of attack: \n");
NCrit=input("Enter data's Ncrit: \n"); %Measure of free flow turbulence and
%Used to simulate the transition location when no forced trip location is 
%given
Ma=input ("Enter data's Ma: \n");
%% SORTING DATA
x=table2array(Data(:,"x"));
Cp_v=table2array(Data(:,"Cpv")); %Viscous pressure coefficient

%% PLOTTING PRESSURE COEFFICIENT AGAINST CHORD POSITION
figure(1)
plot(x,Cp_v)
yline(0)
title("Cp vs x/c")
xlabel("Chord position")
ylabel("Pressure coefficient")

%% CALCULATING LIFT COEFFICIENT BY PRESSURE COEFFICIENT INTEGRATION

% Method 1: Cumulative integral of the area with the x-axis and extracting
% the final value
Cl_x=cumtrapz(x,Cp_v);
Cl_total_1=Cl_x(end)

% Method 2: Separating pressure side and suction side line. In this case
% up to data 50.

x_top=flip(x(1:50));
x_bot=x(50:99);
Cp_v_top=flip(Cp_v(1:50));
Cp_v_bot=Cp_v(50:99);

% Creating a function for the pressure and suction side Cp data

F=griddedInterpolant(x_bot,Cp_v_bot);
fun_bot=@(x) F(x);
F=griddedInterpolant(x_top,Cp_v_top);
fun_top=@(x) F(x);

% Integrating between limits to give lift coefficient

Cl_total_2=integral(@(x) fun_bot(x)-fun_top(x),0,1)

Cl_top=integral(@(x) fun_top(x),0,1);
Cl_bot=integral(@(x) fun_bot(x),0,1);

%% PRINTING THE RESULT
fprintf('The lift coefficient for %s airfoil at %iº under a Reynolds number of %i, Ma of %i and NCrit of %i is: Cl=%.3f \n',Name,AoA,Re,Ma,NCrit,Cl_total_1)
