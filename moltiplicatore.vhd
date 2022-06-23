library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity moltiplicatore is
    generic (N : positive);
    port (
        MUL1 : IN SIGNED (N - 1 downto 0);
        MUL2 : IN SIGNED (N - 1 downto 0);
        CLK : IN STD_LOGIC;
        CLEAR : IN STD_LOGIC;
        LOAD : IN STD_LOGIC;
        SHIFT : IN STD_LOGIC;
        RES : OUT SIGNED (2 * N - 2 downto 0)
    );
end moltiplicatore;


architecture beh of moltiplicatore is

    component registerFF
        generic (N : positive);
        port (
        DATA_IN : IN SIGNED(N - 1 downto 0);
        CLK : IN STD_LOGIC;
        CLEAR : IN STD_LOGIC;
        LOAD : IN STD_LOGIC;
        DATA_OUT : OUT SIGNED(N - 1 downto 0)
    );
    end component;

    component mux2to1
        generic (N : positive);
        port (
            DATA_1 : IN SIGNED (N - 1 downto 0);
            DATA_2 : IN SIGNED (N - 1 downto 0);
            SEL : IN STD_LOGIC;
            DATA_OUT : OUT SIGNED (N - 1 downto 0)
        );
    end component;
    signal RES_MUL : SIGNED(2 * N - 1 downto 0);
    signal RES_TO_MEM_1 : SIGNED (2 * N - 2 downto 0);
    signal RES_TO_MEM_2 : SIGNED (2 * N - 2 downto 0);
    signal RES_TO_MEM : SIGNED (2 * N - 2 downto 0);
    
begin
    RES_MUL <= MUL1 * MUL2;
    RES_TO_MEM_1 <= RES_MUL(2 * N - 2 downto 0);
    
    RES_TO_MEM_2(2 * N - 2 downto N) <= MUL1(N - 2 downto 0);
    RES_TO_MEM_2(N - 1 downto 0) <= (others => '0');

    MUX_MUL_SHIFT : mux2to1
        generic map (N => 2 * N - 1)
        port map(
            DATA_1 => RES_TO_MEM_1,
            DATA_2 => RES_TO_MEM_2,
            SEL => SHIFT,
            DATA_OUT => RES_TO_MEM
        );
    


    REG_PIPE : registerFF
	generic map(N => 2 * N - 1)
	port map (
	DATA_IN => RES_TO_MEM,
	CLK => CLK,
	CLEAR => CLEAR,
	LOAD => LOAD,
	DATA_OUT => RES
    );

end beh;
