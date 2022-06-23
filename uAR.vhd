library ieee;
use ieee.std_logic_1164.all;


entity uAR is
generic (n: positive);
port (
	dataIn: in std_logic_vector(n - 1 downto 0);
	CLK: in std_logic;
	reset: in std_logic; 
	enable: in std_logic;

	dataOut: out std_logic_vector(n - 1 downto 0)
);

end entity uAR;

architecture beh of uAR is

begin

	process(CLK)
	begin
		
		if(CLK'event and CLK = '0') then
			
			if (reset = '1') then
			   
			   dataOut <= (others => '0');
			
			elsif enable = '1' then
			
			   dataOut <= dataIn;
			   
			end if;
		end if;
	end process;

end architecture beh;