library ieee;
use ieee.std_logic_1164.all;

entity TB_CU_BUTTERFLY is

end entity TB_CU_BUTTERFLY;

architecture beh of TB_CU_BUTTERFLY is

component cu is 
port(
	reset, start, clock: in std_logic;
	toDatapath: out std_logic_vector(15 downto 0);
	done : out std_logic
);
end component;

signal reset, start, clock, done: std_logic;
signal toDatapath: std_logic_vector(15 downto 0);

begin

reset <= '1', '0' after 40 ns;

start <= '0', '1' after 50 ns;

clockGen: process
begin
	clock <= '0';
	wait for 10 ns;
	clock <= '1';
	wait for 10 ns;


end process clockGen;
--wait;
DUT: cu port map (reset => reset, start => start, clock => clock, toDatapath => toDatapath, done => done);

end beh;
