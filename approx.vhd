library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity approx is

	generic(N : positive);
	port(
	     Input: in signed((2*N)-1 downto 0);	--ingresso proveniente dal registro del moltiplicatore
	     Output: out signed(N-1 downto 0));		--uscita approssimata e successivamente scalata
end entity approx;

architecture behavioral of approx is

	component mux2to1 is
		generic (N : positive);
		port (
			DATA_1 : IN SIGNED (N - 1 downto 0);
			DATA_2 : IN SIGNED (N - 1 downto 0);
			SEL : IN STD_LOGIC;
			DATA_OUT : OUT SIGNED
		);
	end component;


	component Adder is
		generic(N : positive);
		port(
		   IN1, IN2: in signed(N-1 downto 0);
		   RES: out signed(N-1 downto 0));
	end component;


signal one: signed(N-1 downto 0); 	--segnale per sommare 1 secondo le regole di approssimazione del round to nearest even
signal zero: signed(N-1 downto 0);	--segnale per sommare 0 secondo le regole di approssimazione del round to nearest even
signal fromMux: signed (N-1 downto 0);	--segnale in uscita al multiplexer che ha come output il secondo addendo della somma (1 o 0)

signal approxVal: std_logic;	--segnale di selezione del multiplexer
signal ORmiddle: std_logic;	--segnale utilizzato per verificare se siamo a metà intervallo
signal x: std_logic;		--segnale intermedio
signal y: std_logic;		--segnale intermedio

signal out_approx: signed (N-1 downto 0); -- uscita dall'approssimazione

begin


ORloop: for i in 0 to (N-3) generate
begin
ORmiddle <= ((not(Input(i)))or (not(Input (i+1))));
end generate ORloop;



x <= ( (Input(N-1)) and (Input(N-2)));
y <= ( (Input(N)) and (( (Input (N-1)) and (ORmiddle) ) ) );
approxVal <= x or y;

--Output <= ((out_approx(N-1)) & (out_approx((N-1) downto 1)));
Output <= out_approx;
zero <= to_signed(0,20);
one <= to_signed(1,20);

AppMUX : mux2to1 generic map (n => N)
		port map (
			DATA_1 => zero, 
			DATA_2 => one,
			SEL => approxVal, 
			DATA_OUT => fromMUX);

AppADD : Adder generic map (N => N)
		port map(
			IN1 => Input((2*N)-1 downto (N)), 
			IN2 => fromMUX, 
			RES => out_approx);



end behavioral;
