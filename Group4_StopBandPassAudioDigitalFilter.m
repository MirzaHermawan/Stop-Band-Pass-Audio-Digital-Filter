% Band Stop Audio Digital Filter Using Finite Response Impulse
% Cutoff frequencies fc1 = 2000 Hz and fc2 = 3100 Hz, using M=150 With Bartlett Windowing Method)
% Signal and System Matlab Project

% Group 4
% Mirza Ananta Hermawan_2206822212
% Farizi Yufli Alrantisi_2206821595
% Arya Fadhlurrahman Mulia_2206822010

clear all;

% Load an audio file in (.wav) format and extract the sample data and sample rate
[sampleAudio, sampleRate] = audioread('MLTRPaintMyLove.wav');
sampleAudio = sampleAudio(:, 1); % Convert the audio file into mono (left channel)
%---------------------------------------------------------------------------------

% Plot the original audio in the time domain (waveform)
figure(1);
plot(sampleAudio);
title('Original Audio Waveform');
xlabel('Time (samples)');
ylabel('Amplitude');
%---------------------------------------------------------------------------------

% Plot the original audio in the frequency domain after performing FFT
N = 1024; % FFT size
frequency = 0:sampleRate/(N/2 - 1):sampleRate;
sampleAudio_fft = fft(sampleAudio, N);
figure(2);
plot(frequency, abs(sampleAudio_fft(1:N/2)) / max(abs(sampleAudio_fft(1:N/2))));
title('Original Audio Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
%------------------------------------------------------------------

% Design a Stop Band Pass filter with cutoff frequencies fc1 = 2000 Hz and fc2 = 3100 Hz, using M=150 and Bartlett windowing
M = 150; % Filter length
fc1 = 2000; % Lower cutoff frequency
fc2 = 3100; % Upper cutoff frequency
FC1 = fc1 / sampleRate; % Normalized lower cutoff frequency
FC2 = fc2 / sampleRate; % Normalized upper cutoff frequency
omega1 = 2 * pi * FC1;
omega2 = 2 * pi * FC2;
n = -75:1:75; % Filter coefficients range
hd = ((2 * FC1 * sinc(n * omega1)) - (2 * FC2 * sinc(n * omega2))); % Filter impulse response
window = 1 - ((2 * abs(n)) / M); % Bartlett window
hn = hd .* window; % Final filter coefficients
hn_fft = fft(hn, N); % Compute FFT of the filter
%----------------------------------------------------------------------------------------------

% Plot the filter frequency response (magnitude)
figure(3);
% Calculate the frequency response of the filter
filter_response = freqz(hn, 1, frequency, sampleRate);
plot(frequency, 20 * log10(abs(filter_response)));
title('Stop Band Filter Frequency Response (Magnitude)');
xlabel('Frequency (Hz)');
ylabel('Gain (dB)');
%---------------------------------------------------------------------------------

% Calculate the phase response of the filter
phase_response = angle(hn_fft(1:1:N/2));
%---------------------------------------------------------------------------------

% Plot the filter frequency response (phase)
figure(4);
plot(frequency, phase_response);
title('Stop Band Pass Filter Frequency Response (Phase)');
xlabel('Frequency (Hz)');
ylabel('Phase (radians)');
%---------------------------------------------------------------------------------

% Apply the filter to the audio using convolution
sampleAudio_filtered = conv(sampleAudio, hn);
%---------------------------------------------------------------------------------

% Plot the filtered audio in the time domain (waveform)
figure(5);
plot(sampleAudio_filtered);
title('Filtered Audio Waveform');
xlabel('Time (samples)');
ylabel('Amplitude');
%---------------------------------------------------------------------------------

% Plot the filtered audio in the frequency domain after performing FFT
sampleAudio_fft_filtered = fft(sampleAudio_filtered, N);
figure(6);
plot(frequency, abs(sampleAudio_fft_filtered(1:1:N/2)) / max(abs(sampleAudio_fft_filtered(1:1:N/2))));
title('Filtered Audio Frequency Spectrum');
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
%---------------------------------------------------------------------------------