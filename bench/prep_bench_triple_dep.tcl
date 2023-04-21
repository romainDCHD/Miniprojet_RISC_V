#ajout de rst et clk 
add wave sim:/bench_triple_dependance/*
#ajout du tableau instruction
add wave -position insertpoint  \
sim:/bench_triple_dependance/riscv1/imem1/tab_inst
#ajout de la mémoire donnée
add wave  \
sim:/bench_triple_dependance/riscv1/mem1/mem
#ajout de pc et next_instruction 
add wave  \
sim:/bench_triple_dependance/riscv1/imem1/inst_out
add wave -position insertpoint  \
sim:/bench_triple_dependance/riscv1/imem1/pc
#rajouter tous les signaux des modules
add wave -group riscv sim:/bench_triple_dependance/riscv1/*
add wave -group imem sim:/bench_triple_dependance/riscv1/imem1/*
add wave -group wb sim:/bench_triple_dependance/riscv1/wb1/*
add wave -group regfile sim:/bench_triple_dependance/riscv1/regfile1/*
add wave -group opti sim:/bench_triple_dependance/riscv1/opti1/*
add wave -group branch_comp sim:/bench_triple_dependance/riscv1/opti1/branch_comp1/*
add wave -group imm_gen sim:/bench_triple_dependance/riscv1/imm_gen1/*
add wave -group alu sim:/bench_triple_dependance/riscv1/alu1/*
add wave -group mem sim:/bench_triple_dependance/riscv1/mem1/*
add wave -group control_logic sim:/bench_triple_dependance/riscv1/control_logic1/*
add wave -group wb sim:/bench_triple_dependance/riscv1/wb1/*
#run
run 7650