close all;
figure;
plot(map1(:, 1), map1(:, 2));
hold on; plot(map2(:, 1), map2(:, 2));
legend('caratteristica i-v primo modulo', 'caratteristica i-v secondo modulo');
xlabel('tensione[V]');ylabel('corrente[A]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(map1(:, 1), map1(:, 1).*map1(:, 2));
hold on; plot(map2(:, 1), map2(:, 1).*map2(:, 2));
legend('caratteristica P-v primo modulo', 'caratteristica P-v secondo modulo');
xlabel('tensione[V]');ylabel('Potenza[W]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);


figure;
plot(map2(:, 1), map2(:, 2));
hold on; plot(map3(:, 1), map3(:, 2));
legend('caratteristica i-v iniziale', 'caratteristica i-v finale');
xlabel('tensione[V]');ylabel('corrente[A]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);

figure;
plot(map2(:, 1), map2(:, 1).*map2(:, 2));
hold on; plot(map3(:, 1), map3(:, 1).*map3(:, 2));
legend('caratteristica P-v iniziale', 'caratteristica P-v finale');
xlabel('tensione[V]');ylabel('Potenza[W]');
set (gca,'XMinorTick','on','XMinorGrid','on','YMinorTick','on',...
'YMinorGrid','on','GridLineStyle',':');
grid on; box on; set (gca,'FontSize',11);