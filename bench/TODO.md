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
- [x]  Vérifier pourquoi les données n'arrivent pas sur `dataW` lors de l'écriture en mémoire

## Autres
- [x]  Vérifier la triple dépendance de données
    - Exemple :
    ```
    a = a + b
    c = b + d
    e = d + a
    ```
    - [x]  Faire le code et compiler
    - [x]  Réaliser le bench
    - [x]  Valider les résultats

# Synthèse
- [ ]  Réaliser la synthèse

# Placement routage
- [ ]  Réaliser le placement routage