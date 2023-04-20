# Benchs et modifications à effectuer
## bench_riscv.sv
- [ ]  Tester toutes les instructions
- [ ]  Ajout du support pour une triple dépendance
    - Exemple avec une triple dépendance sur `sp`
    ```asm
    addi    sp,sp,0
    sw      s0,48(sp)
    addi    s0,sp,48
    ```
    - [ ]  Réaliser la modification et mettre à jour les schémas
    - [ ]  Mettre à jour le code
    - [ ]  Tester le nouveau code et valider les résultats
- [ ]  Vérifier pourquoi les données n'arrivent pas sur `dataW` lors de l'écriture en mémoire

## Autres
- [ ]  Vérifier la triple dépendance de données
    - Exemple :
    ```
    a = a + b
    c = b + d
    e = d + a
    ```
    - [ ]  Faire le code et compiler
    - [ ]  Réaliser le bench
    - [ ]  Valider les résultats