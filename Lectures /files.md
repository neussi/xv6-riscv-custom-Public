# Documentation sur le Système de Gestion des Fichiers dans xv6

Le système de gestion des fichiers dans xv6 est une partie centrale de ce système d'exploitation minimaliste. Il repose sur une conception simple mais efficace utilisant des structures de données comme `file` et `inode`. Voici une explication approfondie de ces structures et de leur fonctionnement.

## Structure `file`

La structure `file` représente un fichier ouvert dans le système. Voici les champs importants :

```c
struct file {
  enum { FD_NONE, FD_PIPE, FD_INODE } type; // Type de fichier (pipe, inode, ou aucun)
  int ref;        // Compteur de références
  char readable;  // Le fichier est-il lisible ?
  char writable;  // Le fichier est-il écrivable ?
  struct pipe *pipe; // Pointeur vers une structure pipe si le type est FD_PIPE
  struct inode *ip;  // Pointeur vers un inode si le type est FD_INODE
  uint off;       // Décalage pour les opérations de lecture/écriture
};
```

### Explications des champs :
- **`type`** : Indique le type de fichier. Un fichier peut être un pipe (communication inter-processus) ou un inode (fichier réel).
- **`ref`** : Nombre de références à cet objet fichier. Si aucune référence n’existe, il peut être libéré.
- **`readable` et `writable`** : Indiquent si le fichier peut être respectivement lu ou écrit.
- **`pipe`** : Pointeur vers une structure de pipe. Utilisé pour la communication entre processus.
- **`ip`** : Pointeur vers l’inode associé à ce fichier si le fichier est de type FD_INODE.
- **`off`** : Décalage courant pour les opérations de lecture/écriture.

Cette structure est manipulée via des fonctions comme `filealloc`, `filedup`, et `fileclose` pour gérer l’allocation, l’utilisation et la libération des fichiers.

## Structure `inode`

Un inode (élément de base du système de fichiers) représente les métadonnées d’un fichier ou d’un répertoire. Voici sa définition :

```c
struct inode {
  uint dev;           // Numéro du périphérique
  uint inum;          // Numéro d’inode unique
  int ref;            // Compteur de références
  struct sleeplock lock; // Protège les champs suivants
  int valid;          // Indique si l'inode a été lu du disque

  short type;         // Type de fichier (copie de l'inode sur disque)
  short major;        // Numéro majeur du périphérique
  short minor;        // Numéro mineur du périphérique
  short nlink;        // Nombre de liens (références à cet inode)
  uint size;          // Taille du fichier
  uint addrs[NDIRECT+1]; // Adresses des blocs de données
};
```

### Explications des champs :
- **`dev`** : Identifie le périphérique contenant cet inode.
- **`inum`** : Numéro unique d’inode sur le périphérique.
- **`ref`** : Compteur de références pour gérer le partage d’inode entre processus.
- **`lock`** : Permet de synchroniser l’accès à l’inode.
- **`valid`** : Indique si les champs de l’inode sont valides (chargés du disque).
- **`type`** : Type de fichier (fichier, répertoire, ou périphérique).
- **`nlink`** : Nombre de liens pointant vers cet inode. Si `nlink` atteint 0, l’inode est supprimé.
- **`size`** : Taille du fichier associé à cet inode.
- **`addrs`** : Tableau contenant les adresses des blocs de données du fichier. Il inclut des pointeurs directs et un pointeur indirect pour les fichiers plus volumineux.

## Structure `devsw`

La structure `devsw` est une table qui associe un numéro de périphérique majeur à des fonctions pour lire et écrire sur ce périphérique.

```c
struct devsw {
  int (*read)(struct inode*, char*, int); // Fonction de lecture
  int (*write)(struct inode*, char*, int); // Fonction d'écriture
};

extern struct devsw devsw[];

#define CONSOLE 1
```

### Explications :
- **`read` et `write`** : Ces fonctions sont spécifiques à chaque périphérique (par exemple, console, disque).
- **`devsw`** : Tableau global qui associe les numéros majeurs de périphérique à leurs fonctions.
- **`CONSOLE`** : Numéro majeur correspondant au périphérique console.

## Fonctionnement Global

1. Lorsqu’un fichier est ouvert, une structure `file` est créée ou mise à jour.
2. Si le fichier correspond à un inode, celui-ci est chargé en mémoire depuis le disque si nécessaire.
3. Les opérations sur le fichier (lecture, écriture) utilisent la structure `file` pour déterminer les permissions et les décalages.
4. Pour chaque opération d’E/S, le système utilise les fonctions associées dans la table `devsw` si le fichier est associé à un périphérique.

## Points Clés
- Le système de gestion des fichiers repose sur des structures modulaires, rendant les opérations sur les fichiers et périphériques uniformes.
- Les inodes fournissent un moyen générique de représenter les fichiers et les répertoires.
- Les champs comme `ref` et `lock` garantissent la synchronisation et la gestion efficace des ressources.

En comprenant ces structures, il devient possible de modifier ou d’ajouter des fonctionnalités au système de fichiers de xv6.


Pour une compréhension approfondie et détaillée du fonctionnement technique du système de gestion des fichiers dans **xv6**, il faut explorer les mécanismes fondamentaux et leur interaction dans le noyau. Voici une vue d'ensemble technique du processus et des mécanismes impliqués.

---

## **Mécanismes du Système de Fichiers dans xv6**

### 1. **Les Fichiers et l’Interface Utilisateur**
Le système de fichiers de **xv6** s'articule autour des appels système comme `open`, `read`, `write`, et `close`. Ces appels système interagissent avec les structures `file`, `inode`, et `devsw` pour exécuter des opérations sur des fichiers ou des périphériques.

#### Processus :
1. Lorsqu’un fichier est ouvert via `open`, une structure `file` est allouée à partir de la table des fichiers ouverts (dans le noyau).
2. Si nécessaire, un inode est lu du disque, décompressé en mémoire, et verrouillé pour garantir une utilisation synchronisée.
3. Les permissions (`readable`, `writable`) et le décalage (`off`) sont initialisées pour chaque fichier ouvert.

---

### 2. **Gestion des Inodes**

#### **Lecture et Écriture des Données**
- Lorsqu'une opération comme `read` ou `write` est exécutée sur un fichier, le noyau utilise la structure `inode` pour accéder aux blocs de données associés au fichier.
- Les blocs sont identifiés par les adresses contenues dans le tableau `addrs` :
  - Les **NDIRECT** premiers blocs sont accessibles directement.
  - Le dernier pointeur (indirect) dans `addrs` permet d'accéder à une table de blocs pour gérer des fichiers plus volumineux.

#### **Synchronisation avec le Disque**
- Les inodes sont mis en cache en mémoire pour minimiser les accès au disque.
- Si une modification est apportée à un inode (par exemple, taille ou lien), elle est marquée comme "dirty" et sera écrite sur le disque lors d’une synchronisation explicite ou avant sa libération.

#### **Suppression de Fichiers**
1. Lorsque le nombre de liens `nlink` atteint zéro et qu'aucun processus ne référence le fichier (`ref == 0`), l'inode est marqué pour suppression.
2. Les blocs de données associés sont libérés, et l’inode est effacé du disque.

---

### 3. **Table des Périphériques (`devsw`)**
La table des périphériques, `devsw`, établit une interface entre le système de fichiers et les périphériques matériels.

#### **Mécanisme de Lecture/Écriture**
- Pour les fichiers associés à un périphérique (par exemple, console ou disque), `devsw` associe des fonctions spécifiques.
- Lorsqu'une opération `read` ou `write` est exécutée sur un fichier, le noyau vérifie son type. Si le type est `FD_INODE` et qu'il s'agit d'un périphérique, il appelle les fonctions `read` ou `write` correspondantes dans `devsw`.

---

### 4. **Pipes et Communication Inter-Processus**
Les pipes utilisent également la structure `file`, mais leur champ `pipe` pointe vers une structure de pipe spécifique.

- Les pipes permettent une communication unidirectionnelle entre deux processus.
- Les données écrites dans un pipe sont stockées temporairement dans un tampon et lues par un autre processus.
- Le verrouillage (`lock`) et les mécanismes de synchronisation garantissent que plusieurs processus peuvent interagir avec un pipe sans conflit.

---

### 5. **Gestion de la Mémoire**
#### **Cache des Inodes**
Pour améliorer les performances, xv6 utilise un cache pour les inodes fréquemment utilisés :
- Si un inode est déjà présent en mémoire (référencé par `inum`), il est simplement verrouillé et utilisé.
- Sinon, il est lu depuis le disque et inséré dans le cache.

#### **Table des Fichiers**
- Chaque processus possède une table de fichiers ouverts.
- Cette table fait référence à des entrées globales de fichiers, partagées entre les processus lorsqu’ils dupliquent un fichier (par exemple via `fork`).

---

### 6. **Verrouillage et Synchronisation**
#### **Verrouillage des Inodes**
- Les inodes sont protégés par un verrou de type `sleeplock`.
- Cela garantit qu’une seule opération (lecture ou écriture) peut être effectuée à la fois sur un inode.

#### **Atomisation des Opérations**
- Les appels système comme `read` et `write` effectuent des vérifications atomiques pour garantir la cohérence des données.
- Par exemple, les décalages (`off`) sont mis à jour de manière atomique après chaque opération.

---

### 7. **Cheminement d’un Appel Système `read`**

1. **Entrée dans le noyau :**
   - Un processus utilisateur appelle `read` sur un descripteur de fichier.
   - Le noyau récupère l’objet `file` correspondant via la table des fichiers ouverts du processus.

2. **Validation :**
   - Le noyau vérifie si le fichier est lisible (`readable`).

3. **Lecture des Données :**
   - Si le fichier est un inode (`FD_INODE`), les blocs de données sont récupérés via les adresses dans `addrs` et copiés dans un tampon utilisateur.
   - Si le fichier est un périphérique, la fonction `read` dans `devsw` est appelée.

4. **Mise à Jour :**
   - Le décalage (`off`) dans la structure `file` est ajusté.

---

## **Points Techniques Clés**
- **Uniformité :** Les fichiers ordinaires, répertoires, pipes et périphériques sont traités de manière uniforme grâce aux structures `file`, `inode`, et `devsw`.
- **Optimisation :** Les caches (pour inodes et fichiers) réduisent les accès disque, améliorant les performances.
- **Simplicité :** Le système est suffisamment minimaliste pour être étudié, tout en fournissant une base robuste pour des fonctionnalités avancées.



## Explication fonctions de gestion des fichiers (file.c)

---

### **1. `fileinit`**
```c
void fileinit(void)
{
  initlock(&ftable.lock, "ftable");
}
```
- **Rôle** : Initialise la table des fichiers (`ftable`).
- **Détails** : Une table globale contenant tous les fichiers ouverts est protégée par un verrou (`spinlock`) pour garantir un accès synchronisé. Cette fonction initialise ce verrou avec le nom `"ftable"`.

---

### **2. `filealloc`**
```c
struct file* filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
```
- **Rôle** : Alloue une structure de fichier libre dans la table.
- **Détails** :
  - Parcourt la table des fichiers (`ftable.file`) pour trouver une entrée avec un compteur de références (`ref`) égal à 0.
  - Si une telle entrée est trouvée, elle est marquée comme utilisée (`ref = 1`) et renvoyée.
  - Si aucune entrée n’est disponible, retourne `0` (échec).

---

### **3. `filedup`**
```c
struct file* filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
  release(&ftable.lock);
  return f;
}
```
- **Rôle** : Incrémente le compteur de références d’un fichier.
- **Détails** :
  - Vérifie que le fichier est valide (`ref >= 1`).
  - Augmente le compteur de références (`ref++`) pour indiquer qu’il est utilisé une fois de plus (par exemple, lorsqu'un fichier est dupliqué avec `dup`).
  - Retourne la structure mise à jour.

---

### **4. `fileclose`**
```c
void fileclose(struct file *f)
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
```
- **Rôle** : Ferme un fichier.
- **Détails** :
  - Décrémente le compteur de références du fichier.
  - Si le compteur atteint 0, le fichier est réellement fermé (pipe ou inode selon le type).
  - Si le fichier est un pipe (`FD_PIPE`), appelle `pipeclose` pour fermer le pipe.
  - Si le fichier est un inode (`FD_INODE`), libère l'inode avec `iput` dans une transaction protégée (`begin_op`/`end_op`).

---

### **5. `filestat`**
```c
int filestat(struct file *f, struct stat *st)
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
}
```
- **Rôle** : Récupère les métadonnées d’un fichier.
- **Détails** :
  - Si le fichier est un inode, verrouille (`ilock`) l'inode, récupère ses informations avec `stati`, puis le déverrouille.
  - Retourne `0` en cas de succès, ou `-1` si le fichier n’est pas un inode.

---

### **6. `fileread`**
```c
int fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
```
- **Rôle** : Lit des données d’un fichier.
- **Détails** :
  - Vérifie si le fichier est lisible (`readable`).
  - Si c’est un pipe, appelle `piperead`.
  - Si c’est un inode, lit les données en utilisant `readi` et met à jour le décalage (`off`).

---

### **7. `filewrite`**
```c
int filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
```
- **Rôle** : Écrit des données dans un fichier.
- **Détails** :
  - Vérifie si le fichier est modifiable (`writable`).
  - Si c’est un pipe, appelle `pipewrite`.
  - Si c’est un inode, écrit les données en blocs pour éviter de dépasser la taille maximale de transaction (`MAXOPBLOCKS`).

---

### Structure du Code
- **`file`** : Structure principale représentant un fichier.
- **Types de fichiers (`type`)** :
  - `FD_PIPE` : Fichier de type pipe.
  - `FD_INODE` : Fichier basé sur un inode.
  - `FD_NONE` : Non utilisé.
- **Verrous** : Garantissent la cohérence dans un environnement concurrent.