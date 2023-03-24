library verilog;
use verilog.vl_types.all;
entity control_logic is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        inst_i          : in     vl_logic_vector(31 downto 0);
        br_un_o         : out    vl_logic;
        br_eq_i         : in     vl_logic;
        br_lt_i         : in     vl_logic;
        A1_sel_o        : out    vl_logic;
        B1_sel_o        : out    vl_logic;
        A2_sel_o        : out    vl_logic;
        B2_sel_o        : out    vl_logic;
        alu_op_o        : out    vl_logic_vector(3 downto 0);
        mem_rw_o        : out    vl_logic;
        wb_sel1_o       : out    vl_logic;
        wb_sel2_o       : out    vl_logic;
        reg_w_en_o      : out    vl_logic;
        pc_sel_o        : out    vl_logic
    );
end control_logic;
