module dff(
    input clk, rst,
    input [31:0] d,
    output logic [31:0] q
);

always_ff @(posedge clk)
begin
    if (rst == 0)    q<=d;
    else q<= 0;
end


endmodule