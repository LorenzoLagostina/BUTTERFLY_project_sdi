library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity sommatore is
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
end sommatore;


architecture beh of sommatore is
    
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

signal RES_TO_MEM : SIGNED(N - 1 downto 0);

begin

ADD_SUB_PROCESS : process( ADD1, ADD2, SUB )
begin
    if SUB = '0' then
        RES_TO_MEM <= ADD1 + ADD2;
    else
        RES_TO_MEM <= ADD1 - ADD2;
    end if;
    
end process ; -- ADD_SUB_PROCESS


REG_PIPE : registerFF
	generic map(N => N)
	port map (
	DATA_IN => RES_TO_MEM,
	CLK => CLK,
	CLEAR => CLEAR,
	LOAD => LD,
	DATA_OUT => RES
);


end beh;
