B = 100000 ;                % Số bit hoặc ký hiệu
st = rand(B,1)>0.5;          % Tạo tín hiệu nhị phân 0 hoặc 1 với xác suất bằng nhau
[mod, demo] = bpsk();      % Tạo đối tượng modulator và demodulator BPSK (hàm bpsk không được cung cấp)
type = ' BPSK ';             % Loại modulation
s = step(mod,st);            % Modulate tín hiệu đầu vào

Eb_No_dB = -10:30;           % Nhiều giá trị Eb/N0

% Thêm nhiễu, equalization và tính toán lỗi
for i = 1:length(Eb_No_dB)

   n = 1/sqrt(2)*(randn(length(s),1) + randn(length(s),1)); % Nhiễu Gaussian trắng, phương sai 0dB 
   h = 1/sqrt(2)*(randn(length(s),1) + randn(length(s),1)); % Kênh Rayleigh
   % h = 1/sqrt(2)*(randn(1,N)+1i*randn(1,N));
   
   % Thêm nhiễu và kênh vào tín hiệu
   y = h.*s + 10^(-Eb_No_dB(i)/20)*n;
   
   %y = h.*s;
   yHat1 = ones(size(h)) .* y;
   
   % Sử dụng equalization Zero Forcing
   yHat2 = y./h;

   % Sử dụng equalization MMSE
   yHat3 = (conj(h)./((abs(h)).^2+n)).*y;
   
   % Demodulation và đếm số lỗi bit
   op1 = step(demo, yHat1);
   nEr1(i) = size(find((st-op1)),1);
   
   % Số lỗi bit với Zero Forcing equalization
   op2 = step(demo, yHat2);
   nEr2(i) = size(find((st-op2)),1);

   % Số lỗi bit với MMSE equalization
   op3 = step(demo, yHat3);
   nEr3(i) = size(find((st-op3)),1);
end

% Tính tỷ lệ lỗi bit mô phỏng
simBer1 = nEr1/B; 
% Tính tỷ lệ lỗi bit mô phỏng với Zero Forcing equalization
simBer2 = nEr2/B; 
% Tính tỷ lệ lỗi bit mô phỏng với MMSE equalization
simBer3 = nEr3/B; 

% Tính tỷ lệ lỗi bit lý thuyết cho kênh AWGN
BerAWGN = 0.5*erfc(sqrt(10.^(Eb_No_dB/10)));

EbN0Lin = 10.^(Eb_No_dB/10);

% Tính tỷ lệ lỗi bit lý thuyết cho kênh Rayleigh
theoryBer = 0.5.*(1-sqrt(EbN0Lin./(EbN0Lin+1)));

% Vẽ đồ thị kết quả cho từng phương pháp equalization
figure(1);
semilogy(Eb_No_dB,BerAWGN,'b-','LineWidth',2);
hold on
semilogy(Eb_No_dB,theoryBer,'r-','LineWidth',2);
semilogy(Eb_No_dB,simBer1,'k-','LineWidth',2);
axis([-10 30 10^-5 0.5])
grid on
legend('AWGN','Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Tỷ lệ Lỗi Bit');
head = strcat('Tỷ lệ Lỗi Bit cho Modulation', type, 'trong Kênh Rayleigh không sử dụng equalization');
title(head);

figure(2);
semilogy(Eb_No_dB,BerAWGN,'b-','LineWidth',2);
hold on
semilogy(Eb_No_dB,theoryBer,'r-','LineWidth',2);
semilogy(Eb_No_dB,simBer2,'k-','LineWidth',2);
axis([-10 30 10^-5 0.5])
grid on
legend('AWGN','Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Tỷ lệ Lỗi Bit');
head = strcat('Tỷ lệ Lỗi Bit cho Modulation', type, 'trong Kênh Rayleigh sử dụng Zero Forcing');
title(head);

figure(3);
semilogy(Eb_No_dB,BerAWGN,'b-','LineWidth',2);
hold on
semilogy(Eb_No_dB,theoryBer,'r-','LineWidth',2);
semilogy(Eb_No_dB,simBer3,'k-','LineWidth',2);
axis([-10 30 10^-5 0.5])
grid on
legend('AWGN','Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Tỷ lệ Lỗi Bit');
head = strcat('Tỷ lệ Lỗi Bit cho Modulation', type, 'trong Kênh Rayleigh sử dụng MMSE');
title(head);
