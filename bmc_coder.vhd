library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bmc_coder is

port(
		clk4x		:	in std_logic;
		reset		:	in std_logic;
		input		:	in std_logic;
		
		output		:	out std_logic;
		reset_framer	:	out std_logic
);
end entity;

architecture arch of bmc_coder is

component freq_divx2 is
port(
		clk4x		:	in std_logic;
		reset		:	in std_logic;
		
		output		:	out std_logic
);
end component;


component freq_divx4 is
port(
		clk4x		:	in std_logic;
		reset		:	in std_logic;
		
		output		:	out std_logic
);
end component;


type FSM_state is (init, preamble, coded_data);

signal d4out, d2out 			: std_logic;
signal current_state, next_state 	: FSM_state;
signal counter_preamble 		: unsigned (2 downto 0);
signal counter_coded_data		: unsigned (6 downto 0);
signal s_out, s_preamble		: std_logic;
constant cPREAMBLE 			: std_logic_vector (7 downto 0) := "11101000";


BEGIN
	D4	:	freq_divx4 port map(clk4x=>clk4x, reset=>reset, output=>d4out);
	D2	:	freq_divx2 port map(clk4x=>clk4x, reset=>reset, output=>d2out);
	
	process(clk4x) is
	begin
		if(reset = '1') then
			next_state <= init;
		elsif(rising_edge(clk4x)) then
		
			case current_state is
			
				when init =>
					next_state <= preamble;
					counter_preamble <=  to_unsigned(0,3);
					counter_coded_data <= to_unsigned(0,8);
				when preamble =>
					if(counter_preamble = 7) then
						next_state <= coded_data;
						counter_preamble <= to_unsigned(0,3);
						s_preamble <= cPREAMBLE(7);
					else		
						counter_preamble <= counter_preamble + 1;
						next_state <= preamble;						
					end if;
				when coded_data =>
					if(counter_coded_data = 111) then
						next_state <= preamble;
						counter_coded_data <= to_unsigned(0,8);
					else
						counter_coded_data <= counter_coded_data + 1;
						next_state <= coded_data;
					end if;
			end case;
		end if;
	end process;
	
	current_state 	<= next_state;	
	s_out  		<= d2out WHEN input = '1' ELSE d4out;
	
	output 		<= s_out					WHEN next_state = coded_data 	else
			cPREAMBLE(to_integer(counter_preamble)) 	WHEN next_state = preamble		else
			'0';
		
	reset_framer	<= '1' 	WHEN next_state = preamble	ELSE
			'0';	
END ARCH;
