library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
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
    end RegisterFile;


architecture beh of RegisterFile is

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
            DATA_OUT : OUT SIGNED
        );
    end component;

    signal AR_MEM : SIGNED(N - 1 downto 0);
    signal BR_MEM : SIGNED(N - 1 downto 0);
    signal AI_MEM : SIGNED(N - 1 downto 0);
    signal BI_MEM : SIGNED(N - 1 downto 0);

    signal WR_MEM : SIGNED(N - 1 downto 0);
    signal WI_MEM : SIGNED(N - 1 downto 0);

    signal BUS_ADD : SIGNED (N - 1 downto 0);


begin

    REG_BR : registerFF
        generic map (N => N)
        port map(
        DATA_IN => DATA_IN_VAR_B,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_REAL_PART,
        DATA_OUT => BR_MEM
    );

    REG_BI : registerFF
        generic map (N => N)
        port map(
        DATA_IN => DATA_IN_VAR_B,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_IMM_PART,
        DATA_OUT => BI_MEM
    );

    REG_AR : registerFF
        generic map (N => N)
        port map(
        DATA_IN => DATA_IN_VAR_A,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_REAL_PART,
        DATA_OUT => AR_MEM
    );

    REG_AI : registerFF
        generic map (N => N)
        port map(
        DATA_IN => DATA_IN_VAR_A,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_IMM_PART,
        DATA_OUT => AI_MEM
    );



    MUX_BUS_ADD : mux2to1
        generic map(N => N)
        port map (
            DATA_1 => AR_MEM,
            DATA_2 => AI_MEM,
            SEL => SEL_BUS_SUM,
            DATA_OUT => BUS_ADD
    );
    
    BUS_ADD_1 <= BUS_ADD;
    BUS_ADD_2 <= BUS_ADD;
    

    MUX_BUS_MUL_1 : mux2to1
        generic map(N => N)
        port map(
            DATA_1 => BR_MEM,
            DATA_2 => BI_MEM,
            SEL => SEL_BUS_MUL_1,
            DATA_OUT => BUS_MUL_1
    );

    REG_WR : registerFF
        generic map(N => N)
        port map(
        DATA_IN => DATA_IN_VAR_WR,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_W_REG,
        DATA_OUT => WR_MEM
    );

    REG_WI : registerFF
        generic map(N => N)
        port map(
        DATA_IN => DATA_IN_VAR_WI,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_W_REG,
        DATA_OUT => WI_MEM
    );


    MUX_BUS_DOWN : mux2to1
        generic map (N => N)
        port map (
            DATA_1 => WR_MEM,
            DATA_2 => WI_MEM,
            SEL => SEL_BUS_MUL_2,
            DATA_OUT => BUS_MUL_2
        );
end beh ; -- beh