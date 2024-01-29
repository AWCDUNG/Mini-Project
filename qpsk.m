function [mod,demo] = qpsk()
mod = comm.QPSKModulator();
mod.BitInput = true;
demo = comm.QPSKDemodulator();
demo.BitOutput = true;
end