library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity first is
	port(
--			sw1:  in std_logic_vector(1 downto 0);
--			sw2:  in std_logic_vector(1 downto 0);
			clk : in  STD_LOGIC;

			led: out std_logic_vector(3 downto 0);
						
			-- USB ports controller --
			usb_data: inout std_logic_vector(7 downto 0);
			rd, wr: out std_logic;
			rxf, txe: in std_logic;
		
			-- IR port --
			ir: in std_logic
		);
end first;


architecture acexfirst_arch of first is
	
	constant RAM: integer:= 15;
	constant COUNT_DATA_IR: integer:=10;
	constant CODE_GET_DATAIR: std_logic_vector(7 downto 0):=x"A3";
	
	signal usb_send_code: std_logic; -- need send data_ir USB to computer
	signal usb_send_ok: std_logic; -- send data_ir to computer is finish
	
	signal usb_byte: std_logic_vector(7 downto 0):=x"00"; -- data from computer(USB)
	signal usb_byte_read: std_logic:='0'; -- need read data from USB (signal usb_byte)
	signal usb_byte_read_ok: std_logic:='0'; -- one byte is read(signal usb_byte)
	signal usb_byte_read_wait: std_logic:='1'; -- YY should take usb_byte
	
	signal data_ir: std_logic_vector(7 downto 0);   -- for send USB, 1 interval IR-tact
													-- data_ir is send array inteval IR (array now 0 to 10). Value maybe 0 to 255, becouse 8 bit.
	signal data_ir_count: std_logic_vector(7 downto 0); -- for send USB, count intervals IR-tact gets in data_ir
	signal data_ir_get: std_logic:='0'; -- need get new data_ir
	signal data_ir_get_end: std_logic:='0'; -- get new data_ir finish
	
	signal usb_predefined_data_ir: std_logic_vector(7 downto 0):=x"00"; -- ir send data_ir to usb
	-- signal usb_definition_data_ir: std_logic; -- ir send data_ir to usb
	
	
	begin


	--===========
	--=== USB ===
	--===========
	
	process (clk)--, usb_data) 
	
		----- IN -----
		-- rxf
		-- twe
		--
		-- usb_send_code
		--
		-- data_ir (8 bit)
		-- data_ir_count (8 bit)
		--
		-- usb_byte_read_ok
		-- usb_byte_read_wait
		--
		-- --usb_definition_data_ir
		--
		-- clk
		
		----- OUT -----
		-- rd
		-- wr
		--
		-- usb_send_ok
		--
		-- usb_byte (8 bit)
		-- usb_byte_read
		--
		-- usb_predefined_data_ir (8 bit)
		
		----- INOUT -----
		-- usb_data (8 bit)


		variable rxf_buf, rd_buf: std_logic:='1';
		variable txe_buf, wr_buf, wr_en: std_logic:='0';
		
		-- tacts read or write with usb_controller
		variable counter_rd, counter_wr: integer range 0 to 15; --std_logic_vector(1 downto 0):="00";
		
		-- byte 
		variable data_rd_byte, data_wr_byte: std_logic_vector(7 downto 0):=x"00";
		-- ram
		type tdata_ram is array(RAM downto 1) of std_logic_vector(7 downto 0);
		variable data_rd_ram, data_wr_ram: tdata_ram;
		variable count_data_rd_ram, count_data_wr_ram: std_logic_vector(7 downto 0):=x"00"; --(15 downto 0):=x"0000";
		variable need_fill_data_wr_ram: std_logic:='1';
		
		-- action
		variable action_usb_send_code: integer:=0;
		
		-- clk
--		variable count_clk:std_logic_vector(63 downto 0):= x"0000_0000_0000_0000";
--		variable run_clk:std_logic:='0';
--		variable send_clk:std_logic:='0';
--		variable this_clk:std_logic:='0';
	begin
		if clk='1' and clk'event then 
			
--			if (need_fill_data_wr_ram = '1') then
--				data_wr_ram(1) := x"01";
--				for i in 2 to RAM loop
--					data_wr_ram(i) := conv_std_logic_vector(i, 8);
--				end loop;
--				need_fill_data_wr_ram := '0';
--			end if;
			
			
			rxf_buf := rxf;
			txe_buf := txe;
			
			------------------------------
			-- Condition read and write --
			------------------------------
			
			-- Read from FT245RL --
			
			if (rxf_buf = '0' and counter_rd = 0 and counter_wr = 0) then  -- есть данные
				counter_rd := counter_rd + 1;
				rd_buf := '0';
			elsif counter_rd = 1 then -- принимаю данные
				counter_rd := counter_rd + 1;
			elsif counter_rd = 2 then -- принимаю данные и завершаем прием данных
				counter_rd := counter_rd + 1;
				rd_buf := '1';
			elsif counter_rd = 3 and rxf_buf = '1' then -- закрытие приема данных
				counter_rd := 0;
			end if;
			
	
			-- Write to FT245RL --
			
			-- 0
			if  (counter_wr = 0 and counter_rd = 0 and wr_en = '1' and count_data_wr_ram /= x"00_00") then -- есть данные
				counter_wr := counter_wr + 1;
				-- !!! run_clk := '1';
			-- 1
			elsif (counter_wr = 1 and txe_buf = '0') then -- отправляем данные
				counter_wr := counter_wr + 1;
			-- 2 
			-- 3
			-- 4
			elsif (counter_wr = 2 or counter_wr = 3 or counter_wr = 4) then -- завершаем отправку данных
				counter_wr := counter_wr + 1;
			-- 5
			elsif (counter_wr = 5 and txe_buf = '1') then -- закрытие отправки данных
				count_data_wr_ram := count_data_wr_ram - 1;
				if (count_data_wr_ram /= 0) then
					counter_wr := 1; 
				else
					counter_wr := 0;
--					run_clk := '0';
--					if (this_clk = '0') then
--						send_clk := '1';
--					end if;
				end if;
			end if;

			
			---------------------------
			-- Action read and write --
			---------------------------
			
			-- Write --
			
			case counter_wr is
				when 1 =>
					usb_data <= data_wr_ram(conv_integer(count_data_wr_ram));
				when 2|3 => 
					wr_buf := '1';
				when 5 =>
					wr_en := '0';
				when others => 
					wr_buf := '0';
			end case;
			
			-- Read --
			
			if  (counter_rd = 2) then
				data_rd_byte := usb_data;
				count_data_rd_ram := count_data_rd_ram + 1;
				
				case data_rd_byte is
					--when CODE_GET_DATAIR => 
						--wr_en := '1';
						--count_data_wr_ram := x"00_01";
						--data_wr_ram(1) := data_rd_byte + 5;
--					when x"A2" => 
--						wr_en := '1';
--						count_data_wr_ram := x"00_32"; -- d50
----						this_clk := '0';
					when others => 
						wr_en := '0';
						count_data_wr_ram := x"00";--x"00_00";
				end case;
			end if;

			------------------
			-- Send data_ir --
			------------------
			
			if (action_usb_send_code = 0 and usb_send_code = '1' and counter_wr = 0 and counter_rd = 0) then
				if (usb_predefined_data_ir < COUNT_DATA_IR
					and 
					usb_predefined_data_ir = data_ir_count) 
				then
					-- fill data_wr_ram from ir_array
					data_wr_ram( conv_integer(usb_predefined_data_ir)) := data_ir;
					usb_predefined_data_ir <= usb_predefined_data_ir + 1;
				else
					action_usb_send_code := action_usb_send_code + 1;
					
					wr_en := '1';
					count_data_wr_ram := conv_std_logic_vector(COUNT_DATA_IR, 8);--16);
				end if;
			elsif (action_usb_send_code = 1 and usb_send_code = '1') then
				action_usb_send_code := action_usb_send_code + 1;
				usb_predefined_data_ir <= x"00";
				usb_send_ok <= '1';
			elsif (action_usb_send_code = 2 and usb_send_code = '0') then
					action_usb_send_code := action_usb_send_code + 1;
					usb_send_ok <= '0';
			elsif (action_usb_send_code = 3) then					
					action_usb_send_code := 0;
			end if;	
			
--			if (run_clk = '1') then
--				count_clk := count_clk + 1;
--			end if;
			
--			if (send_clk = '1') then
--				send_clk := '0';
--				this_clk := '1';
--
--				data_wr_ram(1) := count_clk(7 downto 0);
--				data_wr_ram(2) := count_clk(15 downto 8);
--				data_wr_ram(3) := count_clk(23 downto 16);
--				data_wr_ram(4) := count_clk(31 downto 24);
--
--				wr_en := '1';
--				count_data_wr_ram := x"00_04";
--
--			end if;
			
			-----------------------------------------------
			-- Transmit recived byte from computer to YY --
			-----------------------------------------------
			
			-- new byte from computer, inform YY if that is possible
			if (usb_byte_read_wait='1' and count_data_rd_ram /= x"00") then
				usb_byte_read <= '1';
			-- YY read byte and inform hereof USB (this)
			elsif (usb_byte_read_wait='0' and usb_byte_read_ok='1') then --usb_send_code
				count_data_rd_ram := x"00";--x"00_00"; -- !!! count_data_rd_ram - 1;
				usb_byte_read <= '0';
			end if;
			
			----------------
			-- Put result --
			----------------

			usb_byte <= data_rd_byte; 
				data_rd_byte := x"00";
			rd <= rd_buf;
			wr <= wr_buf;
			
			if  (counter_rd = 0 and counter_wr = 0) then
				usb_data <= "ZZZZZZZZ";
			end if;
			
			led(0) <= usb_send_code;			
--			usb_byte <= count_data_rd_ram(7 downto 0);	
--			led <= CONV_STD_LOGIC_VECTOR(counter_wr,4);
--			led(2 downto 0) <= conv_std_logic_vector(action_usb_send_code, 3);
--			led(3) <= usb_send_code;
		end if; -- clk='1' and clk'event
	end process;
	
	--==========
	--=== IR ===
	--==========
	
	process (clk)

		----- IN -----
		-- ir
		--
		-- data_ir_get
		--
		-- usb_predefined_data_ir (8 bit)

		----- OUT -----
		-- data_ir_get_end
		-- data_ir (8 bit)
		-- data_ir_count (8 bit)
		--
		-- usb_definition_data_ir
	

		type t_ir_array is array (COUNT_DATA_IR-1 downto 0) of std_logic_vector(7 downto 0);
		
		variable ir_array: t_ir_array; -- array containig values ir_tact
		variable ir_tact_count: std_logic_vector(7 downto 0):=x"00";
		variable ir_buf, ir_buf_before: std_logic:='0';
		variable ir_tact: std_logic_vector(7 downto 0):=x"00";
		
		variable data_ir_get_before: std_logic:='0';
		
		variable action_IR: integer  range 0 to 3:=0;
		
	begin
		
		if (clk='1' and clk'event) then
			

			if (action_IR = 0 and data_ir_get='1') then

								
				ir_tact := ir_tact + 1;	
				
				-- Poluchenie massiva s tactami
				if ( ir_tact_count < COUNT_DATA_IR-1 ) then
					
					ir_buf_before := ir_buf;
					ir_buf := ir;
				
					if (ir_buf /= ir_buf_before) then
						--ir_tact := x"05";
						ir_array(conv_integer(ir_tact_count)) := ir_tact;
						--ir_tact:=x"00";
						ir_tact_count := ir_tact_count + 1;
					end if;
					
				else
					action_IR := action_IR + 1;
					data_ir_get_end <= '1';
				end if;
			-- 
			elsif (action_IR = 1 and data_ir_get = '0') then
				data_ir <= ir_array( conv_integer(usb_predefined_data_ir));
				data_ir_count <= usb_predefined_data_ir after 10ns;
				
				if (usb_predefined_data_ir = COUNT_DATA_IR-1) then
					action_IR := action_IR + 1;
				end if;
			--
			elsif (action_IR = 2) then
				action_IR := 0;
			end if; -- (data_ir_get='1')
			
			-- Clear ir_tact_count. If data_ir_get now front up
			if (data_ir_get_before='0' and data_ir_get = '1') then
				ir_tact_count := x"00";
			end if;
			
			data_ir_get_before := data_ir_get;
			
			-- Zakonchili vichitivat tacti
--			if    (ir_tact_count >= COUNT_DATA_IR and data_ir_get='1') then
--				data_ir_get_end <= '1';
--				data_ir_count <= ir_tact_count;
--			elsif (ir_tact_count >= COUNT_DATA_IR and data_ir_get='0') then
--				data_ir_get_end <= '0';
--				data_ir_count <= ir_tact_count;
--			else
--				data_ir_get_end <= '0';
--				data_ir_count <= x"00";
--			end if;			
			
--			led <= usb_predefined_data_ir(3 downto 0);
--			led(1 downto 0) <= conv_std_logic_vector(action_IR, 2);
--			led(0) <= data_ir_get;
--			led(1) <= data_ir_get_before;
			
		end if; -- (clk='1' and clk'event)
	end process;
	
	
	--==========
	--=== YY ===
	--==========
	
	process(clk
			--usb_send_ok, 
			--usb_byte_read, 
			--data_ir_get_end
			)
		
		----- IN -----
		-- usb_send_ok
		--
		-- usb_byte (8 bit)
		-- usb_byte_read
		--
		-- data_ir_get_end
		
		----- OUT -----
		-- usb_send_code
		--
		-- usb_byte_read_ok
		-- usb_byte_read_wait
		-- 
		-- data_ir_get
		
		variable buf_usb_send_code: std_logic:='0';
		variable action_YY: integer range 0 to 7:=0;
		
	begin
		if clk='1' and clk'event then 
		
			-- Receive byte from USB and if code coincide with CODE_GET_DATAIR then receive ir_array and get her to computer
			if ( action_YY = 0 and usb_byte_read = '1' and usb_byte=CODE_GET_DATAIR) then
				action_YY := action_YY + 1;
				data_ir_get <= '1';	
				usb_byte_read_wait <= '0';
				
				-- send new ir_tact on usb to computer
				-- buf_usb_send_code := '1';

			-- ir_array received
			elsif (action_YY = 1 and data_ir_get_end = '1') then
				action_YY := action_YY + 1;
				data_ir_get <= '0';
				usb_byte_read_ok <= '1';
			elsif (action_YY = 2 and usb_byte_read = '0' and usb_send_ok = '0' ) then
				action_YY := action_YY + 1;
				usb_byte_read_ok <= '0';
				usb_byte_read_wait <= '1';
				
				usb_send_code <= '1';
			elsif (action_YY = 3 and usb_send_ok = '1') then
				action_YY := 0;
				usb_send_code <= '0';
			end if;
			
			led(1) <= usb_send_code;
			led(3 downto 2) <= conv_std_logic_vector(action_YY, 2);
--			led <= conv_std_logic_vector(action_YY, 4);
			
		end if; -- clk='1' and clk'event
	end process;
	
	-- output latest 4 bit on led
--	led(0) <= not ir;
--	led(1) <= data_ir_get;
--	led(2) <= data_ir_get_end;
--	led(3) <= usb_byte_read;
--
--	led(0) <= data_ir_get;
--	led(1) <= usb_byte_read_ok;
--	led(2) <= usb_byte_read_wait;
--	led(3) <= usb_byte_read;

--	led <= usb_byte(3 downto 0);
--	led <= counter_data_rd_ram(3 downto 0);

--	led(3 downto 0) <=  "0110" when usb_byte = x"33" else
--						"1001" when usb_byte = x"AA" else
--						usb_byte(3 downto 0);
	
		
end acexfirst_arch;