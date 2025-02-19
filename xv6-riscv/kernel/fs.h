// On-disk file system format.
// Both the kernel and user programs use this header file.


#define ROOTINO  1   // root i-number
#define BSIZE 1024  // Nouvelle taille de bloc
// Disk layout:
// [ boot block | super block | log | inode blocks |
//                                          free bit map | data blocks]
//
// mkfs computes the super block and builds an initial file system. The
// super block describes the disk layout:
struct superblock {
  uint magic;        // Must be FSMAGIC
  uint size;         // Size of file system image (blocks)
  uint nblocks;      // Number of data blocks
  uint ninodes;      // Number of inodes.
  uint nlog;         // Number of log blocks
  uint logstart;     // Block number of first log block
  uint inodestart;   // Block number of first inode block
  uint bmapstart;    // Block number of first free map block
};

#define FSMAGIC 0x10203040

#define NDIRECT 10
#define NINDIRECT (BSIZE / sizeof(uint))
#define MAXFILE (NDIRECT + NINDIRECT)

// Permissions
#define MODE_READ   0x04  // Permission de lecture
#define MODE_WRITE  0x02  // Permission d'écriture
#define MODE_EXEC   0x01  // Permission d'exécution
#define MODE_DEFAULT (MODE_READ | MODE_WRITE)  // Permissions par défaut

// On-disk inode structure

struct dinode {
  short type;           // File type (2 octets)
  short major;          // Major device number (2 octets)
  short minor;          // Minor device number (2 octets)
  short nlink;          // Number of links to inode (2 octets)
  uint size;            // Size of file (4 octets)
  uint addrs[NDIRECT+1];   // Data block addresses (13 * 4 = 52 octets)
  ushort mode;          // Permissions (2 octets)
  char padding[6];      // Padding pour aligner la taille sur 64 octets (6 octets)
};

// Inodes per block.
#define IPB           (BSIZE / sizeof(struct dinode))

// Block containing inode i
#define IBLOCK(i, sb)     ((i) / IPB + sb.inodestart)

// Bitmap bits per block
#define BPB           (BSIZE*8)

// Block of free map containing bit for block b
#define BBLOCK(b, sb) ((b)/BPB + sb.bmapstart)

// Directory is a file containing a sequence of dirent structures.
#define DIRSIZ 14
struct dirent {
  ushort inum;
  char name[DIRSIZ];
};

