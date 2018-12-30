library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity framer is
port(

	clk		:	in std_logic;
	data_in		:	in	std_logic_vector (27 downto 0);
	reset		:	in std_logic;
	is_fifo_empty	:	in std_logic;
	wait_fr		:	in std_logic;
	
	data_out	:	out std_logic;
	read_enable	:	out std_logic
	
);
end entity;

architecture Behavioral of framer is

type FSM_state is (init, z, swait, st_read, shift27, last_shift);

signal data_reg 			: std_logic_vector(27 downto 0);
signal current_state, next_state	: FSM_state;
signal counter				: unsigned (4 downto 0);
signal read_ok				: std_logic; 

begin
	
	process(clk, reset)
	begin
		
		if(reset = '1') then
			next_state <= init;
		elsif(rising_edge(clk)) then
			
			case current_state is
				
				when init =>
					if(is_fifo_empty = '1') then
						read_ok <= '0';
						next_state <= init;
					elsif(is_fifo_empty = '0') then
						read_ok <= '1';
						--data_reg <= st_read;----------------
						next_state <= z;
						counter <= to_unsigned(0,5);
					end if;
					
				when z => -- tylko opóźnienie o jeden takt, żeby zschynchronizować czytanie z fifo
					read_ok <= '0';
					next_state <= st_read;
					
				when st_read =>
					data_reg <= data_in;
					if(wait_fr = '1') then
						next_state <= swait;
					else
						next_state <= shift27;
					end if;
				when swait =>
					if(wait_fr = '1') then
						next_state <= swait;
					else
						next_state <= shift27;
					end if;
				
				when shift27 =>
					
					data_reg(26 downto 0) <= data_reg(27 downto 1);
					
					if(counter = 26) then
						counter <= to_unsigned(0,5);
						next_state <= last_shift;
						read_ok <= '1';
					else
						counter <= counter+1;
						next_state <= shift27;
					end if;
				
				when last_shift =>
					if(is_fifo_empty = '1') then
						read_ok <= '0';
						next_state <= init;
					elsif(is_fifo_empty = '0') then
						--read_ok <= '1';
						--data_reg <= data_in;--------------------
						next_state <= st_read;
					end if;
			end case;
		end if;
		
	end process;
	
	
		current_state 		<= next_state;
		
		data_out 		<= data_reg(0) when next_state =shift27 else
					data_reg(0) when next_state =last_shift else
					'0';
						
		read_enable 		<= '1' when read_ok='1'else
					'0';

end Behavioral;
