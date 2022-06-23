library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_decoder is
    end tb_decoder;


architecture beh of tb_decoder is
    constant N : positive := 3;
    component decoder is
        generic (N : positive);
        port (
            ADD : IN UNSIGNED (N - 1 downto 0);
            EN : IN STD_LOGIC;
            DATA_OUT : OUT STD_LOGIC_VECTOR ((2 ** N) - 1 downto 0)  
        );
        end component;


    signal EN : STD_LOGIC;
    signal ADD : UNSIGNED(N - 1 downto 0);
    signal DATA_OUT : STD_LOGIC_VECTOR ((2 ** N) - 1 downto 0);

    begin

        UUT : decoder
            generic map(N => N)
            port map(
                ADD => ADD,
                EN => EN,
                DATA_OUT => DATA_OUT  
            );

        SIG_GEN : process
        begin
            EN <= '0';
            ADD <= (others => '0');
            wait for 10 ns;
            EN <= '1';
            for i in 0 to 2 ** N - 1 loop
                ADD <= to_unsigned(i, N);
                wait for 10 ns;
            end loop;
            EN <= '0';
            wait for 10 ns;
            EN <= '1';
            wait;
        end process;

end beh;


