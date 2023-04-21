# asm_load.bin
 `but`:  tester les LUI:
    - effectuer un load immédiat de 2 dans le registre 1
    - 6 dans le reg 2
    - 4 dans le reg 2

 `avancement`: réussi

# asm_add.bin
 `but`:  tester add sans problèmes:
    - effectuer un load immédiat de 2 dans le registre 0
    - LUI de 4 dans le reg 2
    - faire un add de R0 et R1 et le stocker dans R2 sans dépendance de données

 `avancement`: réussi

# asm_add_pb.bin
   `but`:  tester add avec dep. de données:
   **dépendance d'un cran**
   - effectuer un load immédiat de 2 dans le registre 0
   - LUI de 4 dans le reg 2
   - faire un add de R0 et R1 et le stocker dans R2 direct après (donc avec dépendance de données)
   **dépendance de deu crans**
   - LUI de 2 dans le registre 3
   - LUI de 6 dans le reg 2
   - faire un add de R2 et R3 et le stocker dans R3 **ça marche??**

   `avancement`: écrit 

# asm_bge.bin
 `but`:  tester les BGE et AUIPC:
   **load des valeurs pour la comparaison**
   - effectuer un load immédiat de 8 dans le registre 1
   - LUI de  6 dans le reg 2
   **pour voir si le branchement est pris**
   - AUIPC de 32770 et PC dans R3
   **comparaison en elle même**
   - BGE de -5 d'offset tout le temps pris

 `avancement`: écrit