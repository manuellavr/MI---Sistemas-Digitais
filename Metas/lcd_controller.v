module lcd_controller(

	// Entradas
	 input Clock,  // 50  MHz
	 input Reset,
	 input Modo_OP[1:0],

	// Saídas

	 output LCD_EN,
	 output LCD_RS,
	 output LCD_RW,
	 output LCD_DADOS[7:0], 
	);

	// Estados

    parameter   [2:0]   INIT = 3'b000,
                        CONFIG = 3'b001,
                        CONFIG_2 = 3'b010,
                        FUNCTION_SET = 3'b011,
                        DISPLAY_OFF = 3'b100,
                        DISPLAY_CLEAR = 3'b101,
                        ENTRY_MODE = 3'b110,
                        DISPLAY_ON = 3'b111;


    // Tempos de delay. Clock de 50MHz

    parameter [21:0]
              tn_40ms = 22'd2000000, // 2000000 clk cycles
              tn_4_1ms = 22'd205000, // 205000 clk cycles
              tn_100us = 22'd5000, // 5000 clk cycles 
              tn_250ns = 4'd13;	// 13 clk cycles

    parameter [7:0]
              letra_A = 8'b01000001; // Testar escrita 


    reg [2:0] next, reg_state;
    reg reg_en, reg_rs, reg_rw;
    reg [7:0] reg_db;
    reg [21:0] time_counter;
    reg num_of_lines, cursor_direction;
    reg [3:0] enable_delay_count;  

    num_of_lines = Modo_OP[1];
    cursor_direction = Modo_OP[0];

    assign LCD_EN = reg_en;
    assign LCD_RS = reg_rs;
    assign LCD_RW = reg_rw;
    assign reg_db = LCD_DADOS;

    reg_rw = 1'b0;      // Sempre escreve

    time_counter = 22'd0;
    enable_delay_count = 4'd0;

    always @ (posedge Clock or posedge Reset) begin
        if (Reset) begin
            reg_state <= 3'b000;
        end
        else begin
            reg_state <= next;
        end
    end


    always @ (posedge Clock or reg_state) begin
        
        if(reg_en == 1'b1) begin
        	if(enable_delay_count == tn_250ns) begin
	        	enable_delay_count <= 4'd0;
	    		time_counter <= 22'd0;
	            next <= reg_state + 1;
	            reg_en <= 1'b0;	
        	end
        	else begin
        		enable_delay_count <= enable_delay_count + 1;	
        	end	
        end


        case (reg_state)
            INIT: begin
                         if (time_counter == tn_40ms) 
                            begin 
                                reg_rs <= 1'b0;
                                reg_db <= 8'b00110000;
                                reg_en <= 1'b1;
                            end
                         else                
                            begin   
                                time_counter <= time_counter + 1;
                                next <= INIT; 
                            end
                    end

            CONFIG:  begin
                        if(time_counter == tn_4_1ms)
                            begin
                                reg_rs <= 1'b0;
                                reg_db <= 8'b00110000;
                                reg_en <= 1'b1;
                            end
                        else begin
                            time_counter <= time_counter + 1;
                            next <= CONFIG;
                        end
                    end

            CONFIG_2: begin
                        if(time_counter == tn_100us)
                            begin
                                reg_rs <= 1'b0;
                                reg_db <= 8'b00110000;
                                reg_en <= 1'b1;
                            end
                        else begin
                            time_counter <= time_counter + 1;
                            next <= CONFIG_2;
                        end             
                      end

            FUNCTION_SET: begin               // Tem coisas ajustáveis
                        reg_rs <= 1'b0;
                        reg_db <= {4'b0011, num_of_lines, 3'b000};
                        reg_en <= 1'b1;
                    end

            DISPLAY_OFF: begin
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00001000;
                        reg_en <= 1'b1;
                    end

            DISPLAY_CLEAR: begin
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00000001;
                        reg_en <= 1'b1;
                    end
            ENTRY_MODE: begin                   // Tem coisas ajustáveis
                        reg_rs <= 1'b0;
                        reg_db <= {6'b000001, cursor_direction, 1'b0};
                        reg_en <= 1'b1;
                    end
            DISPLAY_ON: begin
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00001100; 
                        reg_en <= 1'b1;
                    end
            WRITE_CHAR: begin
                        reg_rs <= 1'b1;
                        reg_db <= letra_A;
                        reg_en <= 1'b1;
            		end
            IDLE: begin
                    reg_rs <= 1'b0;
                    reg_db <= 8'b0;
                    reg_en <= 1'b0;
                    next <= IDLE;
           			end

        endcase
    end

endmodule