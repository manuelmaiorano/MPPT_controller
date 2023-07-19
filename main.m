close all 
clc
params;
%lettura mappe, eliminazione dei campioni di corrente negativi
map1 = read_data('data_mod1.txt');
map1 = map1((map1(:, 2) > 0), :);
map2 = read_data('data_mod2.txt');
map2 = map2((map2(:, 2) > 0), :);
map3 = read_data('data_mod3.txt');
map3 = map3((map3(:, 2) > 0), :);

Ts = 5e-5;
t_fin = 0.04;
h = Ts/100;

vout = parameters.V_dc/2;

%valori nominali tensione e potenza
[v1, P1] = find_max_power(map1);
[v2, P2] = find_max_power(map2);

x0 = [0,  0,  0,  0,  0,  0]';
%@(x, t, i) [1-v1/(parameters.V_dc/2), 1-v2/(parameters.V_dc/2)]
%@(x, t, i) controller_wrapper(x, t, i, controller1, controller2)
logger =  Logger(1, 4, 2, t_fin/h);
c = 0.001;

%creazione controllori
controller1 = MPPT_controller(v1, map1(1, 2), 0, c, 1-v1/(parameters.V_dc/2));
controller2 = MPPT_controller(v2, map2(1, 2), 0, c, 1-v2/(parameters.V_dc/2));

[t, x] = simulate(parameters, map1, map2, map3, ...
    @(x, t, i) controller_wrapper(x, t, i, controller1, controller2, logger), Ts, t_fin, h, x0, logger);

function d = controller_wrapper(x, t, i, controller1, controller2, logger)
    %invocazione dei controllori passando tensione e corrente sui moduli e
    %tension in uscita
    [v_rif1, d(1)] = controller1.step(x(1), x(3), i(1));
    [v_rif2, d(2)] = controller2.step(x(2), x(4), i(2));
    logger.add_vrif([v_rif1; v_rif2]);
end

function [t, x] = simulate(parameters, map1, map2, map3, controller, Ts, t_fin, h, x0, logger)
    [t, x] = eulero_forward(@(t, x) model(t, x, parameters, map1, map2, map3, controller, Ts, t_fin, logger), t_fin, h, x0);
end

function [t, x] = eulero_forward(model, t_fin, t_step, x0)
    t = 0:t_step:t_fin;
    x = zeros([numel(x0), size(t, 2)]);
    x(:, 1) = x0;
    for i = 2:size(x, 2)
        %metodo eulero forward
        x(:, i) = x(:, i-1) + t_step * model(i*t_step, x(:, i-1));
    end
end

function dx = model(t, x, parameters, map1, map2, map3, controller, Ts, t_fin, logger)

logger.add_t(t);
logger.add_x(x);
v_Ci1 = x(1);
v_Ci2 = x(2);
v_Co1 = x(3);
v_Co2 = x(4);
i_L1 = x(5);
i_L2 = x(6);

%calcolo correnti tramite interpolazione delle mappe
ipv1 = interpolate(map1, v_Ci1);
if t > t_fin/2
    ipv2 = interpolate(map3, v_Ci2);
else
    ipv2 = interpolate(map2, v_Ci2);
end

Vp = 1;

%calcolo segnali controllo degli switch
d = controller(x, t, [ipv1; ipv2]);logger.add_mod(d);
sig = [pwm(d(1),  t, Ts, Vp); pwm(d(2),  t, Ts, Vp)]; 
logger.add_sig(sig);logger.add_port(Vp*(sawtooth(2*pi*1/Ts*t) + 1)/2);

%calcolo z
M = parameters.Dcp;
q = parameters.Ccp * x + parameters.Fcp * parameters.V_dc + parameters.Hcp * sig;
[z, err] = LEMKE(M, q);logger.add_z(z);

z_D1 = z(1);
z_D2 = z(2);
z_sw1 = z(3);
z_sw2 = z(4);

R_L1 = parameters.R_L1;
R_L2 = parameters.R_L2;
R_Co1 = parameters.R_Co1;
R_Co2 = parameters.R_Co2;
V_dc = parameters.V_dc;
Ci1 = parameters.Ci1;
Ci2 = parameters.Ci2;
Co1 = parameters.Co1;
Co2 = parameters.Co2;
L1 = parameters.L1;
L2 = parameters.L2;

%equazioni del modello
idot_L1=(-R_L1*i_L1 + v_Ci1 - z_sw1)/L1;
idot_L2=(-R_L2*i_L2 + v_Ci2 - z_sw2)/L2;
vdot_Ci1=(ipv1 - i_L1)/Ci1;
vdot_Ci2=(ipv2 - i_L2)/Ci2;
vdot_Co1=(R_Co2*z_D1 - R_Co2*z_D2 + V_dc - v_Co1 - v_Co2)/(Co1*R_Co1 + Co1*R_Co2);
vdot_Co2=(-R_Co1*z_D1 + R_Co1*z_D2 + V_dc - v_Co1 - v_Co2)/(Co2*R_Co1 + Co2*R_Co2);

logger.add_i([ipv1; ipv2]);
dx = [vdot_Ci1, vdot_Ci2, vdot_Co1, vdot_Co2, idot_L1, idot_L2]';
end

function q = pwm(value, t, Ts, Vp)
    %portante
    portante = Vp*(sawtooth(2*pi*1/Ts*t) + 1)/2;
    
    if(value < portante)
        q = 0;
    else   
        q = 1;
    end
end