% Load the ECG signal
filepath = 'E:\6th Semester\Digital Signal Processing\project\ptb-xl-a-large-publicly-available-electrocardiography-dataset-1.0.3\records100\00000\00_lr.dat';
fid = fopen(filepath, 'r');
ecg_data = fread(fid, Inf, 'int16');
fclose(fid);

% Convert the data to double for better numerical precision
ecg_data = double(ecg_data);

% Assuming the sampling rate is 360 Hz (a common sampling rate for ECG data)
samplingRate = 360;

% Normalize the frequencies to the range of 0 to 1
normalizedLowFreq = lowFreq / (samplingRate / 2); % Normalize to Nyquist frequency
normalizedHighFreq = highFreq / (samplingRate / 2); % Normalize to Nyquist frequency

% Design the bandpass filter
bpFilter = designfilt('bandpassiir','FilterOrder',4,'HalfPowerFrequency1',normalizedLowFreq,'HalfPowerFrequency2',normalizedHighFreq);

% Apply the filter to the ECG data using filtfilt for zero-phase filtering
filtered_ecg_data = filtfilt(bpFilter, ecg_data);

% Plot the original and filtered ECG data using subplot
figure;
subplot(2,1,1);
plot(ecg_data);
title('Original ECG Data');
xlabel('Sample Index');
ylabel('Amplitude');

subplot(2,1,2);
plot(filtered_ecg_data);
title('Filtered ECG Data');
xlabel('Sample Index');
ylabel('Amplitude');
