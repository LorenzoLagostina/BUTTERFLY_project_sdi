library ieee;
use ieee.std_logic_1164.all;

entity uIR is

generic (N : positive);
port (
	data_in: in std_logic_vector (N-1 downto 0);
	CLK: in std_logic;
	load: in std_logic; 
	clear: in std_logic;
	data_out: out std_logic_vector (N -1 downto 0)
);
end entity uIR;

architecture beh of uIR is

begin

	process(CLK)
	begin
		
		if(CLK'event and CLK = '1') then
			
			if (clear = '1') then
			   
			   data_out <= (others =>'0');
			
			elsif load = '1' then
			
			   data_out <= data_in;
			   
			end if;
		end if;
	end process;

end architecture beh;
