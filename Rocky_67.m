%% Rocky Project! :)
%% a.
clear;
disp("--------------------------")
disp("--------------------------")

% Run the load motor data script
[T, y_L, v_L, y_R, v_R] = load_motor_data();

t = T(192:291);
t = t - t(1);
y_L = y_L(192:291);
v_L = v_L(192:291);
y_R = y_R(192:291);
v_R = v_R(192:291);

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
plot(t, v_avg, 'r', 'LineWidth', 1, DisplayName="Average left & right wheel speed (measured)")
plot(t, X_fit, 'b--', 'LineWidth', 1, DisplayName="Wheel speed (fitted)")
xlabel('Time (sec)');
ylabel('Wheel speed (m/sec)');
title(sprintf('Motor fit: α = %.3f rad/s,  β = %.4f', a, b))
% title('Fitting motor parameters');
legend();

disp("Alpha = " + a + " 1/sec");
disp("Beta = " + b + " m/sec");

%% b.

[t, theta] = load_pendulum_data();

mask = (t >= 5) & (t <= 25) & (theta <= -2);

t_sel = t(mask); t_sel = t_sel   - t_sel(1);
theta_sel = theta(mask);

% figure(4);
% clf(4);
% plot(t_sel, theta_sel, '-b', 'LineWidth', 1)
% xlabel('t (s)')
% ylabel('theta (radians)')
% title('cropped gyro data')
% grid on

[pks,locs] = findpeaks(theta_sel, t_sel, 'MinPeakProminence', 0.12);
periods = diff(locs);
periods = periods(isfinite(periods) & periods>0);
omega_n = (2*pi)/mean(periods);

g = 9.81;
L = g / (omega_n^2);

% Fit stuff:
a_g = 0; b_g = 0; c_g = -4;

fit = fit(locs, pks, 'b * exp(-x * a) + c', 'StartPoint', [a_g,b_g, c_g]);

A = fit.a; B = fit.b; C = fit.c;
Z_fit = B * exp(-locs * A) + C;

zeta = A / omega_n;

% figure(3);
% clf(3);
% plot(t_sel,theta_sel), hold on
% plot(locs, interp1(t_sel,theta_sel,locs), 'ro')
% xlabel('Time (s)'), ylabel('Signal'), title(sprintf('Freq ≈ %.3f Hz',omega_n))
% grid on, hold off

disp("natural frequency = " + omega_n + " rad/sec")
disp("length = " + L + " m")
disp("zeta = " + zeta)

figure(3);
clf(3)

plot(t_sel, theta_sel, 'b', 'LineWidth',1.2, DisplayName="Measured Angle"); hold on
plot(locs, pks, 'ro', DisplayName="Peaks")

plot(locs, Z_fit, 'k--','LineWidth',1.5, DisplayName="Fitted Decay Rate")

xlabel('Time (sec)')
ylabel('Theta (rad)')
title(sprintf('Frequency & decay rate fit: ω_n = %.3f rad/s,  ζ = %.4f', omega_n, zeta))
grid on
legend();
hold off

%% f.
theta_r = 0; % Desired angle

alpha = a; % from motor transfer func
beta = b; % from motor transfer func
omega_n; % from pendulum fit
leff = L; % from pendulum fit

Kp = (leff / (alpha * beta)) * (alpha^2 / 3 + omega_n^2); % unitless
Ki = (leff / (alpha * beta)) * (alpha^3 / 27 + alpha * omega_n^2); % unitless

disp("--------------------------")
disp("Kp = " + Kp);
disp("Ki = " + Ki);
disp("--------------------------")

% Defining the square disturbance for Simulink:
dist_time = 1; % s
dist_duration = .1; % s
dist_magnitude = pi()/90; % rad
