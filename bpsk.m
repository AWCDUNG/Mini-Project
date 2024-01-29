function [mod,demo] = bpsk()
mod = comm.BPSKModulator();
demo = comm.BPSKDemodulator();
end
