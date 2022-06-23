vlib work

vcom packageBF.vhd
vcom Adder.vhd
vcom approx.vhd
vcom Butterfly.vhd
vcom Butterfly16x16.vhd
vcom butterflyDatapath.vhd
vcom cu.vhd
vcom FF.vhd
vcom gen_mux_2_1.vhd
vcom late_status_pla.vhd
vcom moltiplicatore.vhd
vcom mux_2_1.vhd
vcom mux2to1.vhd
vcom n_bit_register.vhd
vcom registerFF.vhd
vcom RegisterFile.vhd
vcom sommatore.vhd
vcom tbButterfly16x16.vhd
vcom uAR.vhd
vcom uIR.vhd
vcom uROM.vhd


vsim -c work.tbButterfly16x16

#add list -decimal clk -notrigger a b c cout sum

run 0ns
run 10us

#write list counter.lst
quit -f
