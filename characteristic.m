%% Solar electrical model based on Shockley diode equation
clear all
clc
Va=0:.01:50;
Suns=.2:.2:1;
TaC=30;
Ipv=zeros(size(Va));
Ppv=zeros(size(Va));
for s=1:1:length(Suns)
for i=1:1:length(Va)
k=1.38e-23;
q=1.6e-19;
A=1.2;
Vg=1.12;
Ns=36;
T1=273+25;
Voc_T1=21.06/Ns;Voc_T1=37.3/Ns;
Isc_T1=3.80;Isc_T1=8.16;
T2=273+75;
Voc_T2=17.05/Ns;Voc_T2=37.3/Ns;
Isc_T2=3.92;Isc_T2=8.16;
TarK=273+TaC;
Tref=273+25;
%{
Va=0;
Iph_T1=Isc_T1;
%}
Iph_T1=Isc_T1*Suns(s);
a=(Isc_T2-Isc_T1)/Isc_T1*1/(T2-T1);
Iph=Iph_T1*(1+a*(TarK-T1));
Vt_T1=k*T1/q;
Ir_T1=Isc_T1/(exp(Voc_T1/(A*Vt_T1))-1);
Ir_T2=Isc_T2/(exp(Voc_T2/(A*Vt_T1))-1);
b=Vg*q/(A*k);
Ir=Ir_T1*(TarK/T1).^(3/A).*exp(-b.*(1./TarK-1/T1));
X2v=Ir_T1/(A*Vt_T1)*exp(Voc_T1/(A*Vt_T1));
dVdI_Voc=-1.15/Ns/2;
Rs=-dVdI_Voc-1/X2v;
%Ia=1:0.01:Iph;
Vt_Ta=A*k*TarK/q;
%{
Ia1=Iph-Ir*(exp((Vc+Ia*Rs)/Vt_Ta)-1));
solve for I: f(Ia)=Iph-Ia-Ir*(exp((Vc+Ia*Rs)/Vt_Ta)-1))=0;
Newton raphson Ia2=Ias1-f(Ia1)/f'(Ia1)
%}
Vc=Va(i)/Ns;
Ia=zeros(size(Vc));
%Iav=Ia
for j=1:1:10
    Ia=Ia-(Iph-Ia-Ir*(exp((Vc+Ia*Rs)/Vt_Ta)-1))./(-1-Ir*(exp((Vc+Ia*Rs)/Vt_Ta)-1).*Rs/Vt_Ta);
end
Ipv(s,i)=Ia;
Ppv(s,i)=Va(i)*Ipv(s,i);
end
end
%% figure properties
axes1 = axes('Parent',figure,'OuterPosition',[0 0.5 1 0.5]);
 xlim(axes1,[0 23]);
 ylim(axes1,[0 5]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');
title('I-V charateristics at 25 C');
xlabel('V_p_v (V)');
ylabel('I_p_v (A)');
plot1 = plot(Va(1,:),Ipv(:,:),'Parent',axes1,'LineWidth',1.5);
set(plot1(1),'DisplayName','0.2 Sun');
set(plot1(2),'DisplayName','0.4 Sun');
set(plot1(3),'DisplayName','0.6 Sun');
set(plot1(4),'DisplayName','0.8 Sun');
set(plot1(5),'DisplayName','1.0 Sun');
axes2 = axes('OuterPosition',[0 0 1 0.5]);
 xlim(axes2,[0 23]);
 ylim(axes2,[0 70]);
box(axes2,'on');
grid(axes2,'on');
hold(axes2,'all');
title('P-V charateristics at 25 C');
xlabel('V_p_v (V)');
ylabel('P_p_v (W)');
plot2 = plot(Va(1,:),Ppv(:,:),'Parent',axes2,'LineWidth',1.5);
set(plot2(1),'DisplayName','0.2 Sun');
set(plot2(2),'DisplayName','0.4 Sun');
set(plot2(3),'DisplayName','0.6 Sun');
set(plot2(4),'DisplayName','0.8 Sun');
set(plot2(5),'DisplayName','1.0 Sun');
 legend1 = legend(axes1,'show');
 set(legend1,...
     'Position',[0.791450219003363 0.769901214241614 0.0793528505392912 0.151937984496124]);
 legend2 = legend(axes2,'show');
 set(legend2,...
     'Position',[0.189976911157747 0.248883515126569 0.0793528505392912 0.151937984496124]);
annotation('textbox',...
    [0.47380281690141 0.811076083153806 0.107858243451464 0.0434108527131783],...
    'String',{'2.8462 A @16.58 V'},...
    'EdgeColor','none');
annotation('textbox',...
    [0.474084507042255 0.7513476657742 0.110939907550077 0.0434108527131783],...
    'String',{'2.1355 A @ 16.45 V'},...
    'EdgeColor','none');
annotation('textbox',...
    [0.472951770026098 0.700468805916718 0.110939907550077 0.0434108527131783],...
    'String',{'1.4231 A @ 16.20 V'},...
    'EdgeColor','none');
annotation('textbox',...
    [0.47323943661972 0.642464055322894 0.110939907550077 0.0434108527131783],...
    'String',{'0.7106 A @ 15.64 V'},...
    'EdgeColor','none');
annotation('textbox',...
    [0.635833014827347 0.0980360187780262 0.122362869198312 0.066350710900474],...
    'String',{'11.1135 W'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation('textbox',...
    [0.632873485499481 0.379556028485233 0.120599829638874 0.066350710900474],...
    'String',{'59.1673 W'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation('textbox',...
    [0.633492332194277 0.307167067364569 0.118572532239852 0.0663507109004739],...
    'String',{'47.1894 W'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation('textbox',...
    [0.632395285780775 0.238358964716038 0.122362869198312 0.066350710900474],...
    'String',{'35.1283 W'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation('textbox',...
    [0.634117121719049 0.167164307824055 0.122362869198312 0.066350710900474],...
    'String',{'23.0538 W'},...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation('textbox',...
    [0.480299619499175 0.859929518844724 0.184507042253521 0.0665083135391924],...
    'String',{'3.5557 A @16.64 V'},...
    'FitBoxToText','off',...
    'EdgeColor','none');