%loads and plots the motor calibration data
function [t, y_L, v_L, y_R, v_R] = load_motor_data()
    %path and file name of data
    fpath = 'C:\Users\nbanse\OneDrive - Olin College of Engineering\Desktop\ESA\Rocky_VI-VII\'; %path (change this!)
    fname_in = 'motor_calibration_data.txt'; %file name (change this!)

    %load the motor calibration data
    motor_data = importdata([fpath,fname_in]);

    %unpack the motor calibration data
    t = motor_data(:,1);
    y_L = motor_data(:,2); v_L = motor_data(:,3);
    y_R = motor_data(:,4); v_R = motor_data(:,5);
    
    %plot the motor calibration data
    figure(1);
    clf(1);
    subplot(2,1,1);
    hold on
    plot(t,v_L,'k','linewidth',1);
    plot(t,v_R,'r','linewidth',1);
    xlabel('Time (sec)'); ylabel('Wheel speed (m/sec)');
    title('Motor Calibration Data');
    h1 = legend('Left Wheel','Right Wheel');
    set(h1,'location','southeast');
    subplot(2,1,2);
    hold on
    plot(t,y_L,'k','linewidth',1);
    plot(t,y_R,'r--','linewidth',1);
    xlabel('Time (sec)'); ylabel('Wheel command (-)');
    title('Motor Calibration Data');
    h2 = legend('Left Wheel','Right Wheel');
    set(h2,'location','southeast');
end