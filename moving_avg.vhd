library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
-- we use integer data type when we dont need bit level manipulation 
--generic are a way to define congigurable constants
--it sums the vectors together 
--we will sum 16 vector each of 8 bit so to store this sum we need to know the number of bits required to store the sum 
entity moving_avg is
--we define the generic variable which is another way to define a conffigurable constatnt in vhdl
--so we need 12 bit to store the sum 
generic(
sample_count:integer:=16); 
port (
clk,reset:in std_logic;
data_in :in std_logic_vector(7 downto 0);
outp:out std_logic_vector (11 downto 0));
end entity;

architecture logic of moving_avg is 
--we need to create the array for the sliding window 
--this will create an array with 32 row each row containning 8 bits 
type movingavg is array(sample_count downto 1)of std_logic_vector(7 downto 0);
signal window :movingavg;
--to store the summ
signal sum :unsigned(11 downto 0);
--this to know by how many bit should we shift to be like performing a devision by the number of samples (the length of the vindow)
--we need to store the avg after we avg
constant shift_bits:integer := integer( log2(real(sample_count)));
signal avg :std_logic_vector(11 downto 0);

begin
process(clk,reset) is
begin
if reset='1' then window <= (others => (others => '0'));
   sum<=( others=>'0');
elsif clk'event and clk='1' then
-- we need to update the window 
window<=data_in & window (sample_count- 1 downto 1);
--to perform the sum we need to sum the sum and the new entered sample (the data_in )and subscribing the last element of the array (like a shift register )
	sum<= sum + unsigned(data_in) - unsigned(window(1));
--srl:shift right logical (shift 0 to the left in order to perform division 
	avg<= std_logic_vector(unsigned(sum srl shift_bits));--srl is performed on slv
end if;
end process;
outp<=avg;
end logic;

