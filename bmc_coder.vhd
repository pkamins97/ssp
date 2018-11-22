library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bmc_coder is

port(
		clk4x		:	in std_logic;
		reset		:	in std_logic;
		input		:	in std_logic;
		
		output	:	out std_logic
);
end entity;

architecture arch of bmc_coder is

component freq_divx2 is
port(
		clk4x		:	in std_logic;
		reset		:	in std_logic;
		
		output	:	out std_logic
);
end component;


component freq_divx4 is
port(
		clk4x		:	in std_logic;
		reset		:	in std_logic;
		
		output	:	out std_logic
);
end component;

signal d4out, d2out : std_logic;

BEGIN
	D4	:	freq_divx4 port map(clk4x=>clk4x, reset=>reset, output=>d4out);
	D2	:	freq_divx2 port map(clk4x=>clk4x, reset=>reset, output=>d2out);
	
	output <= d2out WHEN input = '1' ELSE d4out;

END ARCH;






























