library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity mux2to1 is
    generic (N : positive);
    port (
        DATA_1 : IN SIGNED (N - 1 downto 0);
        DATA_2 : IN SIGNED (N - 1 downto 0);
        SEL : IN STD_LOGIC;
        DATA_OUT : OUT SIGNED
    );
end mux2to1;


architecture beh of mux2to1 is
    begin
    with SEL select DATA_OUT <= 
                    DATA_1 when '0',
                    DATA_2 when others;

end beh;