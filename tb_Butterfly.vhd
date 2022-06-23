library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity tb_Butterfly is
    end tb_Butterfly;

architecture beh of tb_Butterfly is
    constant N : positive := 20;

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

    signal RESET : STD_LOGIC;
    signal START : STD_LOGIC;
    signal CLK : STD_LOGIC;
    signal IN_A : SIGNED(N - 1 DOWNTO 0);
    signal IN_B : SIGNED(N - 1 DOWNTO 0);
    signal IN_WR : SIGNED(N - 1 DOWNTO 0);
    signal IN_WI : SIGNED(N - 1 DOWNTO 0);
    signal OUT_A : SIGNED(N - 1 DOWNTO 0);
    signal OUT_B : SIGNED(N - 1 DOWNTO 0);
    signal DONE : STD_LOGIC;

	  file testFileR,testFileI,wFile, resFile: text;

begin
    UUT: Butterfly
        generic map(N => N)
        port map(
            RESET => RESET,
            START => START,
	    CLK => CLK,
            IN_A => IN_A,
            IN_B => IN_B,
            IN_WR => IN_WR,
            IN_WI => IN_WI,
            OUT_A => OUT_A,
            OUT_B => OUT_B,
            DONE => DONE
        );

readInput: process
    variable testLine,testLineR,testLineI: line;
    variable testData,testDataAI,testDataBI: std_logic_vector(19 downto 0);
    variable space: character;

    begin
	

	file_open(wFile,"butterflyW.txt",read_mode);
   	 --wait for 60 ns;
   	 RESET <= '1';
	start <= '0';
   	 wait for 40 ns;
    	RESET <= '0';
     
	wait for 40 ns; 
	while not endfile(wFile) loop
	
		readline(wFile, testLine);

		  read(testLine, testData);
		read(testLine, space); 
		IN_WR <= signed(testData);
		 read(testLine, testData);
		read(testLine, space);
		IN_WI <= signed(testData);
	

    wait for 50 ns;

	file_open(testFileI,"butterflyInputImagData.txt",read_mode);
	while not endfile(testFileI) loop

		readline(testFileI, testLineI);

	 	        	read(testLineI, testDataAI);
				read(testLineI, space);

				read(testLineI, testDataBI);
				read(testLineI, space);

      		file_open(testFileR, "butterflyInputRealData.txt", read_mode);
      		while not endfile(testFileR) loop
        
				start <= '1';
				wait for 40 ns;
        			readline(testFileR, testLineR);
	
	
 	       			read(testLineR, testData);
				read(testLineR, space);
				IN_A <= signed(testData);
		
				read(testLineR, testData);
				read(testLineR, space);
				IN_B <= signed(testData);

	
				start <= '0';
				wait for 20 ns;
	 	        
				IN_A <= signed(testDataAI);
		
				IN_B <= signed(testDataBI);
				
				wait for 20 ns;
      		end loop;
      
      		file_close(testFileR);
      
      end loop;
      file_close(testFileI);
      
    end loop;  
	file_close(wFile);
	
	wait;
    
end process readInput;

file_open(resFile,"butterflyTbResults.txt", write_mode);
	
	writing: process

	variable resLine: line;
	begin
		wait for 20 ns;
		if done='1' then
			wait for 20 ns;

					write(resLine, to_integer(OUT_A));
					write(resLine, ' ');
					write(resLine, to_integer(OUT_B));
					write(resLine, ' ');
					
			writeline(resFile,resLine);
		
			wait for 20 ns;
				write(resLine, to_integer(OUT_A));
					write(resLine, ' ');
					write(resLine, to_integer(OUT_B));
					write(resLine, ' ');
					
			writeline(resFile,resLine);
		end if;
	end process writing;
	file_close(resFile);

    CLK_GEN : process
    begin
        CLK <= '0';
        wait for 10 ns;
        CLK <= '1';
        wait for 10 ns;
    end process;

     



end beh ; -- beh