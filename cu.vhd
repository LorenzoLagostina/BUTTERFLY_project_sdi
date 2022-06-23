library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cu is
port(
	reset: in std_logic;		--segnale di reset proveniente dall'esterno. Resetta la macchina in qualsiasi momento
	start: in std_logic;		--segnale di start dall'esterno
	clock: in std_logic;		--segnale di clock

	toDatapath: out std_logic_vector(15 downto 0); 		--segnali da inviare ai blocchi del Datapath
	done : out std_logic					--segnale di done per indicare la fine dell'algoritmo
);
end entity cu;


architecture beh of cu is

component gen_mux_2_1 is
  generic(n: positive); 
     port(
	xs: in std_logic_vector(n-1 downto 0);
	ys: in std_logic_vector(n-1 downto 0);  
	sl: in std_logic;
	ms: out std_logic_vector(n-1 downto 0));
end component;


component mux_2_1 is
  port(
	x: in std_logic;
	y: in std_logic;
	s: in std_logic;
	m: out std_logic );
end component;

component uIR is
generic (N : positive);
port (
	data_in: in std_logic_vector (N-1 downto 0);
	CLK: in std_logic;
	load: in std_logic; 
	clear: in std_logic;
	data_out: out std_logic_vector (N -1 downto 0)
);

end component;

component uAR is 
generic (n: positive);
port (
	dataIn: in std_logic_vector(n - 1 downto 0);
	CLK: in std_logic;
	reset: in std_logic; 
	enable: in std_logic;
	dataOut: out std_logic_vector(n - 1 downto 0)
);
end  component;


component uROM is
port (
	add: in std_logic_vector(3 downto 0);
	evenOutput,oddOutput: out std_logic_vector(22 downto 0)
);
end  component;

component late_status_pla is
port(
START: in std_logic;		--segnale di start proveniente dall'esterno
no_jmp: in std_logic;		--condition code
lsb: in std_logic;		--bit proveniente dal uIR
lsb_out: out std_logic		--uscita del blocco combinatorio
);

end component;



signal fromLateStatusPLA: std_logic;		--uscita del late status pla

signal touAR: std_logic_vector(4 downto 0);	--ingresso del uAR
signal fromuAR: std_logic_vector(4 downto 0);	--uscita del uAR

signal evenCell: std_logic_vector(22 downto 0);	--uscita della uROM celle pari
signal oddCell: std_logic_vector(22 downto 0);	--uscita della uROM delle dispari
signal touIR: std_logic_vector(22 downto 0);	--uscita del multiplexer, per selezionare l'ingresso da inviare al uIR
signal fromuIR: std_logic_vector(22 downto 0);	--uscita del uIR



begin



microAR: uAR generic map (n => 5)
port map (
dataIn => touAR, 
CLK => clock, 
reset => reset, 
enable => '1', 
dataOut => fromuAR);

pla: late_status_pla 
port map(
START => start,
no_jmp => fromuIR (22),
lsb => fromuIR (0),
lsb_out => fromLateStatusPLA
);


uROMCU: uROM port map(
add => fromuAR(4 downto 1), 
evenOutput => evenCell, 
oddOutput => oddCell);

choiceMUX: gen_mux_2_1 
generic map (n => 23)
	port map (
	xs => evenCell, 
	ys => oddCell, 
	sl => fromuAR(0), 
	ms => touIR);

microIR: uIR generic map (n => 23)
port map (
data_in => touIR, 
CLK => clock, 
load => '1', 
clear => '0', 
data_out => fromuIR);



touAR <= fromuIR(4 downto 1) & fromLateStatusPLA;
toDatapath <= fromuIR(21 downto 6);
done <= fromuIR (5);

end beh;
