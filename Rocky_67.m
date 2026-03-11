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

[t, theta] = load_pendulum_data();

mask = (t >= 5) & (t <= 25) & (theta <= -2);

t_sel = t(mask); t_sel = t_sel   - t_sel(1);
theta_sel = theta(mask);

figure(4);
clf(4);
plot(t_sel, theta_sel, '-b', 'LineWidth', 1)
xlabel('t (s)')
ylabel('theta (radians)')
title('cropped gyro data')
grid on

[pks,locs] = findpeaks(theta_sel, t_sel, 'MinPeakProminence', 0.12);
periods = diff(locs);
periods = periods(isfinite(periods) & periods>0);
omega_d = (2*pi)/mean(periods);

g = 9.81;
L = g / (omega_d^2);

delta = mean(log(pks(1:end-1)./pks(2:end)));
zeta = delta / sqrt(4*pi^2 + delta^2);

omega_n = omega_d / sqrt(1 - zeta^2);

figure(3);
clf(3);
plot(t_sel,theta_sel), hold on
plot(locs, interp1(t_sel,theta_sel,locs), 'ro')
xlabel('Time (s)'), ylabel('Signal'), title(sprintf('Freq ≈ %.3f Hz',omega_d))
grid on, hold off

disp("damped frequency = " + omega_d + " rad/s")
disp("natural frequency = " + omega_n + " rad/s")
disp("length = " + L + " m")
disp("zeta = " + zeta)
%% 
A = pks(1);  % initial amplitude

decay = A*exp(-zeta*omega_n*t_sel);
decay_neg = -decay;

figure(5);
clf(5)

plot(t_sel, theta_sel, 'b', 'LineWidth',1.2); hold on
plot(locs, pks, 'ro')

plot(t_sel, decay, 'k--','LineWidth',1.5)
plot(t_sel, decay_neg, 'k--','LineWidth',1.5)

xlabel('Time (s)')
ylabel('Theta (rad)')
title(sprintf('ω_d = %.3f rad/s,  ζ = %.4f', omega_d, zeta))
grid on
hold off

%% f.
theta_r = 0; % Desired angle

alpha = a; % from motor transfer func
beta = b; % from motor transfer func
omega_n % from pendulum fit
leff = L; % from pendulum fit

Kp = (leff / (alpha * beta)) * (alpha^2 / 3 + omega_n^2); % unitless
Ki = (leff / (alpha * beta)) * (alpha^3 / 27 + alpha * omega_n^2); % unitless

% Defining the square disturbance:
dist_time = 1; % s
dist_duration = .1; % s
dist_magnitude = pi()/18; % rad