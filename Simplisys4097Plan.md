# SimpliSys4097

## Description du Projet
SimpliSys4097 est un projet visant à développer un système d'exploitation simplifié basé sur xv6, avec des extensions et des fonctionnalités modernes. Ce projet a pour but de permettre aux étudiants de mettre en pratique leurs connaissances en conception des systèmes d'exploitation et d'apporter des améliorations spécifiques à xv6 selon les besoins actuels.

## Équipe de Développement
- NEUSSI NJIETCHEU PATRICE EUGENE
- MFENJOU ANAS CHERIF

## Déroulement du Projet

### Semaine 1 : Mise en place et Exploration initiale

**Objectifs :**
- Configurer l'environnement de développement.
- Comprendre le fonctionnement interne de xv6.
- Se familiariser avec l'émulateur QEMU et les outils comme GCC, Make et Git.
- Étudier les mécanismes de base du système d'exploitation (gestion des fichiers, processus, synchronisation, etc.).

**Tâches :**
1. Installer et tester xv6 sur QEMU.
2. Étudier les fichiers principaux du code source de xv6.
3. Identifier les parties du code liées aux axes de développement : gestion des fichiers, processus, synchronisation, shell, interface utilisateur.
4. Réaliser un plan détaillé pour les extensions à développer.

**Livrable :**
- Présentation sur l'analyse initiale de xv6 et les outils utilisés.
- Explication des fonctionnalités existantes et du plan de travail pour les extensions.

### Semaine 2 : Développement de la gestion des fichiers et des processus

**Objectifs :**
- Implémenter les extensions liées à la gestion des fichiers et à la gestion des processus.

**Tâches :**
1. Ajouter la commande `lseek()` pour le repositionnement dans un fichier.
2. Ajouter les permissions pour les fichiers (lecture, écriture, exécution).
3. Implémenter l'ordonnancement des processus basé sur les priorités.
4. Ajouter les statistiques sur les processus (temps d'exécution, utilisation CPU, etc.).
5. Tester les fonctionnalités implémentées.

**Livrable :**
- Présentation sur les extensions développées (gestion des fichiers et des processus).
- Démonstration du code et des tests.

### Semaine 3 : Synchronisation et Shell

**Objectifs :**
- Renforcer la synchronisation et enrichir le shell.

**Tâches :**
1. Implémenter des verrous pour gérer la concurrence dans les processus.
2. Étendre les primitives existantes comme les `locks` pour supporter le multithreading.
3. Ajouter le support des commandes complexes dans le shell (pipelines, redirections multiples).
4. Ajouter des scripts d'automatisation.
5. Tester toutes les fonctionnalités développées.

**Livrable :**
- Présentation des mécanismes de synchronisation et des améliorations du shell.
- Démonstration des scripts et des fonctionnalités du shell.

### Semaine 4 : Interface utilisateur et intégration finale

**Objectifs :**
- Finaliser le système avec une interface utilisateur simplifiée et préparer la présentation finale.

**Tâches :**
1. Développer une interface utilisateur basique avec des menus interactifs.
2. Intégrer toutes les fonctionnalités développées (fichiers, processus, synchronisation, shell).
3. Effectuer des tests complets pour vérifier la robustesse et la stabilité du système.
4. Préparer la démonstration finale : diapositive, démonstration, rapport technique.

**Livrable :**
- Présentation finale montrant un système fonctionnel avec toutes les extensions.
- Rapport complet incluant les choix techniques et les défis rencontrés.

## Notes
SimpliSys4097 n’est pas seulement un projet académique, mais une opportunité unique de comprendre les fondements des systèmes d’exploitation tout en y intégrant des idées novatrices. Grâce à ce projet, l'équipe espère apporter une contribution significative à la compréhension des OS et inspirer d'autres étudiants à explorer davantage le monde des systèmes embarqués et des technologies modernes.
