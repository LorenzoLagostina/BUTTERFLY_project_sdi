library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.bf.all;

entity Butterfly16x16 is
port(samplesIN, WI, WR: in stage;
	reset,start, clock: in std_logic;
	done: out std_logic;
	samplesOUT: out stage);
end entity Butterfly16x16;

architecture behavioral of Butterfly16x16 is

component Butterfly is
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
end component;

--type stage is array (0 to 15) of signed(19 downto 0);
type samples is array(0 to 4) of stage;
signal X: samples;
type middle is array (0 to 4) of  std_logic_vector(0 to 7);
signal S_D: middle;
signal doneOut: std_logic_vector(0 to 7);
type indArr is array (0 to 7) of integer;
constant wIndex: indArr := (0,4,2,6,1,5,3,7);
begin

guardbit: for i in 0 to 15 generate
begin
	X(0)(i) <= samplesIN(i);
end generate;
--X(0) <= samplesIN;
samplesOUT <= X(4);

S_D(0)(0) <= start;
doneOut(0) <= S_D(4)(0);

doneGen: for i in 1 to 7 generate
begin
	S_D(0)(i) <= start;
	doneOut(i) <= S_D(4)(i-1) and S_D(4)(i);
end generate;

done <= doneOut(7);

firstLoop: for i in 0 to 3 generate

begin
	secondLoop: for j in 0 to (2**i)-1 generate
	begin
		thirdLoop: for k in 0 to (2**(3-i))-1 generate
		begin
			BF: Butterfly port map(start => S_D(i)( k +(j*(2**(3-i))) ),
						 reset => reset, clk => clock, 
						done => S_D(i+1)( k + (j*(2**(3-i))) ),
						IN_A => X(i)(k + (j*(2**(4-i))) ),
					       IN_B => X(i)(k + (j*(2**(4-i))) + (2**(3-i)) ),
						IN_WR => WR(wIndex(j)),
						IN_WI => WI(wIndex(j)),
						OUT_A => X(i+1)(k + (j*(2**(4-i))) ),
					       OUT_B => X(i+1)(k + (j*(2**(4-i))) + (2**(3-i)) ) );
		end generate thirdLoop;
	end generate secondLoop;
end generate firstLoop;
end behavioral;
