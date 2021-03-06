library ieee;
use ieee.std_logic_1164.all;

entity control is
     port (    instr : in std_logic_vector(31 downto 0);

               -- regfile controls
               ctrl_reg_wren                 : out std_logic;
               ctrl_rt_mux                 : out std_logic_vector(1 downto 0);
               ctrl_reg_input_mux			: out std_logic;
			   
               -- alu controls 
               ctrl_alu_opcode		         : out std_logic_vector(2 downto 0);
			   ctrl_sign_ex_mux              : out std_logic;
			   
               -- branch controls
               ctrl_beq                       : out std_logic;
               ctrl_bgt						 : out std_logic;
               ctrl_jump			          : out std_logic;
               ctrl_jr                       : out std_logic;
               ctrl_jal                      : out std_logic;

               -- dmem controls
               ctrl_dmem_wren                : out std_logic ;
               ctrl_alu_dmem                 : out std_logic; -- selects between dmem output or ALU output 
			   ctrl_dmem_read			     : out std_logic;
               -- other controls
               ctrl_keyboard_ack             : out std_logic;
               ctrl_lcd_write                : out std_logic);
end control;


architecture behavior of control is

signal opcode : std_logic_vector(4 downto 0);
signal ctrl_reg_wren_temp, ctrl_dmem_wren_temp, ctrl_pc_wren_temp, ctrl_jump_temp : std_logic;

begin

     opcode <= instr(31 downto 27); 

     ctrl_reg_wren_temp <= '0' when opcode = "01000" else
						   '0' when opcode = "01001" else
						   '0' when opcode = "01010" else
						   '0' when opcode = "01011" else 
                           '0' when opcode = "01100" else
                           '0' when opcode = "01111" else
                           '1';
    
     ctrl_rt_mux <=   "00" when opcode = "00000" else
					  "00" when opcode = "00001" else
					  "00" when opcode = "00010" else
					  "00" when opcode = "00011" else
					  "00" when opcode = "00100" else
					  "00" when opcode = "00101" else
					  "01" when opcode = "00111" else 
                      "01" when opcode = "01000" else
                      "01" when opcode = "01001" else
                      "01" when opcode = "01010" else
                      "10"; 

     ctrl_sign_ex_mux <= '1' when opcode = "00110" else 
                         '1' when opcode = "00111" else 
                         '1' when opcode = "01000" else 
                         '0';

     ctrl_alu_opcode <= "000" when opcode = "00000" else
                        "001" when opcode = "00001" else
                        "010" when opcode = "00010" else
                        "011" when opcode = "00011" else
                        "100" when opcode = "00100" else
                        "101" when opcode = "00101" else
                        "000" when opcode = "00110" else
                        "001" when opcode = "01001" else
                        "001" when opcode = "01010" else
                        "000";
     

     ctrl_beq <= '1' when opcode = "01001" else
				 '0';
				 
	 ctrl_bgt <= '1' when opcode = "01010" else
				 '0';

     ctrl_jal <= '1' when opcode = "01101" else
                 '0';
     
     ctrl_jr <= '1' when opcode = "01011" else
                '0';

     ctrl_alu_dmem <= '1' when opcode = "00111" else
                      '0';

	 ctrl_jump_temp <= '1' when opcode = "01011" else
					   '1' when opcode = "01100" else
					   '1' when opcode = "01101" else
					   '0';
					   
--     ctrl_pc_wren_temp <= '1' when opcode = "01001" else
--                          '1' when opcode = "01010" else
--                          '1' when opcode = "01011" else
--                          '1' when opcode = "01100" else
--                          '1' when opcode = "01101" else
--                          '0';
    
     ctrl_dmem_wren_temp <= '1' when opcode = "01000" else
                            '0';
                   
	 ctrl_reg_input_mux <= '1' when opcode = "01110" else
						   '0';
						   
     ctrl_reg_wren <= ctrl_reg_wren_temp;
     --ctrl_pc_wren <= ctrl_pc_wren_temp after 10ns;
     ctrl_dmem_wren <= ctrl_dmem_wren_temp;
	 ctrl_dmem_read <= '1' when opcode = "00111" else
					   '0';
	 ctrl_jump <= ctrl_jump_temp;

     ctrl_keyboard_ack <= '1' when opcode = "01110" else
						  '0';
     
      ctrl_lcd_write <= '1' when opcode = "01111" else
						'0';
						
end behavior;
