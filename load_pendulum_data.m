%loads and plots the pendulum calibration data
function [t, theta] = load_pendulum_data()
    %path and file name of data
    fpath = 'C:\Users\nbanse\OneDrive - Olin College of Engineering\Desktop\ESA\Rocky_VI-VII\'; %path (change this!)
    fname_in = 'pendulum_calibration_data.txt'; %file name (change this!)
    %load the pendulum calibration data
    pendulum_data = importdata([fpath,fname_in]);
    %unpack the pendulum calibration data
    t = pendulum_data(:,1); theta = pendulum_data(:,2);
    %plot the motor calibration data
    % figure(1);
    % hold on
    % plot(t,theta,'k','linewidth',1);
    % xlabel('time (sec)'); ylabel('angle (rad)');
    % title('Pendulum Calibration Data');
end