library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-----------
entity uROM is
port (
	add: in std_logic_vector(3 downto 0);
	evenOutput,oddOutput: out std_logic_vector(22 downto 0));
end entity uROM;


architecture beh of uROM is

signal regAddress: integer range 0  to (2**4)-1;

type memory is array (0 to (2**4)-1) of std_logic_vector(22 downto 0);

--primo bit: CC => NO_JMP
--16 bit: comandi to_datapath
-- 1 BIT: DONE
--4 bit: next address
--ultimo bit: LSB

constant evenRom: memory :=(
0 => "1" & "1000000000000000" & "0" & "0000" & "1" ,
1 => "1" & "0001100000000000" & "0" & "0001" & "1" ,
2 => "0" & "0000111001100100" & "0" & "1110" & "1" ,
3 => "1" & "0000001100001100" & "0" & "0011" & "1" ,
4 => "1" & "0000000010000000" & "0" & "0000" & "1" ,
5 => "1" & "0001111100001010" & "0" & "0101" & "1" ,
6 => "0" & "0000111111100100" & "1" & "1101" & "1" ,

13 => "1" & "0000111111010100" & "0" & "0010" & "1" ,
14 => "1" & "0000111101010100" & "0" & "0010" & "1" ,
15 => "1" & "0100000000000000" & "0" & "0000" & "1" ,

others => "1" & "1000000000000000" & "0" & "0000" & "0");

constant oddRom: memory :=(
0 => "0" & "0100000000000000" & "0" & "1111" & "0" ,
1 => "1" & "0000110000100000" & "0" & "0010" & "0" ,
2 => "1" & "0000011100001010" & "0" & "0011" & "0" ,
3 => "1" & "0000000110000000" & "1" & "0100" & "0" ,
5 => "1" & "0000111100101100" & "0" & "0110" & "0" ,

13 => "1" & "0010111111010100" & "0" & "0101" & "0" ,
14 => "1" & "0010111101010100" & "0" & "0101" & "0" ,
15 => "1" & "0010000000000000" & "0" & "0001" & "0" ,

others => "1" & "1000000000000000" & "0" & "0000" & "0");


begin

evenOutput <= evenRom(to_integer(unsigned(add)));
oddOutput <= oddRom(to_integer(unsigned(add)));

end beh;