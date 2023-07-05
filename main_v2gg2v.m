tic
clear all; close all;

%% Select the simulation case by uncommenting only one of the sim_case
% Available sim_case options:
% 1. 'NoV2GG2V'         : IEEE-3 bus grid without any V2G/G2V connected
% 2. 'V2G_Gajduk'       : V2G mode with Gajduk's local frequency control
% 3. 'V2G_FDCC'         : V2G mode with RMS fault detection (FD) and
%                         battery constant current (CC) control
% 4. 'G2V'              : G2V mode with constant battery current

% sim_case = 'NoV2GG2V'
sim_case = 'V2G_Gajduk' 
% sim_case = 'V2G_FDCC'
% sim_case = 'G2V'

%% Select which bus (active_bus) will have their V2G/G2V system activated
% active_bus = 1
% active_bus = 2
active_bus = 3
% active_bus = [1,2,3]

%% Select which bus (plot_bus) will have their V2G/G2V states plotted
plot_bus = active_bus % default
% plot_bus = 1
% plot_bus = 2
% plot_bus = 3

%% Choose the fault location (fault_loc) x_y-z where:
% x: location of the fault at bus x
% y-z: location of the fault between transmission line bus y-z
all_faults = {'1_1-2','1_1-3','2_1-2','2_2-3','3_1-3','3_2-3'}; % don't comment this
fault_loc = '1_1-2'
% fault_loc = '2_1-2'

%% Pre-tuned Options
switch fault_loc
    case '1_1-2'
        switch sim_case
            case 'NoV2GG2V'
                % Fault Clearing Time (FCT) (seconds)
                FCT = 0.241 % (stable FCT=CCT)
%                 FCT = 0.242 % (unstable FCT>CCT, starts to deviate)
            case 'V2G_Gajduk'
                h_PEV = -2000
                if active_bus == 1
                    FCT = 0.184 % stable
%                     FCT = 0.185 % unstable
                end
                if active_bus == 2
                    FCT = 0.242 % stable
%                     FCT = 0.243 % unstable
                end
                if active_bus == 3
                    FCT = 0.242 % stable
                    FCT = 0.243 % unstable
                end
                if active_bus == [1, 2, 3]
                    FCT = 0.243 % stable
%                     FCT = 0.244 % unstable
                end
            case 'V2G_FDCC'
                Ibatfault_ref = 200 %100
                Vfault_thresh = 455
                if active_bus == 1
                    FCT = 0.238 % stable
%                     FCT = 0.239 % unstable
                end
                if active_bus == 2
                    FCT = 0.250 % stable
%                     FCT = 0.251 % unstable
                end
                if active_bus == 3
                    FCT = 0.250 % stable
%                     FCT = 0.251 % unstable
                end
                if active_bus == [1, 2, 3]
                    FCT = 0.241 % stable
%                     FCT = 0.242 % unstable
%                     FCT = 0.243 % unstable
                end
            case 'G2V'
                % Battery current reference (A)
                Ibat_ref    = -200;
                if active_bus == 1
                    FCT = 0.082 % stable
%                     FCT = 0.083 % unstable
                end
                if active_bus == 2
                    FCT = 0.238 % stable
%                     FCT = 0.239 % unstable
                end
                if active_bus == 3
                    FCT = 0.238 % stable
%                     FCT = 0.239 % unstable
                end
                if active_bus == [1, 2, 3]
                    FCT = 0.083 % stable
%                      FCT = 0.084 % unstable
                end
        end
    case '2_1-2'
        switch sim_case
            case 'NoV2GG2V'
                FCT = 0.222 % stable
%                 FCT = 0.223 % unstable
            case 'V2G_FDCC'
                Ibatfault_ref = 200 %100
                Vfault_thresh = 455
                if active_bus == 1
                    FCT = 0.223 % stable
%                     FCT = 0.224 % unstable
                end
                if active_bus == 2
                    FCT = 0.223 % stable
%                     FCT = 0.224 % unstable
                end
                if active_bus == 3
                    FCT = 0.223 % stable
%                     FCT = 0.224 % unstable
                end
        end
    otherwise
        disp('No simulation case and fault location selected');
end

% Simulation sampling period (seconds)
Ts = 1e-5 % 2e-6

%% Grid Parameters
Sbase = 1e6;            % Base nominal power (VA)
Vbase = 345e3;          % Base grid voltage (V)
f_grid  = 50;           % Nominal grid frequency (Hz)
omega   = 2*pi*f_grid;  % Nominal grid angular speed (rad/s)

% Input mechanical power (p.u.)
Pm1 = 2.49;
Pm2 = 4.21;
Pm3 = 8.20;

% Generator mechanical parameters
H1 = 10;
H2 = 15;
H3 = 60;
D = 20;

% Internal voltage (p.u.)
% (obtained from running case3.m of https://github.com/gajduk/vehicle2grid-stability-analysis)
E1 = 1.07364213042869;
E2 = 1.05726676017896;
E3 = 1.05298913370226;

% RL load power demand at i-th bus (p.u.)
S1pu = (1.5 + .45j);
S2pu = (1.0 + .3j);
S3pu = (12.4 + 2.5j);

% Transmission line reactance (p.u.)
Z12pu = .46j;
Z13pu = .26j;
Z23pu = .0806j;

% per unit (pu) to standard unit (SI)
Zbase = Vbase^2/Sbase;
[R12, L12] = puToSI(Z12pu, Zbase, f_grid);
[R13, L13] = puToSI(Z13pu, Zbase, f_grid);
[R23, L23] = puToSI(Z23pu, Zbase, f_grid);

%% V2GG2V Params
% Grid & LCL filter
Snom_trafo = 1050e6;    % transformer nominal power (VA)
Linv    = 1/10*0.48e-3; %(Henry)   
Lgrid   = 1/10*0.69e-3; %(Henry)
Rd      = 1.31;         %(Ohm)
Cf      = 10*165e-6;    %(Farad)

% Inverter
C_Vdc   = 100*18e-3;    %(Farad)
V0_Vdc  = 1.5e3;        %(Volt)

% Buck-Boost Converter 
Lbat = 2e-3;            %(Henry)

% Battery
Batt_Vnom       = 400;  %(Volt)
Batt_Ah         = 35;   %(Ah)
Batt_InitSOC    = 80;   %(%)
Batt_RespTime   = 2;    %(seconds) 

% Phase Locked Loop (PLL)
Kp_PLL = 100;
Ki_PLL = 10000;

% PWM Control Switching Frequency
f_SW = 5000; %(Hz)

% DC Link Voltage Control
Vdc_ref = 1.5e3; %(Volt)
Kp_outer = 250;
Ki_outer = 10000; 
Kp_inner = 100;
Ki_inner = 5000;

% Battery Current Control
Kp_CC       = 10;
Ki_CC       = 1;
UpSat_CC    = 1;
LowSat_CC   = 0;

%% Main Loader
if(~bdIsLoaded(sim_case))
    open_system(sim_case, 'window');
end

for i = 1:3
    % Set which V2G-G2V bus is active
    if (~strcmp(sim_case,'NoV2GG2V'))
        if (find(active_bus == i))
            set_param([sim_case '/V2G-G2V-' int2str(i)],'commented','off');
        else
            set_param([sim_case '/V2G-G2V-' int2str(i)],'commented','on');
        end
    end
    
    % Set the fault location
    for i = 1:numel(all_faults)
        if (fault_loc == all_faults{i})
            set_param([sim_case '/Three-PhaseFault' fault_loc],'commented','off');
        else
            set_param([sim_case '/Three-PhaseFault' all_faults{i}],'commented','on');
        end
    end
end

%% Fault starting & clearing time (seconds)
t_fault_start = 0.5;
t_fault_end   = t_fault_start + FCT;

%% Run Simulink model & plot figures 
sim([sim_case '.slx']); 

if (~strcmp(sim_case,'NoV2GG2V'))
    for i = 1:3
        if (find(plot_bus == i) & find(active_bus == i))
            switch sim_case
                case 'V2G_Gajduk'
                    fig_control{i} = eval(['plot_controlGajduk(controlGajduk' int2str(i) ')']);
                case 'V2G_FDCC'
                    fig_control{i} = eval(['plot_controlFault(controlFault' int2str(i) ', Vfault_thresh)']);
            end
            fig_batt_VDC{i}     = eval(['plot_battery_VDC(battery' int2str(i) ', dc_voltage' int2str(i) ')']);
            fig_grid_VI{i}      = eval(['plot_grid_VI(grid_VI' int2str(i) ')']);
            fig_grid_power{i}   = eval(['plot_grid_power(grid_power' int2str(i) ')']);    
        end
    end
end

figure();
plot(generator_1.Rotor_angle_theta__rad_.Time, generator_1.Rotor_angle_theta__rad_.Data, 'LineWidth', 2);
hold on;
plot(generator_2.Rotor_angle_theta__rad_.Time, generator_2.Rotor_angle_theta__rad_.Data, 'LineWidth', 2);
hold on;
plot(generator_3.Rotor_angle_theta__rad_.Time, generator_3.Rotor_angle_theta__rad_.Data, 'LineWidth', 2);
legend('\delta_1','\delta_2','\delta_3','Location','southeast');
xlabel('Time (seconds)');
ylabel('Rotor Angle \delta (radians)');
title("Generator Rotor Angles with FCT = "+FCT+" seconds");
grid on;

figure();
plot(generator_1.Rotor_speed_wm__pu_.Time, generator_1.Rotor_speed_wm__pu_.Data,'LineWidth', 2);
hold on;
plot(generator_2.Rotor_speed_wm__pu_.Time, generator_2.Rotor_speed_wm__pu_.Data,'LineWidth', 2);
hold on;
plot(generator_3.Rotor_speed_wm__pu_.Time, generator_3.Rotor_speed_wm__pu_.Data,'LineWidth', 2);
legend('\omega_1','\omega_2','\omega_3','Location','southeast');
xlabel('Time (seconds)');
ylabel('Rotor Speed \omega (per unit)');
title("Generator Rotor Speeds with FCT = "+FCT+" seconds");
grid on;

toc
