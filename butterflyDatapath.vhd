library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity butterflyDatapath is
    generic (N : positive := 20);
    port (
        CLK : IN STD_LOGIC;

        -- data ingresso
        DATA_IN_VAR_A : IN SIGNED (N - 1 downto 0);
        DATA_IN_VAR_B : IN SIGNED (N - 1 downto 0);
        DATA_IN_VAR_WR : IN SIGNED (N - 1 downto 0);
        DATA_IN_VAR_WI : IN SIGNED (N - 1 downto 0);

        -- decoder per input A e B
        LOAD_REAL : IN STD_LOGIC;
        LOAD_IMM : IN STD_LOGIC;

        -- segnali per W
        LOAD_W_REG : IN STD_LOGIC;


        CLEAR_REG : IN STD_LOGIC;

        -- selezione bus
        SEL_BUS_MUL_1 : IN STD_LOGIC;
        SEL_BUS_MUL_2 : IN STD_LOGIC;
        SEL_BUS_SUM : IN STD_LOGIC;

        -- segnali moltiplicatore
        LOAD_MUL_REG_PIPE : IN STD_LOGIC;
        SHIFT : IN STD_LOGIC;

        -- somma pipe
        LOAD_SUM_REG_PIPE : IN STD_LOGIC;
        SUB_ADDN1 : IN STD_LOGIC;
        SUB_ADDN2 : IN STD_LOGIC;

        -- load approx
        LOAD_APPROX: in std_logic;

        LOAD_REG_RES_SUM : IN STD_LOGIC;
        LOAD_REG_RES_MUL : IN STD_LOGIC;

        SEL_SUM_ADD : IN STD_LOGIC;

        -- bus uscita
        OUT_A : OUT SIGNED(N - 1 downto 0);
        OUT_B : OUT SIGNED(N - 1 DOWNTO 0)




    );
end butterflyDatapath;


architecture beh of butterflyDatapath is


    component approx is
        generic(N : positive);
        port(
             Input: in signed((2*N)-1 downto 0);--ingresso su n+3 bit
             Output: out signed(N-1 downto 0));
    end component;


    component moltiplicatore is
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
    end component;


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


    component mux2to1 is
        generic (N : positive);
        port (
            DATA_1 : IN SIGNED (N - 1 downto 0);
            DATA_2 : IN SIGNED (N - 1 downto 0);
            SEL : IN STD_LOGIC;
            DATA_OUT : OUT SIGNED
        );
    end component;


    component RegisterFile is
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

        component registerFF is
            generic (N : positive);
            port (
            DATA_IN : IN SIGNED(N - 1 downto 0);
            CLK : IN STD_LOGIC;
            CLEAR : IN STD_LOGIC;
            LOAD : IN STD_LOGIC;
            DATA_OUT : OUT SIGNED(N - 1 downto 0)
        );
        end component;


        signal BUS_MUL_1 : SIGNED (N - 1 downto 0);
        signal BUS_MUL_2 : SIGNED (N - 1 downto 0);
        signal BUS_ADD_1 : SIGNED (N - 1 downto 0);
        signal BUS_ADD_2 : SIGNED (N - 1 downto 0);

        signal RES_OUT_MUL : SIGNED(2 * N - 2 downto 0);
        signal RES_MUL_MEM : SIGNED(2 * N - 2 downto 0);

        signal ADD2_SUM1 : SIGNED(2 * N - 1 downto 0);
        signal ADD2_SUM2 : SIGNED(2 * N - 1 downto 0);

        signal ADD1_SUM1 : SIGNED(2 * N - 1 downto 0);
        signal ADD1_SUM2 : SIGNED(2 * N - 1 downto 0);

        signal A_SUM1 : SIGNED(2 * N - 1 downto 0);
        signal A_SUM2 : SIGNED(2 * N - 1 downto 0);

        signal RES_OUT_SUM1 : SIGNED(2 * N - 1 downto 0);
        signal RES_SUM_MEM1 : SIGNED(2 * N - 1 downto 0);
        signal RES_OUT_SUM2 : SIGNED(2 * N - 1 downto 0);
        signal RES_SUM_MEM2 : SIGNED(2 * N - 1 downto 0);
	signal DATA_A_TO_APPROX : SIGNED((2*N)-1 downto 0);
    signal DATA_B_TO_APPROX : SIGNED((2*N)-1 downto 0);
    
    signal OUT_A_TO_MEM : SIGNED(N - 1 downto 0);
    signal OUT_B_TO_MEM : SIGNED(N - 1 DOWNTO 0);



    begin
    RF: RegisterFile
        generic map (N => N)
        port map(
        CLK => CLK,

        DATA_IN_VAR_A => DATA_IN_VAR_A,
        DATA_IN_VAR_B => DATA_IN_VAR_B,
        DATA_IN_VAR_WR => DATA_IN_VAR_WR,
        DATA_IN_VAR_WI => DATA_IN_VAR_WI,

        LOAD_REAL_PART => LOAD_REAL, 
        LOAD_IMM_PART => LOAD_IMM,

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

        MUL: moltiplicatore
        generic map(N => N)
            port map(
                MUL1 => BUS_MUL_1,
                MUL2 => BUS_MUL_2,
                CLK => CLK,
                CLEAR => CLEAR_REG,
                LOAD => LOAD_MUL_REG_PIPE,
                SHIFT => SHIFT,
                RES => RES_OUT_MUL
        );



        REG_OUT_MUL : registerFF
            generic map(N => 2 * N - 1)
            port map(
            DATA_IN => RES_OUT_MUL,
            CLK => CLK,
            CLEAR => CLEAR_REG,
            LOAD => LOAD_REG_RES_MUL,
            DATA_OUT => RES_MUL_MEM
        );

        ADD2_SUM1 <= RES_MUL_MEM(2 * N - 2) & RES_MUL_MEM;
        ADD2_SUM2 <= RES_MUL_MEM(2 * N - 2) & RES_MUL_MEM;


        A_SUM1 (2 * N - 1 downto N - 1) <= BUS_ADD_1(N - 1) & BUS_ADD_1;
        A_SUM1 (N - 2 downto 0) <= (others => '0');
        A_SUM2 (2 * N - 1 downto N - 1) <= BUS_ADD_2(N - 1) & BUS_ADD_2;
        A_SUM2 (N - 2 downto 0) <= (others => '0');

        MUX_ADD1_SUM1 : mux2to1
            generic map(N => 2 * N)
            port map(
                DATA_1 => A_SUM1,
                DATA_2 => RES_SUM_MEM1,
                SEL => SEL_SUM_ADD,
                DATA_OUT => ADD1_SUM1
            );

        MUX_ADD1_SUM2 : mux2to1
        generic map(N => 2 * N)
        port map(
            DATA_1 => A_SUM2,
            DATA_2 => RES_SUM_MEM2,
            SEL => SEL_SUM_ADD,
            DATA_OUT => ADD1_SUM2
        );

        SUM1 : sommatore
            generic map(N => 2 * N)
            port map(
                ADD1 => ADD1_SUM1,
                ADD2 => ADD2_SUM1,
                CLK => CLK,
                LD => LOAD_SUM_REG_PIPE,
                CLEAR => CLEAR_REG,
                SUB => SUB_ADDN1,
                RES => RES_OUT_SUM1
            );
        

        SUM2 : sommatore
            generic map(N => 2 * N)
            port map(
                ADD1 => ADD1_SUM2,
                ADD2 => ADD2_SUM2,
                CLK => CLK,
                LD => LOAD_SUM_REG_PIPE,
                CLEAR => CLEAR_REG,
                SUB => SUB_ADDN2,
                RES => RES_OUT_SUM2
            );


        REG_OUT_SUM1 : registerFF
        generic map(N => 2 * N)
        port map(
        DATA_IN => RES_OUT_SUM1,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_REG_RES_SUM,
        DATA_OUT => RES_SUM_MEM1
        );

        REG_OUT_SUM2 : registerFF
        generic map(N => 2 * N)
        port map(
        DATA_IN => RES_OUT_SUM2,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_REG_RES_SUM,
        DATA_OUT => RES_SUM_MEM2
        );

	DATA_A_TO_APPROX <= RES_SUM_MEM2;
	DATA_B_TO_APPROX <= RES_SUM_MEM1;	
	
	--DATA_A_TO_APPROX <=  RES_SUM_MEM2(2 * N - 1) & RES_SUM_MEM2(2 * N - 1 downto N - 2);
	--DATA_B_TO_APPROX <=  RES_SUM_MEM1(2 * N - 1) & RES_SUM_MEM1(2 * N - 1 downto N - 2);	

        APPROX_B: approx
        generic map(N => N)
        port map(
            Input => DATA_B_TO_APPROX,
            Output => OUT_B_TO_MEM
        );

        APPROX_A: approx
        generic map(N => N)
        port map(
            Input => DATA_A_TO_APPROX,
            Output => OUT_A_TO_MEM
        );

        REG_OUT_APPROX_A : registerFF
        generic map(N => N)
        port map(
        DATA_IN => OUT_A_TO_MEM,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_APPROX,
        DATA_OUT => OUT_A
        );

        REG_OUT_APPROX_B : registerFF
        generic map(N => N)
        port map(
        DATA_IN => OUT_B_TO_MEM,
        CLK => CLK,
        CLEAR => CLEAR_REG,
        LOAD => LOAD_APPROX,
        DATA_OUT => OUT_B
        );





end beh;