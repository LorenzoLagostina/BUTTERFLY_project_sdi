library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerFF is
	generic (N : positive);
	port (
	DATA_IN : IN SIGNED(N - 1 downto 0);
	CLK : IN STD_LOGIC;
	CLEAR : IN STD_LOGIC;
	LOAD : IN STD_LOGIC;
	DATA_OUT : OUT SIGNED(N - 1 downto 0)
);
end registerFF;

architecture beh of registerFF is
begin
process(CLK)
begin
if CLK'EVENT AND CLK = '1' then
	if CLEAR = '1' then
	DATA_OUT <= (OTHERS => '0');
	else
	if LOAD = '1' then
	DATA_OUT <= DATA_IN;
	end if;
	end if;
end if;
end process;
end beh;
