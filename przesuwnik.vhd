library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity przesuwnik is
port(

	clk				:	in std_logic;
	data_in			:	in	std_logic_vector (23 downto 0);
	reset				:	in std_logic;
	
	data_out			:	out std_logic;
	read_enable		:	out std_logic	

	
);
end entity;

architecture Behavioral of przesuwnik is

type FSM_state is (init, shift23, last_shift);

signal data_reg : std_logic_vector(23 downto 0);
signal current_state, next_state : FSM_state;
signal counter : unsigned (4 downto 0);

begin
	
	process(clk, reset)
	begin
		
		if(reset = '1') then
			next_state <= init;
		elsif(rising_edge(clk)) then
			case current_state is
			
				when init =>
					--read_enable <= '1';
					next_state <= shift23;
					counter <= to_unsigned(0,5);
					data_reg <= data_in;
					
				when shift23 =>
					
					data_reg(22 downto 0) <= data_reg(23 downto 1);
					
					if(counter = 22) then
						counter <= to_unsigned(0,5);
						next_state <= last_shift;
					else
						counter <= counter+1;
						next_state <= shift23;
					end if;
				
				when last_shift =>
					--read_enable <= '1';
					next_state <= shift23;
					data_reg <= data_in;
			end case;
		end if;
		
	end process;
	
		current_state <= next_state;
		
		data_out 	<= data_reg(0) when next_state =shift23 else
							data_reg(0) when next_state =last_shift else
							'0';
						
		read_enable <= '1' when next_state = init			 	else 
							'1' when next_state = last_shift 	else
							'0';

end Behavioral;