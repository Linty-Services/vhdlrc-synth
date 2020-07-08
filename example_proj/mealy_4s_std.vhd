-- A Mealy machine has outputs that depend on both the fsm_state_mealy and
-- the inputs.	When the inputs change, the outputs are updated
-- immediately, without waiting for a clock edge.  The outputs
-- can be written more than once per fsm_state_mealy or per clock cycle.

library ieee;
use ieee.std_logic_1164.all;

entity mealy_4s_std is

	port
	(
		clk		 : in	std_logic;
		data_in	 : in	std_logic;
		reset	 : in	std_logic;
		data_out : out	std_logic_vector(1 downto 0)
	);
	
end entity;

architecture rtl of mealy_4s_std is

	-- Build an enumerated type for the fsm_state_mealy machine
	--type fsm_state_mealy_type is ("0001", "0010", "0100", "1000");
	
	-- Register to hold the current fsm_state_mealy
	signal fsm_state_mealy : std_logic_vector(3 downto 0);

begin
	process (clk, reset)
	begin
		if reset = '1' then
			fsm_state_mealy <= "0001";
		elsif (rising_edge(clk)) then
			-- Determine the next fsm_state_mealy synchronously, based on
			-- the current fsm_state_mealy and the input
			case        	
			fsm_state_mealy is
				when "0001"=>
					if data_in = '1' then
						fsm_state_mealy <= "0010";
					else
						fsm_state_mealy <= "0001";
					end if;
				when "0010"=>
					if data_in = '1' then
						fsm_state_mealy <= "0100";
					else
						fsm_state_mealy <= "0010";
					end if;
				when "0100"=>
					if data_in = '1' then
						fsm_state_mealy <= "1000";
					else
						fsm_state_mealy <= "0100";
					end if;
				when others =>
					if data_in = '1' then
						fsm_state_mealy <= "1000";
					else
						fsm_state_mealy <= "0010";
					end if;
			end case;
			
		end if;
	end process;
	
	-- Determine the output based only on the current fsm_state_mealy
	-- and the input (do not wait for a clock edge).
	process (fsm_state_mealy, data_in)
	begin
		case fsm_state_mealy is
			when "0001"=>
				if data_in = '1' then
					data_out <= "00";
				else
					data_out <= "01";
				end if;
			when "0010"=>
				if data_in = '1' then
					data_out <= "01";
				else
					data_out <= "11";
				end if;
			when "0100"=>
				if data_in = '1' then
					data_out <= "10";
				else
					data_out <= "10";
				end if;
			when others =>
				if data_in = '1' then
					data_out <= "11";
				else
					data_out <= "10";
				end if;
		end case;
	end process;
	
end rtl;
