module lcd_controller(

	// Entradas
	 input Clock,  // 50  MHz
	 input Reset,
	 input Dados[7:0],

	// Saídas

	 output LCD_EN,
	 output LCD_RS,
	 output LCD_RW,
	 output LCD_DADOS[7:0], 

	);



	// Estados

    parameter   [3:0]   INIT = 4'b0000,
                        CONFIG = 4'b0001,
                        CONFIG_2 = 4'b0010,
                        FUNCTION_SET = 4'b0011,
                        DISPLAY_OFF = 4'b0100,
                        DISPLAY_CLEAR = 4'b0101,
                        ENTRY_MODE = 4'b0110,
                        DISPLAY_ON = 4'b0111,
                        WRITE_CHAR = 4'b1000,
                        IDLE = 4'b1001;



    // Tempos de delay. Clock de 50MHz

    parameter [21:0]
              tn_40ms = 22'd2000000, // 2000000 clks
              tn_4_1ms = 22'd205000, // 205000 clks
              tn_100us = 22'd5000; // 5000 clks 

              
    parameter [7:0]
              letra_A = 8'b01000001; // Testar escrita 


    reg [2:0] next, reg_state;
    reg reg_en, reg_rs, reg_rw;
    reg [7:0] reg_db;
    reg [21:0] time_counter;


    assign LCD_EN = reg_en;
    assign LCD_RS = reg_rs;
    assign LCD_RW = reg_rw;
    assign reg_db = LCD_DADOS;

    reg_rw = 1'b0;      // Sempre escreve

    time_counter = 22'b0;



    always @ (posedge Clock or posedge Reset) begin
        if (Reset) begin
            reg_state <= 3'b000;
        end
        else begin
            reg_state <= next;
        end
    end


    always @ (posedge Clock) begin
        reg_en <= 1'b0;

        case (reg_state)
            INIT: begin
                         if (time_counter == tn_40ms) 
                            begin 

                                reg_rs <= 1'b0;
                                reg_db <= 8'b00110000;
                                reg_en <= 1'b1;
                                time_counter <= 22'b0;
                                next <= reg_state + 1;        
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
                                time_counter <= 22'b0;
                                next <= reg_state + 1;
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
                                time_counter <= 22'b0;
                                next <= reg_state + 1;
                            end
                        else begin
                            time_counter <= time_counter + 1;
                            next <= CONFIG_2;
                        end             
                      end

            FUNCTION_SET: begin               // Tem coisas ajustáveis
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00111000;
                        reg_en <= 1'b1;
                        next <= reg_state + 1;
                    end

            DISPLAY_OFF: begin
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00001000;
                        reg_en <= 1'b1;
                        next <= reg_state + 1;
                    end

            DISPLAY_CLEAR: begin
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00000001;
                        reg_en <= 1'b1;
                        next <= reg_state + 1; 
                    end
            ENTRY_MODE: begin                   // Tem coisas ajustáveis
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00000110;
                        reg_en <= 1'b1;
                        next <= reg_state + 1; 
                    end
            DISPLAY_ON: begin
                        reg_rs <= 1'b0;
                        reg_db <= 8'b00001100; 
                        reg_en <= 1'b1;
                        next <= DISPLAY_ON;
                    end
            WRITE_CHAR: begin
                        reg_rs <= 1'b1;
                        reg_db <= letra_A;
                        reg_en <= 1'b1;
                        next <= reg_state + 1;
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