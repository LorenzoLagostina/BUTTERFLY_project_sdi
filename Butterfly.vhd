library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Butterfly is
    generic(N : positive := 20);
    port (
        RESET : IN STD_LOGIC;
        START : IN STD_LOGIC;
        CLK : IN STD_LOGIC;
        IN_A : IN SIGNED(N - 1 DOWNTO 0);
        IN_B : IN SIGNED(N - 1 DOWNTO 0);
        IN_WR : IN SIGNED(N - 1 DOWNTO 0);
        IN_WI : IN SIGNED(N - 1 DOWNTO 0);
        OUT_A : OUT SIGNED(N - 1 DOWNTO 0);
        OUT_B : OUT SIGNED(N - 1 DOWNTO 0);
        DONE : OUT STD_LOGIC
    );
end Butterfly;

architecture beh of Butterfly is
    component cu is
        port(
            reset, start, clock: in std_logic;
            toDatapath: out std_logic_vector(15 downto 0);
            done : out std_logic
        );
        end component;

    component butterflyDatapath is
        generic (N : positive);
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
    end component;
    
    signal SIGNAL_TO_DATAPATH : std_logic_vector(15 downto 0);

    begin
        CU_PART : cu
            port map(
                reset => RESET, start => START, clock => CLK,
                toDatapath => SIGNAL_TO_DATAPATH,
                done => DONE
            );

            
        DATAPATH: butterflyDatapath
            generic map(N => N)
            port map(
                CLK => CLK,
        
                -- data ingresso
                DATA_IN_VAR_A => IN_A,
                DATA_IN_VAR_B => IN_B,
                DATA_IN_VAR_WR => IN_WR,
                DATA_IN_VAR_WI => IN_WI,
        
                -- decoder per input A e B
                LOAD_REAL => SIGNAL_TO_DATAPATH(13),
                LOAD_IMM => SIGNAL_TO_DATAPATH(12),
                LOAD_W_REG => SIGNAL_TO_DATAPATH(14),
        
        
                CLEAR_REG => SIGNAL_TO_DATAPATH(15),
        
                -- selezione bus
                SEL_BUS_MUL_1 => SIGNAL_TO_DATAPATH(6),
                SEL_BUS_MUL_2 => SIGNAL_TO_DATAPATH(5),
                SEL_BUS_SUM => SIGNAL_TO_DATAPATH(4),
        
                -- segnali moltiplicatore
                LOAD_MUL_REG_PIPE => SIGNAL_TO_DATAPATH(11),
                SHIFT => SIGNAL_TO_DATAPATH(0),
        
                -- somma pipe
                LOAD_SUM_REG_PIPE => SIGNAL_TO_DATAPATH(9),
                SUB_ADDN1 => SIGNAL_TO_DATAPATH(2),
                SUB_ADDN2 => SIGNAL_TO_DATAPATH(1),
                LOAD_APPROX => SIGNAL_TO_DATAPATH(7),
        
                LOAD_REG_RES_SUM => SIGNAL_TO_DATAPATH(8),
                LOAD_REG_RES_MUL => SIGNAL_TO_DATAPATH(10),
        
                SEL_SUM_ADD => SIGNAL_TO_DATAPATH(3),

                OUT_A => OUT_A,
                OUT_B => OUT_B        
                        
            );
        
        
end beh;