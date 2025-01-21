
# Projet INF4097 (SimpliSys4097-xv6)

## Développement d’un système d’exploitation simplifié basé sur xv6 : Extensions et cas pratiques

Ce projet vise à permettre aux étudiants de mettre en pratique les connaissances acquises en conception des systèmes d’exploitation en apportant des **améliorations spécifiques à xv6**, adaptées aux besoins modernes.

### Objectifs du Projet
1. **Compréhension pratique des systèmes d’exploitation** :
   - Explorer les mécanismes internes d’un OS : gestion des processus, gestion des fichiers, synchronisation, etc.
2. **Extension des fonctionnalités de xv6** :
   - Ajouter des fonctionnalités modernes pour répondre à un besoin particulier.
3. **Travail collaboratif et structuré** :
   - Appliquer des méthodologies de développement collaboratif en équipe.
4. **Production d’un système minimal mais fonctionnel** :
   - Développer un système capable de gérer des cas pratiques sur un environnement simulé.

---

### Axes de Développement Proposés
1. **Gestion Avancée des Fichiers** :
   - Ajouter la commande `lseek()` pour permettre le repositionnement dans un fichier.
   - Support des permissions pour les fichiers (lecture, écriture, exécution).

2. **Amélioration de la Gestion des Processus** :
   - Implémenter un ordonnancement basé sur les priorités.
   - Ajouter des statistiques sur les processus (temps d’exécution, utilisation CPU, etc.).

3. **Synchronisation** :
   - Implémentation des verrous pour gérer la concurrence dans les processus.
   - Étendre les primitives existantes comme les `locks` pour supporter des contextes multithread.

4. **Extension du Shell** :
   - Ajouter le support de commandes complexes (pipelines, redirections multiples).
   - Créer des scripts d’automatisation avec le shell.

5. **Interface Utilisateur Basique** :
   - Ajouter une interface utilisateur simplifiée avec des menus interactifs.

---

### Organisation du Travail
1. **Réalisation en Équipe** :
   - Constitution d’équipes de 3 étudiants.

2. **Validation Progressive** :
   - Chaque équipe présentera son travail chaque semaine pour validation.

3. **Évaluation Finale** :
   - Présentation d’un système fonctionnel intégrant toutes les extensions.
   - Documentation technique complète.

---

### Outils et Environnement
- **Émulateur QEMU** : Tester le système sans matériel réel.
- **GCC et Make** : Compiler le noyau xv6.
- **Dépôt Git** : Gérer le code source et les contributions en équipe.
- **Environnement de Développement Linux** : Terminal, éditeurs de texte comme VS Code.

---

### Livrables
1. **Code Source Documenté** :
   - Version modifiée de xv6 avec les extensions développées.

2. **Rapport de Projet** :
   - Explication des choix techniques.
   - Description des défis rencontrés et solutions adoptées.

3. **Présentation Finale** :
   - Démonstration du système d’exploitation développé.
   - Évaluation de la robustesse des extensions.

