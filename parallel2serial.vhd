library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parallel2serial is
port(

	clk				:	in std_logic;
	data_in			:	in	std_logic_vector (27 downto 0);
	reset				:	in std_logic;
	reset_framer	:	in std_logic;
	write_enable	:	in std_logic;
	wait_fr			:	in std_logic;
	
	data_out			:	out std_logic;
	fifo_full		:	out std_logic
	
);
end entity;

architecture arch of parallel2serial is

component framer is
port(

	clk				:	in std_logic;
	data_in			:	in	std_logic_vector (27 downto 0);
	reset				:	in std_logic;
	is_fifo_empty	:	in std_logic;
	wait_fr			:	in std_logic;
	
	data_out			:	out std_logic;
	read_enable		:	out std_logic

	
);
end component;

 component fifo is
 port(
 	reset, clk, write_en, read_en	:	in std_logic;
 	data_in		:		in std_logic_vector(27 downto 0);

 	full, empty		:		out std_logic;
 	data_out		:		out std_logic_vector(27 downto 0)
 );
 end component;

 signal fifo_out		:	std_logic_vector(27 downto 0);
 signal fifo_empty				:	std_logic;
 signal read_ena					:	std_logic;
 signal sreset						:	std_logic;
 
begin
	FI1	:	fifo port map (clk => clk, reset => reset, write_en => write_enable, read_en => read_ena, data_in => data_in, data_out => fifo_out, full => fifo_full, empty => fifo_empty);
	FR1	:	framer port map(clk => clk, reset => sreset, data_in => fifo_out, read_enable => read_ena, data_out => data_out, is_fifo_empty =>fifo_empty, wait_fr => wait_fr);
	

	sreset <= (reset OR reset_framer);

end arch;