#!/bin/bash
# Ce script est conçu pour lancer des entraînements avec différentes combinaisons de paramètres pour un grogramme (Mnist, Pendulum...).
# Il utilise des boucles pour parcourir différentes valeurs de la seed (de 0 à max_seed), du nombre d'actions(de 2 à max_nbr_agents),
# et de la taille de la fenêtre glissante (de 0 à max_actions).

# Usage:
#   ./training.sh max_seed max_actions
#   - max_seed : La valeur maximale de la seed initiale pour les entraînements.
#   - max_actions : Le nombre maximal d'actions par root


# Assurez-vous d'avoir les permissions d'exécution pour ce script en utilisant la commande suivante :
#   chmod +x training.sh

#Attention
# Le script utilise le répertoire du script lui-même pour trouver le chemin absolu vers votre programme d'entraînement.
# Assurez-vous que le script est dans le répertoire du projet (Mnist, Pendulum...).
# Assurez-vous que l'exécutable soit compilé.

# Vérifier si le nombre d'arguments est correct
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 max_seed_value max_nbr_agents max_nbGenerationPerAggregation"
    exit 1
fi
# Vérifier si max_seed est un entier positif
if ! [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "Erreur : max_seed doit être un entier positif."
    exit 1
fi
# Vérifier si le nombre d'actions est supérieur ou égal à 1
if [ "$2" -lt 1 ]; then
    echo "nombre d'agents doit être supérieur ou égal à 1"
    exit 1
fi

max_seed="$1"  # Valeur maximale de la seed initiale
max_agents="$2" # nombre maximal d'agents


# Résoudre les liens symboliques et obtenir le chemin absolu du script bash
script_dir=$(dirname "$(readlink -f "$0")")
# Chemin vers votre programme
program_path="$script_dir/cmake-build-release/Release/pendulum/scripts"

#for agents in "${nb_agents[@]}"; do
# Exécuter le programme pour chaque combinaison de paramètres
for ((actions=100; actions<=max_actions; actions = actions + 100)); do
  # Créer un répertoire pour stocker les fichiers de sortie
  output_dir="$script_dir/logs/ClScript/"$actions"_Actions"
  mkdir -p "$output_dir"

  for ((seed=0; seed<=max_seed; seed++)); do
    for ((decay=actions-actions; decay<=actions; decay++)); do
        echo "Lancement du : $0 avec seed initial : $seed, nombre d'actions : $actions et freq échange de donnée : $decay"
        "$program_path" $seed $actions $decay
    done
  done
done

echo "Toutes les exécutions sont terminées."