library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_approx is
	
end entity tb_approx;

architecture behavioral of tb_approx is

component approx is

	generic(N : positive);
	port(
	     Input: in signed((2*N)-1 downto 0);
	     Output: out signed(N-1 downto 0));

end component approx;

constant N : positive := 20;
signal Input: signed((2*N)-1 downto 0);
signal Output: signed(N-1 downto 0);

begin

DUT: approx
generic map(N => N)
port map (
Input => Input,
Output => Output
);

        S : process
        begin
        Input <= "0000000000000000000110000000000000000000";
        wait for 10 ns;
	Input <= "0000000000000000000100100000000000000000";
	wait for 10 ns;
	Input <= "0000000000000000000101100000000000000000";
	wait for 10 ns;
	Input <= "0000000000000000000010000000000000000000";
	wait for 10 ns;
	Input <= "0000000000000000000111100000000000000000";

        wait;
        end process;
end behavioral;