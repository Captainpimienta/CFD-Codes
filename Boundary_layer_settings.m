clc
clear all
%% PHYSICAL PARAMETERS
rho=1.225%input('Enter fluid density in SI units: ');%Fluid density
mu=1.849E-5%input('Enter fluid dynamic viscosity in SI units: ');%Dynamic viscosity
u=15%input('Enter free stream velocity in SI units: ');%Freestream velocity
L=0.6%input('Enter characteristic length in SI units: ');%Characteristic length
%% BOUNDARY LAYER HEIGHT
Re=rho*u*L/mu
if Re>3.5E3*0.9 && Re<3.5E3*1.1
    disp('Transition regime')
    x=input('Choose "Laminar" or "Turbulent": ','s')
    disp(x)
elseif Re>3.5E3
    disp('Turbulent regime')
    x='Turbulent';
else
    disp('Laminar regime')
    x='Laminar';
end

if strcmp('Laminar',x)==1
    a=input('Enter profile (Blasius, Parabolic, Cubic): ','s' );
    if strcmp(a,'Blasius')==1
        d99=4.91*L/sqrt(Re)
        Cf=0.664/sqrt(Re)
    elseif strcmp(a,'Parabolic')==1
        d99=5.48*L/sqrt(Re)
        Cf=0.730/sqrt(Re)
    elseif strcmp(a,'Cubic')==1
        d99=4.64*L/sqrt(Re)
        Cf=0.646/sqrt(Re)
    else
        error('Watch out for capital letters')
    end
elseif strcmp('Turbulent',x)==1
    d99=0.38*L/Re^0.2
    Cf=0.026/Re^(1/7)
else
    error('Watch out for capitals or input errors')
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