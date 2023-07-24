function dx = model_fast(t, x, parameters, map1, map2, map3, controller, Ts, t_fin, logger)

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
vdot_Ci1=(ipv1 - i_L1)/Ci1;
vdot_Ci2=(ipv2 - i_L2)/Ci2;

if sig(1) == 0 && sig(2) == 0
idot_L1=(-R_Co1*R_Co2*i_L1 + R_Co1*R_Co2*i_L2 - R_Co1*R_L1*i_L1 - R_Co1*V_dc + R_Co1*v_Ci1 + R_Co1*v_Co2 - R_Co2*R_L1*i_L1 + R_Co2*v_Ci1 - R_Co2*v_Co1)/(L1*R_Co1 + L1*R_Co2);
idot_L2=(R_Co1*R_Co2*i_L1 - R_Co1*R_Co2*i_L2 - R_Co1*R_L2*i_L2 + R_Co1*v_Ci2 - R_Co1*v_Co2 - R_Co2*R_L2*i_L2 - R_Co2*V_dc + R_Co2*v_Ci2 + R_Co2*v_Co1)/(L2*R_Co1 + L2*R_Co2); 
vdot_Co1=(R_Co2*i_L1 - R_Co2*i_L2 + V_dc - v_Co1 - v_Co2)/(Co1*R_Co1 + Co1*R_Co2);
vdot_Co2=(-R_Co1*i_L1 + R_Co1*i_L2 + V_dc - v_Co1 - v_Co2)/(Co2*R_Co1 + Co2*R_Co2);
elseif sig(1) == 0 && sig(2) == 1
idot_L1=(-R_Co1*R_Co2*i_L1 - R_Co1*R_L1*i_L1 - R_Co1*V_dc + R_Co1*v_Ci1 + R_Co1*v_Co2 - R_Co2*R_L1*i_L1 + R_Co2*v_Ci1 - R_Co2*v_Co1)/(L1*R_Co1 + L1*R_Co2);
idot_L2=(-R_L2*i_L2 + v_Ci2)/L2;
vdot_Co1=(R_Co2*i_L1 + V_dc - v_Co1 - v_Co2)/(Co1*R_Co1 + Co1*R_Co2);
vdot_Co2=(-R_Co1*i_L1 + V_dc - v_Co1 - v_Co2)/(Co2*R_Co1 + Co2*R_Co2);
elseif sig(1) == 1 && sig(2) == 0
idot_L1=(-R_L1*i_L1 + v_Ci1)/L1;
idot_L2=(-R_Co1*R_Co2*i_L2 - R_Co1*R_L2*i_L2 + R_Co1*v_Ci2 - R_Co1*v_Co2 - R_Co2*R_L2*i_L2 - R_Co2*V_dc + R_Co2*v_Ci2 + R_Co2*v_Co1)/(L2*R_Co1 + L2*R_Co2);
vdot_Co1=(-R_Co2*i_L2 + V_dc - v_Co1 - v_Co2)/(Co1*R_Co1 + Co1*R_Co2);
vdot_Co2=(R_Co1*i_L2 + V_dc - v_Co1 - v_Co2)/(Co2*R_Co1 + Co2*R_Co2);
else
idot_L1=(-R_L1*i_L1 + v_Ci1)/L1;
idot_L2=(-R_L2*i_L2 + v_Ci2)/L2;
vdot_Co1=(V_dc - v_Co1 - v_Co2)/(Co1*R_Co1 + Co1*R_Co2);
vdot_Co2=(V_dc - v_Co1 - v_Co2)/(Co2*R_Co1 + Co2*R_Co2);
end

if i_L1 < 0 && sig(1) == 0
    idot_L1 = 0;
end
if i_L2 < 0 && sig(2) == 0
    idot_L2 = 0;
end

logger.add_i([ipv1; ipv2]);
dx = [vdot_Ci1, vdot_Ci2, vdot_Co1, vdot_Co2, idot_L1, idot_L2]';
end

