clc
clear all
%% PHYSICAL PARAMETERS
rho=1.225%input('Enter fluid density in SI units: ');%Fluid density
mu=1.849E-5%input('Enter fluid dynamic viscosity in SI units: ');%Dynamic viscosity
u=15%input('Enter free stream velocity in SI units: ');%Freestream velocity
L=0.01%input('Enter characteristic length in SI units: ');%Characteristic length

%% TYPE OF FLOW INTERNAL/EXTERNAL

Sim_case=lower(input("Enter 'internal' for internal flow simulation, or 'external' for external flow simulation: \n","s"))
disp(Sim_case)

if strcmp("internal",Sim_case)==1
    Re_ref=2.3E3
    tp=0;
elseif strcmp("external",Sim_case)==1
    Re_ref=5E5
    tp=1;
else
    error("Wrong input when defining flow simulation case")
end

%% CHECKING THERMAL SIMULATION
Sim_case_type=lower(input("Is it a heat transfer simulation?: Y/N \n","s"))
disp(Sim_case_type)

if strcmp("y",Sim_case_type)==1
    th=1;
elseif strcmp("n",Sim_case_type)==1
    th=0;
else
    error("Wrong input when defining thermal simulation case")
end
%% BOUNDARY LAYER HEIGHT
Re=rho*u*L/mu
if Re>Re_ref*0.9 && Re<Re_ref*1.1
    disp('Transition regime')
    x=lower(input('Choose "Laminar" or "Turbulent": ','s'))
    disp(x)
elseif Re>Re_ref
    disp('Turbulent regime')
    x='Turbulent';
else
    disp('Laminar regime')
    x='Laminar';
end

if strcmp('Laminar',x)==1
    
    if th==1
        x="Cubic profile";
        disp(x)
        d99=4.64*L/sqrt(Re)
        Cf=0.646/sqrt(Re)
    else
        if tp==1
            x="Blasius profile";
            disp(x)
            d99=4.91*L/sqrt(Re)
            Cf=0.664/sqrt(Re)
        else
            x="Parabolic profile";
            disp(x)
            d99=5.48*L/sqrt(Re)
            Cf=0.730/sqrt(Re)
        end
    end
elseif strcmp('Turbulent',x)==1
    d99=0.38*L/Re^0.2
    Cf=0.026/Re^(1/7)
else
    error('wrong transition flow treatment entered \n')
end

%% NUMBER OF LAYERS CALCULATOR
wallshear=Cf*rho*u^2/2
Ufric=sqrt(wallshear/rho)
y_plus=input('Enter target y+ value: ');
dS=y_plus*mu/(Ufric*rho)
H=2*dS

G=input('Enter growth ratio: ');
if G<=1
    error('Growth ratio has to be greater than 1')
end
f=@(N) H*(1-G^N)/(1-G)-d99;
N=fix(fzero(f,10))+1;
fprintf('Your first guess for the amount of layers needed under these setting is %i with a first height of %f.\nNow inspect the mesh and assess the final quality and result. \nLots of love <3, Manuel',N,H)
