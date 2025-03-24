module mini_cpu (
    input wire [17:0] info, // switchs
    input b1, b2, // botões
    input clk, // clock

    output reg [2:0] op_code, // informaçoes para a ula
    output reg [3:0] src1, src2, src3,
    output reg signed [6:0] imm,
    input wire signed [15:0] result, // saídas da ula
    input wire [1:0] estado_memoria
);

reg [1:0] estado_ligar, estado_enviar;
parameter desligado = 0, ligando = 1, ligado = 2, desligando = 3;
parameter inicial = 0, espera = 1, enviado = 2;
reg ligar, enviar;

reg signed [15:0] registers [15:0];

initial begin
    integer i;
    for (i = 0; i < 16; i=i+1) begin
        registers[i] = 0;
    end
    estado_ligar = desligado;
    estado_enviar = inicial;
end

always @(*) begin
    case (estado_ligar)
        desligado: ligar = 0;
        ligando: ligar = 0;
        ligado: ligar = 1;
        desligando: ligar = 0;
        default: ligar = ligar;
    endcase

    case (estado_enviar)
        inicial: enviar = 0;
        espera: enviar = 0;
        enviado: enviar = 1;
        default: enviar = ligar;
    endcase
end

always @(posedge clk) begin
    case (estado_ligar)
        desligado: if (b1 == 0) estado_ligar <= ligando;
        ligando: if (b1 == 1) estado_ligar <= ligado;
        ligado: if (b1 == 0) estado_ligar <= desligando;
        desligando: if (b1 == 1) estado_ligar <= desligado;
        default: estado_ligar <= estado_ligar;
    endcase

    if (ligar) begin
        case (estado_enviar)
            inicial: if (b2 == 0) estado_enviar <= espera;
            espera: if (b2 == 1) estado_enviar <= enviado;
            enviado: estado_enviar <= inicial;
            default: estado_enviar <= estado_enviar;
        endcase
    end else estado_enviar <= inicial;

    if (enviar) begin
        op_code = info[17:15];
        src1 = info[14:11];
        src2 = info[10:7];
        src3 = info[6:3];
        imm = info[6:0];
        if (info[6]) imm = {1'b1, -(info[5:0])};
        else imm = {1'b0, info[5:0]};
    end
end
endmodule