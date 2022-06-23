library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.bf.all;

entity tbButterfly16x16 is

end entity tbButterfly16x16;

architecture behavioral of tbButterfly16x16 is

component Butterfly16x16 is
port(samplesIN, WR,WI: in stage;
	reset,start, clock: in std_logic;
	done: out std_logic;
	samplesOUT: out stage);
end component;

  file testFile, resFile: text;

signal clock, start, reset, done: std_logic;
signal dI, dO,dM, WR,WI: stage;
begin

reset <= '1', '0' after 40 ns;

  clock_gen: process
  begin
    clock <= '1';
    wait for 10 ns;
    clock <= '0';
    wait for 10 ns;
  end process clock_gen;


readInput: process
    variable testLine: line;
    variable testData: std_logic_vector(19 downto 0);
    --type stdArr is array(0 to 15) of  std_logic_vector(19 downto 0);
    --variable testData : integer;
    variable space: character;
    variable index: integer;

    begin
	start <= '0';
      
	file_open(testFile,"butterflyW.txt",read_mode);
	index := 0;
	while not endfile(testFile) and index < 16 loop
	
		readline(testFile, testLine);

		  read(testLine, testData);
		read(testLine, space); 
		WR(index) <= signed(testData);
		 read(testLine, testData);
		WI(index) <= signed(testData);
		index := index + 1;
	end loop;
	file_close(testFile);

	wait for 50 ns;

      file_open(testFile, "butterfly16x16InputData.txt", read_mode);
      while not endfile(testFile) loop
        
	start <= '1';
	wait for 40 ns;
        readline(testFile, testLine);
	for i in 0 to 15 loop
	
 	       read(testLine, testData);
		read(testLine, space);
		dI(i) <= signed(testData)/2;
        end loop;

	
	start <= '0';
	wait for 20 ns;
	for i in 0 to 15 loop
		dI(i) <= to_signed(0,20);
        end loop;
	wait for 20 ns;
      end loop;
      
      file_close(testFile);
	
	wait;
    
end process readInput;

--saveOutput: process
--begin
	file_open(resFile,"butterfly16x16TbResults.txt", write_mode);
	
	writing: process

	variable resLine: line;
	begin
		wait for 20 ns;
		if done='1' then
			wait for 20 ns;
				for i in 0 to 15 loop
					write(resLine, to_integer(dO(i)*2));
					write(resLine, ' ');
				end loop;
			writeline(resFile,resLine);
		
			wait for 20 ns;
				for i in 0 to 15 loop
					write(resLine, to_integer(dO(i)*2));
					write(resLine, ' ');
				end loop;
			writeline(resFile,resLine);
		end if;
	end process writing;
	file_close(resFile);
--end process saveOutput;

DUT: Butterfly16x16 port map(samplesIn => dI,WR => WR, WI => WI,
				reset => reset, start => start,clock => clock,
				done => done, samplesOut => dM);
dO(0) <= dM(0);
dO(1) <= dM(8);
dO(2) <= dM(4);
dO(3) <= dM(12);
dO(4) <= dM(2);
dO(5) <= dM(10);
dO(6) <= dM(6);
dO(7) <= dM(14);
dO(8) <= dM(1);
dO(9) <= dM(9);
dO(10) <= dM(5);
dO(11) <= dM(13);
dO(12) <= dM(3);
dO(13) <= dM(11);
dO(14) <= dM(7);
dO(15) <= dM(15);
end behavioral;
