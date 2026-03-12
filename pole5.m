Kp = 3.5072e+03;
Ki = 1.6528e+04
Ji = -105.9265
Jp = 247.1639
Ci = -2.7313

alpha = a
beta = b
omega_n = 4.6939
leff = l

% Defining the square disturbance:
dist_time = 1; % s
dist_duration = .1; % s
dist_magnitude = pi()/18; % rad

theta_r = 0; % Desired angle


%%

syms s

p1 = -.05 + .01*i   % dominant pole pair
p2 = -.05 -.01*i    % dominant pole pair 
p3 = -4.75
p4 = -26    % dominant pole pair
p5 = -14     % dominant pole pair 


tgt_char_poly = (s-p1)*(s-p2)*(s-p3)*(s-p4)*(s-p5);

asdf = tf()