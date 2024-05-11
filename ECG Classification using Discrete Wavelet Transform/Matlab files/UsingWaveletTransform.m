% Load the ECG signal
filepath = 'E:\6th Semester\Digital Signal Processing\project\ptb-xl-a-large-publicly-available-electrocardiography-dataset-1.0.3\records100\04000\04724_lr.dat';

% Open the file
fid = fopen(filepath, 'r');

% Read the data as int16
ecg_data = fread(fid, Inf, 'int16');

% Close the file
fclose(fid);

% Sampling Rate (Hz)
Fs = 1000; 

% Normalize gain
ecgsig = ecg_data ./ 200;

% Time vector
t = (0:length(ecgsig)-1) / Fs;

% 4-level undecimated DWT using sym4
wt = modwt(ecgsig, 4, 'sym4');
wtrec = zeros(size(wt));
wtrec(3:4, :) = wt(3:4, :); % Extracting only d3 and d4 coefficients

% IDWT with only d3 and d4
y = imodwt(wtrec, 'sym4');
y = abs(y).^2; % Magnitude square
avg = mean(y); % Getting average of y^2 as threshold

% Finding Peaks
[Rpeaks, locs] = findpeaks(y, t, 'MinPeakHeight', 8 * avg, 'MinPeakDistance', 0.4); % Adjusted MinPeakDistance for 100 Hz

% No. of beats
nohb = length(locs);
timelimit = length(ecgsig) / Fs;
hbpermin = (nohb * 60) / timelimit; % Getting BPM
disp(['Heart Rate=', num2str(hbpermin)])

% Displaying ECG signal and detected R-Peaks
subplot(2,1,1)
plot(t, ecgsig);
xlim([0, timelimit]);
grid on;
xlabel('Seconds')
title('ECG Signal')

subplot(2,1,2)
plot(t, y)
grid on;
xlim([0, length(ecgsig)/Fs]);
hold on
plot(locs, Rpeaks, 'ro')
xlabel('Seconds')
title(['R Peaks found and Heart Rate: ', num2str(hbpermin)])

% Calculate time difference between adjacent peaks
RR_intervals = diff(locs);

% Calculate standard deviation of RR intervals
RR_std = std(RR_intervals);

% Define threshold for arrhythmia detection
threshold = 0.06; % Adjust as needed

% Check for arrhythmia
if RR_std > threshold
    disp('Arrhythmia detected!');
    disp(['Standard deviation of RR intervals: ', num2str(RR_std)]);
else
    disp('No arrhythmia detected.');
        disp(['Standard deviation of RR intervals: ', num2str(RR_std)]);

end
