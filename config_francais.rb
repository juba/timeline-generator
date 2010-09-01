# -*- coding: utf-8 -*-

### OPTIONS PRINCIPALES

## Titre global
@title = "Titre"

## Langue ("francais" ou "english")
@language = "francais"

## Nombre de pages A4
@nb_sheets = 5

## Orientation des pages soit "portrait" soit "landscape"
@sheet_orientation = "landscape"

## Date de début et de fin de la chronologie
@timeline_date_start = 0
@timeline_date_end = 2010
## Première date à afficher (par exemple, la chronologie peut
## commencer en 1968 mais la première date à afficher être
## 1970). Laisser à nil si les deux dates sont les mêmes
@timeline_date_first = nil
## Intervalle entre chaque date de la chronologie (en années)
@timeline_date_interval = 100
## Intervalle entre les repères sur l'axe des dates de la chronologie
## (en années). Astuce : si vous voulez des repères pour les mois,
## mettre 1.0/12
@timeline_date_ticks_interval = 10
## Intervalle entre chaque ligne verticale pointillée (en années)
@timeline_date_vlines_interval = 20

## Doit-on aficher la partie "calendrier" en bas de la chronologie ?
## ("true" pour oui, "false"" pour non)
@display_calendar = true
## Doit-on aficher la partie "heures de la journée" en bas de la
## chronologie ?  ("true" pour oui, "false"" pour non)
@display_time = true

## Racine pour les noms des fichiers pdf générés
@output_filename = "chronologie"



### COMMANDES SYSTÈME

## Commande Pdflatex
@pdflatex = "pdflatex"
## Commande pour le visualiseur de PDF. Inidquer "" pour seulement
## générer les fichiers PDF sans les visualiser automatiquement.
@pdf_viewer = ""



### OPTIONS DE MISE EN PAGE GLOBALE

## Marge de gauche (en cm)
@l_margin = 0.5
## Marge de droite (en cm)
@r_margin = 2
## Marges en haut et en bas (en cm)
@v_margin = 0.5
## Marges pour la découpe (en cm)
@cut_margins = 0.5
## Taille de la zone de recouvrement entre les pages (en cm)
@overlapping = 0.2



### OPTIONS DE MISE EN PAGE DE LA CHRONOLOGIE

## Hauteur (en cm) et taille de police LaTeX pour les dates
@timeline_date_height = 1.1
@timeline_date_size = '\huge'
## Nombre de lignes horizontales à tracer
@timeline_date_lines = 5



### OPTIONS DE MISE EN PAGE DE LA ZONE "CALENDRIER"

## Hauteur de la zone d'affichage (en cm) et taille de la police LaTeX
## pour les mois de l'année
@month_height = 0.7
@month_size = '\large'
## Hauteur de la zone d'affichage (en cm) et taille de la police LaTeX
## pour les jours des mois
@day_height = 0.5
@day_size = '\scriptsize'



### OPTIONS DE MISE EN PAGE DE LA ZONE "HEURES DU JOUR"

## Hauteur de la zone d'affichage pour les heures et minutes (en cm)
@time_height = 0.7
## Tailles de la police LaTeX pour les heures et minutes
@hour_size = '\normalsize'
@minute_size = '\footnotesize'
## Minutes à afficher
@minutes = [10,20,30,40,50]
## Intervalle entre chaque repère sur l'axe des minutes (en minutes)
@minutes_ticks_interval = 1



### OPTIONS LATEX

## Packages LaTeX à charger
@extra_latex_packages = <<'EOT'
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[autolanguage,np]{numprint}
\usepackage{lmodern}
EOT

## Doit-on conserver les fichiers LaTeX générés ou les supprimer ?
## ("true" pour oui, "false"" pour non)
@keep_tex_files = false


