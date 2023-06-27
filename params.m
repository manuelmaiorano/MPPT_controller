parameters.R_L1 = 0.048;
parameters.R_L2 = 0.048;
parameters.R_Co1 = 0.02;
parameters.R_Co2 = 0.02;
parameters.V_dc = 760;
parameters.Ci1 = 220e-6;
parameters.Ci2 = 220e-6;
parameters.Co1 = 330e-6;
parameters.Co2 = 330e-6;
parameters.L1 = 180e-6;
parameters.L2 = 180e-6;



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
imax_sw1 = 10^10;
imax_sw2 = 10^10;

i_pv = 1;
parameters.Fcp = [
                    [R_Co1/(R_Co1 + R_Co2)],
                    [R_Co2/(R_Co1 + R_Co2)],
                    [                    0],
                    [                    0]
                ];
parameters.Hcp = [
                [        0,        0],
                [        0,        0],
                [ imax_sw1,        0],
                [        0, imax_sw2]
               ];
parameters.Ccp = [
                [0, 0,  R_Co2/(R_Co1 + R_Co2), -R_Co1/(R_Co1 + R_Co2),  0,  0],
                [0, 0, -R_Co2/(R_Co1 + R_Co2),  R_Co1/(R_Co1 + R_Co2),  0,  0],
                [0, 0,                      0,                      0, -1,  0],
                [0, 0,                      0,                      0,  0, -1]
               ];

parameters.Dcp = [
[ R_Co1*R_Co2/(R_Co1 + R_Co2), -R_Co1*R_Co2/(R_Co1 + R_Co2),  -1,   0],
[-R_Co1*R_Co2/(R_Co1 + R_Co2),  R_Co1*R_Co2/(R_Co1 + R_Co2),   0,  -1],
[                           1,                            0,   0,   0],
[                           0,                            1,   0,   0]];





            