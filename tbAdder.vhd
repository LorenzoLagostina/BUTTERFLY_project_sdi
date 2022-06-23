library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tbAdder is
	
end entity tbAdder;

architecture behavioral of tbAdder is

	component Adder is
		generic(N : positive);
		port(
			IN1, IN2: in signed(N-1 downto 0);
			RES: out signed(N-1 downto 0));
	end component;

signal in1,in2,res: signed (19 downto 0);

begin

in1 <= to_signed(0,20),to_signed(-20,20) after 20 ns, to_signed(58,20) after 50 ns;
in2 <= to_signed(0,20), to_signed(15,20) after 15 ns, to_signed(-66,20) after 40 ns;


DUT: Adder generic map (N => 20)
		port map(IN1 => in1, IN2 => in2, RES => res);

end behavioral;
