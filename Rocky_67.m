%% Rocky Project! :)
%% a.
clear;

% Run the load motor data script
[t, y_L, v_L, y_R, v_R] = load_motor_data();

t = t(101:200);
t = t - t(1);
y_L = y_L(101:200);
v_L = v_L(101:200);
y_R = y_R(101:200);
v_R = v_R(101:200);

% Calculate average wheel speed and command
v_avg = (v_L + v_R) / 2;
y_avg = (y_L + y_R) / 2;

% Fit stuff:
a_g = 26; b_g = 0.003;

f_params = fit(t,v_avg,'300 * b * (1 - exp(-x * a))','StartPoint',[a_g,b_g]);

a = f_params.a; b = f_params.b;
X_fit = 300 * b * (1 - exp(-t * a));

figure(2);
clf(2);
hold on
plot(t, v_avg, 'r', 'LineWidth', 1, DisplayName="Measured Data")
plot(t, X_fit, 'b--', 'LineWidth', 1, DisplayName="Fitted Curve")
xlabel('time (sec)');
ylabel('wheel speed (m/sec)');
title('Motor Calibration Data');
legend();

disp("Alpha = " + a + " 1/s");
disp("Beta = " + b + " m/s PLS DOUBLE CHECK UNITS LATER");

%% b.

