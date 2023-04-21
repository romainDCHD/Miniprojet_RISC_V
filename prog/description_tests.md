# asm_load.bin
 `but`:  tester les LUI:
   - effectuer un load immédiat de 2 dans le registre 1
   - 6 dans le reg 2
   - 4 dans le reg 2

 `avancement`: réussi

# asm_add.bin
 `but`:  tester add sans problèmes:
   - effectuer un load immédiat (LUI) de 2 dans le registre 0
   - LUI de 4 dans le reg 2
   - faire un add de R0 et R1 et le stocker dans R2 sans dépendance de données

 `avancement`: réussi

# asm_add_pb.bin
   `but`:  tester add avec dep. de données:
   **dépendance d'un cran**
   - effectuer un load immédiat de 2 dans le registre 0
   - LUI de 4 dans le reg 1
   - faire un add de R0 et R1 et le stocker dans R2 
   - faire un add de R0 et R2 et le stocker dans R3 
   **dépendance de 2 crans**
   - LUI de 2 dans le registre 3
   - faire un add de R0 et R3 et le stocker dans R4 
   - faire un add de R0 et R4 et le stocker dans R5 
   - faire un add de R0 et R5 et le stocker dans R6 

   `avancement`: réussi 

# asm_bge.bin
 `but`:  tester les BGE et AUIPC:
   **load des valeurs pour la comparaison**
   - effectuer un load immédiat de 8 dans le registre 1
   - LUI de  6 dans le reg 2
   **pour voir si le branchement est pris**
   - AUIPC de 32770 et PC dans R3
   - LUI de  4 dans le reg 2
   **comparaison en elle même**
   - BGE avant le auicp tout le temps pris

 `avancement`: écrit

# asm_bjal.bin
 `but`:  tester le JAL:
   **load des valeurs pour le add**
   - effectuer un load immédiat de 2 dans le registre 0
   - LUI de 4 dans le reg 2
   **pour voir si le bjump est pris**
   - ADD de R0 et R1 et le stocker dans R0
   **le jump à tester qui va pointer vers le ADD**
   - JAL de offset  et rd=R3

 `avancement`: écrit

# asm_triple_dependance.bin
 `but` :  tester la triple dépendance: du type
  ```
  a = a + b
  c = b + d
  e = d + a
  ```
  Charge 5 variable de a à e dans les registres de a0 à a4.
  Fait les 3 sommes

  **Valeurs attendues:**
  - a = 3
  - b = 2
  - c = 5
  - d = 3
  - e = 4

 `avancement`: Validé