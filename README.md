# Miniprojet_RISC_V
SEI 2A projet semestre 8

## Compilateur RV32I
Afin de pouvoir réaliser nos testbench, nous avons eu besoin de réaliser un compilateur permettant de passer d'un code assembleur *RV32I* à un code machine. Pour cela nous avons réulitliser le compilateur réaliser lors du projet d'informatique du semestre 7.

### Usage
Pour compiler un fichier assembleur, il suffit de suivre la syntaxe suivante :
```
rv32icomp.exe source_file regexps_file binfile [-v]
```
| Syntax | Description |
|---------------|--------------------|
| `source_file` | Code source à lire |
| `regexps_file` | Fichier contenant la syntaxe souhaitée (il est recommandé d'utiliser le fichier `database.txt`) |
| `binfile` | Nom du fichier binaire à générer |
| `-v` | Affiche la progression du parsing |

### Fonctionnalités
Le compilateur est capable de compiler tous le jeu d'instruction *RV32I* sans extentions à l'exception des instructions suivantes :
- `csrrw`
- `csrrs`
- `csrrc`
- `csrrwi`
- `csrrsi`
- `csrrci`
- `ecall`
- `ebreak`
- `fence`
- `fence.i`

Le compilateur est capable de compiler les instructions suivantes n'étant pas pris en charge par le processeur cible :
- `j` remplacé par `jal r6,offset`
- `li` remplacé par `addi rd,zero,imm`
- `mv` remplacé par `add rd,rs1,zero`
- `ble` (pas encore supporté)

Le compilateur ajoute aussi automatiquement deux instructions `NOP` après chaque instruction de branchement.

Enfin il fait reboucler automatiquement le programme sur lui même à la fin du code source.

### Compilation
Il est possible de compiler un exécutable sous Windows via **MinGW** en exécutant `wincompile.bat` ou sous Linux via *WSL* en exécutant `compile.bat`.
Les deux scripts génèrent un exécutable nommé `rv32icomp.exe` dans le dossier `bin`, et l'exécute avec des du code de test sous valgrind pour `compile.bat`.

Sous linux il est possible de compiler le compilateur en utilisant la commande `make`, **cependant le makefile n'a pas été testé depuis la mise à jour du projet**.

### Limitations
Le compilateur n'a pas été entièrement testé, il est possible qu'il ne fonctionne pas correctement sur certains fichiers. 
