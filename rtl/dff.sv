module dff(
    input clk,
    input [31:0] d,
    output logic [31:0] q
);

always_ff @(posedge clk)
begin
    q<=d;
end


endmodule