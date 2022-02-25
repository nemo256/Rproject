#!/usr/bin/env Rscript

# Neggazi Mohamed Lamine, Raouf Chouik
# Grp 1 ISIL

# Le premier commentaire c'est pour que le system comprendre que c'est -
# un Rscript executable! et pour bien colorer le code!

# Ajout des package pour la generation du graph!
# et suppressMessages pour ne pas afficher des messages au ecran (mode silencieux)!
suppressMessages(library(network))
suppressMessages(library(sna))
suppressMessages(library(ggplot2))
suppressMessages(library(GGally))

# 'commandArgs' est Pour ajouter un argument dans l'execution de :
# Rscript 'ce_script.R' 'arg1.txt' 'arg2.txt'
# Le fichier 'arg1.txt' doit contenir la matrice
# et arg2.txt pour la composition!
args = commandArgs(trailingOnly = TRUE)

# Ce test est faite pour que il y'a 2 argument recever la matrice et la composition!
if (length(args) != 2)
    stop("Vous devez fournir deux fichiers!
==> Voir le fichier pdf associer pour le manual de ce programme SVP!", call. = FALSE)

# Importation des arguments recever (le fichier qui contien la matrice -
# et le 2eme fichier qui contien la composition!) dans R!
mat = read.table(args[1], header = F, blank.lines.skip = T, sep = "")
comp = scan(args[2], what = "", sep = "\n", quiet = T, multi.line = F)

comp <- strsplit(comp, "[[:space:]]+")
complength = length(readLines(args[2]))

names(comp) <- c(1:complength)

# Virifier que le nombre de lignes == le nombre de colons
if (length(rownames(mat)) != length(colnames(mat)))
    stop("Matrice introuvable!", call. = FALSE)

num = nrow(mat)

# Ajouter les noms des lignes et colons {M1, M2, M3, ...}
rownames(mat) = paste("M", c(1:num), sep = "")
colnames(mat) = paste("M", c(1:num), sep = "")

# Affichage de la matrice avec la composition!
print(mat)
cat("La composition: (")
for (i in 1:complength)
{
    cat("{")
    for (j in 1:length(comp[[i]]))
    {
        if (j == length(comp[[i]]))
            cat(comp[[i]][j])
        else
            cat(comp[[i]][j], ", ")
    }
    if (i == complength)
        cat("}")
    else 
        cat("}, ")
}
cat(")\n")

# Lecture de la valeur de composition!
repeat {
    cat("Donner la valeur de la composition: ")
    valeur = readLines("stdin", 1)
    if (valeur >= 0)
        break
}

# Tester que la composition donner est realisable ou non!
for (i in 1:complength)
    if (length(comp[[i]]) > valeur)
        stop("La composition n'est pas realisable!", call. = FALSE)


# Tester que la matrice donner est une matrice de flux!
for (i in 1:nrow(mat))
    for (j in 1:ncol(mat))
        if ((i == j && mat[i,j] != 0) || (mat[i,j] != mat[j,i]))
            stop("La matrice n'est pas une matrice de flux!", call. = FALSE)


# Calcule de la fct obj en eliminant tt les liens de machine dans les meme cellules!
for (i in 1:complength)
    for (j in 1:length(comp[[i]]))
        for (k in 1:length(comp[[i]]))
            mat[as.numeric(comp[[i]][j]), as.numeric(comp[[i]][k])] = 0
fctObj = 0
for (i in 1:nrow(mat))
    for (j in 1:ncol(mat))
        fctObj = fctObj + mat[i, j]
fctObj = fctObj / 2;

# Affichage du resultat de la fonction objectif:
cat("La composition est realisable et la fct objectif associee est:", fctObj, "\n")

# 2eme importation de la matrice pour la generation de graph!
matrice = scan(args[1], quiet = T)
matrice = matrix(matrice, ncol = ncol(mat), byrow = T)

# Ajouter les noms des lignes et colons {"M1", "M2", "M3", ...}
rownames(matrice) = paste("M", c(1:num), sep = "")
colnames(matrice) = paste("M", c(1:num), sep = "")


# Generation du Graph associee!
# network est pour cree un reseau des noeuds et liens entre eu!
# une matrice d'adjacence et pas de cible (fleche)
# l'arguement names.eval est pour les valeurs de la matrice pour les liens!
matrice = network(matrice,
              directed = FALSE,
              matrix.type = "adjacency",
              ignore.eval = F,
              names.eval = "valeurs"
              )

# Definition de la cellule 1 et 2 pour differencier entre les 2 avec -
# different couleurs!
matrice %v% "option" = ifelse(
        paste("M", seq(1, 6), sep = "") %in% paste("M", seq(1, 6, 2), sep = ""),
        "comp1",
        "comp2"
        )

# Definition des couleurs pour les 2 cellules!
matrice %v% "myColor" = ifelse(matrice %v% "option" == "comp1", "blue", "tomato")

# Generation du Graph avec mes couleurs et mes parametre!
ggnet2(matrice,
       node.size = 20,
       edge.size = 1,
       label = T,
       color = "myColor",
       edge.label = "valeurs"
       )

cat ("Press any key to continue!")
line = readLines("stdin", 1)

# Pour afficher le Graph generer, en supposant que evince est installé!
# Si sa ne marche pas veut devez l'ouvrir Rplots.pdf manuellement!
command = paste("evince ", getwd() ,"/Rplots.pdf", sep = "")
system(command, intern = F)
