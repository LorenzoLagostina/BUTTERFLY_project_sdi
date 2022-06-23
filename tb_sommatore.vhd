library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity tb_sommatore is
    end tb_sommatore;

architecture beh of tb_sommatore is
    constant N : positive := 5;
    component sommatore is
        generic (N : positive);
        port (
            ADD1 : IN SIGNED (N - 1 downto 0);
            ADD2 : IN SIGNED (N - 1 downto 0);
            CLK : IN STD_LOGIC;
            LD : IN STD_LOGIC;
            CLEAR : IN STD_LOGIC;
            SUB : IN STD_LOGIC;
            RES : OUT SIGNED (N - 1 downto 0)
        );
    end component;
    signal ADD1 : SIGNED (N - 1 downto 0);
    signal ADD2 : SIGNED (N - 1 downto 0);
    signal CLK : STD_LOGIC;
    signal LD : STD_LOGIC;
    signal CLEAR : STD_LOGIC;
    signal SUB : STD_LOGIC;
    signal RES : SIGNED (N - 1 downto 0);

begin
    UUT : sommatore
        generic map(N => N)
        port map(
            ADD1 => ADD1,
            ADD2 => ADD2,
            CLK => CLK,
            LD => LD,
            CLEAR => CLEAR,
            SUB => SUB,
            RES => RES
        );
        
    CLK_GEN : process
    begin
    CLK <= '1';
    wait for 10 ns;
    CLK <= '0';
    wait for 10 ns;
    end process;



    SIG_GEN : process
    begin
    CLEAR <= '1';
    LD <= '1';
    ADD1 <= to_signed(- 2 ** (N - 2), N);
    ADD2 <= to_signed(- 2 ** (N - 2), N);
    SUB <= '0';
    wait for 20 ns;
    CLEAR <= '0';
    for i in -(2 ** (N - 2)) to (2 ** (N - 2) - 1) loop
        for j in -(2 ** (N - 2)) to (2 ** (N - 2) - 1)loop
            ADD1 <= to_signed(i, N);
            ADD2 <= to_signed(j, N);
            wait for 20 ns;
            end loop;
        end loop;
    SUB <= '1';
    for i in -(2 ** (N - 2)) to (2 ** (N - 2) - 1) loop
        for j in -(2 ** (N - 2)) to (2 ** (N - 2) - 1)loop
            ADD1 <= to_signed(i, N);
            ADD2 <= to_signed(j, N);
            wait for 20 ns;
            end loop;
        end loop;
    wait;

    end process;


end beh ; -- beh