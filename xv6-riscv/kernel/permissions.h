#ifndef _PERMISSIONS_H_
#define _PERMISSIONS_H_

int update_permissions(uint inum, int mode);
int check_permission(struct inode *ip, int mask);

#endif // _PERMISSIONS_H_
