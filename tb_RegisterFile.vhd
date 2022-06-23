library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity tb_RegisterFile is
    end tb_RegisterFile;

architecture beh of tb_RegisterFile is

    constant N : positive := 5;

    component RegisterFile
        generic (N : positive);
        port (
        --CLK
        CLK : IN STD_LOGIC;

        -- DATI INGRESSO REGISTER FILE
        DATA_IN_VAR_A : IN SIGNED (N - 1 downto 0);
        DATA_IN_VAR_B : IN SIGNED (N - 1 downto 0);
        DATA_IN_VAR_WR : IN SIGNED (N - 1 downto 0);
        DATA_IN_VAR_WI : IN SIGNED (N - 1 downto 0);
        -- input controlli che sono gestiti da CU
        
        -- decoder per input A e B
        LOAD_REAL_PART : IN STD_LOGIC;
        LOAD_IMM_PART : IN STD_LOGIC;

        -- segnali per W
        LOAD_W_REG : IN STD_LOGIC;


        CLEAR_REG : IN STD_LOGIC;

        -- selezione bus
        SEL_BUS_MUL_1 : IN STD_LOGIC;
        SEL_BUS_MUL_2 : IN STD_LOGIC;
        SEL_BUS_SUM : IN STD_LOGIC;

        -- BUS di USCITA DATI
        BUS_MUL_1 : OUT SIGNED (N - 1 downto 0);
        BUS_MUL_2 : OUT SIGNED (N - 1 downto 0);
        BUS_ADD_1 : OUT SIGNED (N - 1 downto 0);
        BUS_ADD_2 : OUT SIGNED (N - 1 downto 0)
        );
        end component;


        signal CLK : STD_LOGIC;
    
        -- DATI INGRESSO REGISTER FILE
        signal DATA_IN_VAR_A : SIGNED (N - 1 downto 0);
        signal DATA_IN_VAR_B : SIGNED (N - 1 downto 0);
        signal DATA_IN_VAR_WR : SIGNED (N - 1 downto 0);
        signal DATA_IN_VAR_WI : SIGNED (N - 1 downto 0);
        
        -- decoder per input A e B
        signal LOAD_REAL_PART : STD_LOGIC;
        signal LOAD_IMM_PART : STD_LOGIC;

        -- segnali per W
        signal LOAD_W_REG : STD_LOGIC;


        signal CLEAR_REG : STD_LOGIC;

        -- selezione bus
        signal SEL_BUS_MUL_1 : STD_LOGIC;
        signal SEL_BUS_MUL_2 : STD_LOGIC;
        signal SEL_BUS_SUM : STD_LOGIC;
        -- BUS di USCITA DATI
        signal BUS_MUL_1 : SIGNED (N - 1 downto 0);
        signal BUS_MUL_2 : SIGNED (N - 1 downto 0);
        signal BUS_ADD_1 : SIGNED (N - 1 downto 0);
        signal BUS_ADD_2 : SIGNED (N - 1 downto 0);




begin

    UUT: RegisterFile
    generic map (N => N)
    port map (
        CLK => CLK,
        DATA_IN_VAR_A => DATA_IN_VAR_A,
        DATA_IN_VAR_B => DATA_IN_VAR_B,
        DATA_IN_VAR_WR => DATA_IN_VAR_WR,
        DATA_IN_VAR_WI => DATA_IN_VAR_WI,
        LOAD_REAL_PART => LOAD_REAL_PART,
        LOAD_IMM_PART => LOAD_IMM_PART,
        LOAD_W_REG => LOAD_W_REG,
        CLEAR_REG => CLEAR_REG,
        SEL_BUS_MUL_1 => SEL_BUS_MUL_1,
        SEL_BUS_MUL_2 => SEL_BUS_MUL_2,
        SEL_BUS_SUM => SEL_BUS_SUM, 
        BUS_MUL_1 => BUS_MUL_1, 
        BUS_MUL_2 => BUS_MUL_2,
        BUS_ADD_1 => BUS_ADD_1,
        BUS_ADD_2 => BUS_ADD_2
    );


    CLK_GEN : process
        begin
        CLK <= '1';
        wait for 10 ns;
        CLK <= '0';
        wait for 10 ns;
    end process;

    SIGNAL_GEN : process    
    begin

        LOAD_W_REG <= '0';
        LOAD_REAL_PART <= '0';
        LOAD_IMM_PART <= '0';
        DATA_IN_VAR_WR <= to_signed(-7, N);
        DATA_IN_VAR_WI <= to_signed(-12, N);
        DATA_IN_VAR_A <= to_signed(6, N);
        DATA_IN_VAR_B <= to_signed(3, N);

        CLEAR_REG <= '1';
        SEL_BUS_MUL_1 <= '0';
        SEL_BUS_MUL_2 <= '0';
        SEL_BUS_SUM <= '0';

        wait for 20 ns;

        CLEAR_REG <= '0';
        LOAD_W_REG <= '1';
        wait for 20 ns;

        LOAD_REAL_PART <= '1';
        wait for 20 ns;

        DATA_IN_VAR_A <= to_signed(8, N);
        DATA_IN_VAR_B <= to_signed(4, N);
        LOAD_IMM_PART <= '1';
        LOAD_REAL_PART <= '0';
        wait for 20 ns;
        DATA_IN_VAR_A <= to_signed(8, N);
        DATA_IN_VAR_B <= to_signed(4, N);
        LOAD_IMM_PART <= '0';
        SEL_BUS_MUL_1 <= '1';
        SEL_BUS_MUL_2 <= '1';
        SEL_BUS_SUM <= '1';

        wait for 20 ns;
        SEL_BUS_MUL_1 <= '0';
        SEL_BUS_MUL_2 <= '0';
        SEL_BUS_SUM <= '0';
        wait;

    end process ; -- identifier
end beh ; -- beh
