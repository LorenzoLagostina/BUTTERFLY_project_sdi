library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_moltiplicatore is
    end tb_moltiplicatore;

architecture beh of tb_moltiplicatore is
    constant N : positive := 8;
    component moltiplicatore
        generic (N : positive);
        port (
            MUL1 : IN SIGNED (N - 1 downto 0);
            MUL2 : IN SIGNED (N - 1 downto 0);
            CLK : IN STD_LOGIC;
            CLEAR : IN STD_LOGIC;
            LOAD : IN STD_LOGIC;
            SHIFT: IN STD_LOGIC;
            RES : OUT SIGNED (2* N - 2 downto 0)
        );
    end component;


    signal MUL1 : SIGNED (N - 1 downto 0);
    signal MUL2 : SIGNED (N - 1 downto 0);
    signal CLK : STD_LOGIC;
    signal CLEAR : STD_LOGIC;
    signal LOAD : STD_LOGIC;
    signal RES : SIGNED (2 * N - 2 downto 0);
    signal SHIFT : STD_LOGIC;


    begin

        UUT : moltiplicatore
        generic map (N => N)
        port map (
            MUL1 => MUL1,
            MUL2 => MUL2,
            CLK => CLK,
            CLEAR => CLEAR,
            LOAD => LOAD,
            SHIFT => SHIFT,
            RES => RES
        );


        CLK_GEN : process
        begin
            CLK <= '1';
            wait for 10 ns;
            CLK <= '0';
            wait for 10 ns;            
        end process ;


        SIGNAL_GEN : process
        begin
        CLEAR <= '1';
        LOAD <= '1';
        SHIFT <= '0';
        MUL1 <= (others => '0');
        MUL2 <= (others => '0');
        wait for 10 ns;
	CLEAR <= '0';
        for i in -(2 ** (N - 2)) to (2 ** (N - 2) - 1) loop
            for j in -(2 ** (N - 2) - 1) to (2 ** (N - 2) - 1)loop
                MUL1 <= to_signed(i, N);
                MUL2 <= to_signed(j, N);
                wait for 20 ns;
            end loop;
            end loop;
        MUL1 <= to_signed(3, N);
        MUL2 <= to_signed(5, N);
        SHIFT <= '1';
        wait for 20 ns;
        LOAD <= '0';
        MUL1 <= to_signed(7, N);
        wait for 20 ns;
        CLEAR <= '1';
        wait for 20 ns;
        LOAD <= '1';
        CLEAR <= '0';
        wait;
        end process;
end beh;