library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
	generic(N : positive);
	port(
		IN1, IN2: in signed(N-1 downto 0);
		RES: out signed(N-1 downto 0));
end entity Adder;

architecture behavioral of Adder is

begin

RES <= IN1 + IN2;
end behavioral;
