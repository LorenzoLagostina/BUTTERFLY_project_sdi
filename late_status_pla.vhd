library ieee;
use ieee.std_logic_1164.all;

entity late_status_pla is

port(
START: in std_logic;		--segnale di start proveniente dall'esterno
no_jmp: in std_logic;		--condition code
lsb: in std_logic;		--bit proveniente dal uIR
lsb_out: out std_logic		--uscita del blocco combinatorio
);
end late_status_pla;


architecture beh of late_status_pla is

component mux_2_1 is
  port(
	x: in std_logic;
	y: in std_logic;
	s: in std_logic;
	m: out std_logic );
end component;

signal jmp:std_logic;

begin

jmp <= start;
jmpMUX: mux_2_1 port map (
	x => jmp, 
	y => lsb, 
	s => no_jmp, 
	m => lsb_out);

end beh;