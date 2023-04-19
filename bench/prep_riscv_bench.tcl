#ajout de rst et clk 
add wave sim:/bench_riscv/*
#ajout du tableau instruction
add wave -position insertpoint  \
sim:/bench_riscv/riscv1/imem1/tab_inst
#ajout de la mémoire donnée
add wave  \
sim:/bench_riscv/riscv1/mem1/mem
#ajout de pc et next_instruction 
add wave  \
sim:/bench_riscv/riscv1/imem1/inst_out
add wave -position insertpoint  \
sim:/bench_riscv/riscv1/imem1/pc
#rajouter tous les signaux des modules
add wave -group riscv sim:/bench_riscv/riscv1/*
add wave -group imem sim:/bench_riscv/riscv1/imem1/*
add wave -group wb sim:/bench_riscv/riscv1/wb1/*
add wave -group regfile sim:/bench_riscv/riscv1/regfile1/*
add wave -group opti sim:/bench_riscv/riscv1/opti1/*
add wave -group imm_gen sim:/bench_riscv/riscv1/imm_gen1/*
add wave -group alu sim:/bench_riscv/riscv1/alu1/*
add wave -group mem sim:/bench_riscv/riscv1/mem1/*
add wave -group control_logic sim:/bench_riscv/riscv1/control_logic1/*
add wave -group wb sim:/bench_riscv/riscv1/wb1/*
#run
run 7650