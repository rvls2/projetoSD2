module ula (
    input [2:0] opcode,     // Opcode (3 bits)
    input [3:0] src1,       // Registrador 1 (4 bits)
    input [3:0] src2, 	 // Registrador 2 (4 bits)
	input [3:0] src3,
    input signed [6:0] imm,        // Imediato (6 bits)
    input clk,              // Clock
    input reset,            // Reset
    output reg [1:0] estado_memoria,   //nova variavel pra ver se vai limpar, mostrar ou escrever
    output reg signed [15:0] result,    // Resultado  (16 bits)
    output reg [7:0] display     // Display 
);

// Parametros:
parameter  LOAD = 3'b000, ADD = 3'b001, ADDI = 3'b010, SUB = 3'b011, SUBI = 3'b100, MUL = 3'b101, CLEAR = 3'b110, DISPLAY = 3'b111;
parameter CLEAN = 2'b00, WRITE = 2'b01, SHOW = 2'b10;

reg signed [15:0] registers [0:15]; // 16 registradores de 16 bits

initial begin
    registers[0]  = 16'b0;
    registers[1]  = 16'b0;
    registers[2]  = 16'b0;
    registers[3]  = 16'b0;
    registers[4]  = 16'b0;
    registers[5]  = 16'b0;
    registers[6]  = 16'b0;
    registers[7]  = 16'b0;
    registers[8]  = 16'b0;
    registers[9]  = 16'b0;
    registers[10] = 16'b0;
    registers[11] = 16'b0;
    registers[12] = 16'b0;
    registers[13] = 16'b0;
    registers[14] = 16'b0;
    registers[15] = 16'b0;
    result = 16'b0;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Zerando todos os registradores
        registers[0] <= 16'b0;
        registers[1] <= 16'b0;
        registers[2] <= 16'b0;
        registers[3] <= 16'b0;
        registers[4] <= 16'b0;
        registers[5] <= 16'b0;
        registers[6] <= 16'b0;
        registers[7] <= 16'b0;
        registers[8] <= 16'b0;
        registers[9] <= 16'b0;
        registers[10] <= 16'b0;
        registers[11] <= 16'b0;
        registers[12] <= 16'b0;
        registers[13] <= 16'b0;
        registers[14] <= 16'b0;
        registers[15] <= 16'b0;
        result <= 16'b0;
    end else begin
        case (opcode)
            ADD: begin
                result <= registers[src2] + registers[src3]; // Soma
                estado_memoria <= WRITE;
            end
            SUB: begin
                result <= registers[src2] - registers[src3];
                estado_memoria <= WRITE;
            end
            ADDI: begin
                  result <= registers[src2] + imm;
                  estado_memoria <= WRITE;
                
            end
            SUBI: begin
                  result <= registers[src2] - imm;
                  estado_memoria <= WRITE;
            end
            MUL: begin
                  result <= registers[src2] * imm;
                  estado_memoria <= WRITE;
            end
            LOAD: begin
                result <= imm;
                estado_memoria <=  WRITE;
            end
            CLEAR: begin
                // Zera todos os registradores
                registers[0] <= 16'b0;
                registers[1] <= 16'b0;
                registers[2] <= 16'b0;
                registers[3] <= 16'b0;
                registers[4] <= 16'b0;
                registers[5] <= 16'b0;
                registers[6] <= 16'b0;
                registers[7] <= 16'b0;
                registers[8] <= 16'b0;
                registers[9] <= 16'b0;
                registers[10] <= 16'b0;
                registers[11] <= 16'b0;
                registers[12] <= 16'b0;
                registers[13] <= 16'b0;
                registers[14] <= 16'b0;
                registers[15] <= 16'b0;
                estado_memoria <= CLEAN;
            end
            DISPLAY: begin
                estado_memoria <= SHOW;
            end
            default: begin
                result <= 16'b0;
            end
        endcase
            end
end

endmodule