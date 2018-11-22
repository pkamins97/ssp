library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_divx4 is

port(
		clk4x		:	in std_logic;
		reset		:	in std_logic;
		
		output	:	out std_logic
);
end entity;

architecture arch of freq_divx4 is

type FSM_state is (init, one, zero);
signal counter : unsigned(1 downto 0);
--signal s_output : std_logic;
signal current_state, next_state : FSM_state;


BEGIN

	PROCESS(clk4x, reset)
	BEGIN

	IF(reset='1') THEN
		next_state <= init;
	ELSIF(rising_edge(clk4x)) THEN
		CASE current_state IS
		
			WHEN init =>

				next_state <= one;
				counter <= to_unsigned(0,2);
				
			WHEN one =>
			
--				IF(counter=0) THEN
--					next_state <= zero;
				IF(counter=1) THEN
					next_state <= zero;
				ELSE
					next_state <= one;
				END IF;
				
				counter <= counter+1;					
				
			WHEN zero =>
				IF(counter=2) THEN
--					next_state <= one;
					counter <= counter+1;
				ELSIF(counter=3) THEN
					next_state <= one;
					counter <= to_unsigned(0,2);
					counter <= counter+1;
				ELSE
					next_state <= one;
				END IF;
				
			WHEN 	others =>
				next_state <= init;
				
			END CASE;			
		END IF;

END PROCESS;
	
	current_state <= next_state;
	output <=	'1' WHEN next_state = one ELSE '0'; 

END arch;