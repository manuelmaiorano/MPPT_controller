
params;
map1 = read_data('data.txt');
map2 = read_data('data1.txt');
Ts = 5e-5;
t_fin = 0.01;
h = Ts/100;
[v1, P1] = find_max_power(map1);
[v2, P2] = find_max_power(map2);
x0 = [0,  0,  0,  0,  0,  0]';
%@(x) [1-v1/(parameters.V_dc/2), 1-v2/(parameters.V_dc/2)]
logger =  Logger(1, 4, 2, t_fin/h);
c = 0.001;
controller1 = MPPT_controller(map1, v1-7, 0, c);
controller2 = MPPT_controller(map2, v2-7, 0, c);
vout = parameters.V_dc/2;
[t, x] = simulate(parameters, map1, map2, @(x) [controller1.step(x(1), vout), controller2.step(x(2), vout)], Ts, t_fin, h, x0, logger);


function [t, x] = simulate(parameters, map1, map2, controller, Ts, t_fin, h, x0, logger)
    %options = odeset('Stats','on','OutputFcn',@myodeplot, 'MaxStep',Ts/100);
    %[t, x] = ode45(@(t, x) model(t, x, parameters, map1, map2, controller, Ts, logger), [0, t_fin], x0, options);
    [t, x] = eulero_forward(@(t, x) model(t, x, parameters, map1, map2, controller, Ts, logger), t_fin, h, x0);
end

function [t, x] = eulero_forward(model, t_fin, t_step, x0)
    t = 0:t_step:t_fin;
    x = zeros([numel(x0), size(t, 2)]);
    x(:, 1) = x0;
    for i = 2:size(x, 2)
        x(:, i) = x(:, i-1) + t_step * model(i*t_step, x(:, i-1));
    end
end

function dx = model(t, x, parameters, map1, map2, controller, Ts, logger)

logger.add_t(t);
logger.add_x(x);
v_Ci1 = x(1);
v_Ci2 = x(2);
v_Co1 = x(3);
v_Co2 = x(4);
i_L1 = x(5);
i_L2 = x(6);

Vp = 1;

M = parameters.Dcp;

d = controller(x);
sig = [pwm(d(1),  t, Ts, Vp); pwm(d(2),  t, Ts, Vp)]; logger.add_sig(sig);logger.add_port(Vp*(sawtooth(2*pi*1/Ts*t) + 1)/2);
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

idot_L1=(-R_L1*i_L1 + v_Ci1 - z_sw1)/L1;
idot_L2=(-R_L2*i_L2 + v_Ci2 - z_sw2)/L2;
vdot_Ci1=(interpolate(map1, v_Ci1) - i_L1)/Ci1;
vdot_Ci2=(interpolate(map2, v_Ci2) - i_L2)/Ci2;
vdot_Co1=(R_Co2*z_D1 - R_Co2*z_D2 + V_dc - v_Co1 - v_Co2)/(Co1*R_Co1 + Co1*R_Co2);
vdot_Co2=(-R_Co1*z_D1 + R_Co1*z_D2 + V_dc - v_Co1 - v_Co2)/(Co2*R_Co1 + Co2*R_Co2);

logger.add_i([interpolate(map1, v_Ci1); interpolate(map2, v_Ci2)]);
dx = [vdot_Ci1, vdot_Ci2, vdot_Co1, vdot_Co2, idot_L1, idot_L2]';
end

function q = pwm(value, t, Ts, Vp)
    portante = Vp*(sawtooth(2*pi*1/Ts*t) + 1)/2;
    
    if(value < portante)
        q = 0;
    else   
        q = 1;
    end
end