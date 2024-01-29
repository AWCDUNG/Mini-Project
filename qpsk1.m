B = 100000;    % số lượng bit hoặc ký tự
st = rand(B,1) > 0.5;  % tạo chuỗi 0,1 với xác suất bằng nhau
[mod, demo] = qpsk(); % tạo đối tượng QPSK modulation và demodulation
type = ' QPSK ';
s = step(mod, st);

Eb_No_dB = -10:30; % nhiều giá trị Eb/N0

% Thêm nhiễu, cân bằng và tính lỗi
for i = 1:length(Eb_No_dB)

   n = 1/sqrt(2) * (randn(length(s),1) + randn(length(s),1)); % nhiễu Gaussian trắng, phương sai 0dB 
   h = 1/sqrt(2) * (randn(length(s),1) + randn(length(s),1)); % kênh Rayleigh
   % h = 1/sqrt(2) * (randn(1,N) + 1i * randn(1,N));
   % Thêm nhiễu và kênh
   y = h .* s + 10^(-Eb_No_dB(i)/20) * n;
   %y = h .* s;
   yHat1 = ones(size(h)) .* y;
   % Sử dụng cân bằng Zero Forcing
   yHat2 = y ./ h;
   % Sử dụng cân bằng MMSE
   yHat3 = (conj(h) ./ ((abs(h)).^2 + n)) .* y;
   op1 = step(demo, yHat1);
   % Đầu ra với cân bằng Zero Forcing 
   op2 = step(demo, yHat2);
   % Đầu ra với cân bằng MMSE
   op3 = step(demo, yHat3);

   nEr1(i) = size(find((st - op1)),1);
   % Số lỗi bit với Zero Forcing equalization
   nEr2(i) = size(find((st - op2)),1);
   % Số lỗi bit với MMSE equalization
   nEr3(i) = size(find((st - op3)),1);
end

sBer1 = nEr1 / B; 
% BER mô phỏng với Zero Forcing equalization
sBer2 = nEr2 / B; 
% BER mô phỏng với MMSE equalization
sBer3 = nEr3 / B; 

BerAWGN = 0.5 * erfc(sqrt(10.^(Eb_No_dB/10)));

EbN0Lin = 10.^(Eb_No_dB/10);

% theoryBer trong kênh Rayleigh
theoryBer = 0.5 * (1 - sqrt(EbN0Lin ./ (EbN0Lin + 1)));
figure(1);
semilogy(Eb_No_dB, BerAWGN, 'b-', 'LineWidth', 2);
hold on
semilogy(Eb_No_dB, theoryBer, 'r-', 'LineWidth', 2);
semilogy(Eb_No_dB, sBer1, 'k-', 'LineWidth', 2);
axis([-10 30 10^-5 0.5])
grid on
legend('AWGN', 'Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
head = strcat('BER cho', type, 'modulation trong kênh Rayleigh không sử dụng cân bằng');
title(head);

figure(2);
semilogy(Eb_No_dB, BerAWGN, 'b-', 'LineWidth', 2);
hold on
semilogy(Eb_No_dB, theoryBer, 'r-', 'LineWidth', 2);
semilogy(Eb_No_dB, sBer2, 'k-', 'LineWidth', 2);
axis([-10 30 10^-5 0.5])
grid on
legend('AWGN', 'Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
head = strcat('BER cho', type, 'modulation trong kênh Rayleigh sử dụng Zero Forcing');
title(head);

figure(3);
semilogy(Eb_No_dB, BerAWGN, 'b-', 'LineWidth', 2);
hold on
semilogy(Eb_No_dB, theoryBer, 'r-', 'LineWidth', 2);
semilogy(Eb_No_dB, sBer3, 'k-', 'LineWidth', 2);
axis([-10 30 10^-5 0.5])
grid on
legend('AWGN', 'Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
head = strcat('BER cho', type, 'modulation trong kênh Rayleigh sử dụng MMSE');
title(head);
