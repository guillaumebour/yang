#include "options.h"
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include "logs.h"
#include "asm_output.h"

#define BUILD_DIR "build/"

int handle_args(int argc, char * argv[])
{
    char c;
    int verbose_level = 0;
    char *filename = NULL;

    while( (c = getopt(argc, argv, "hqvo:")) != -1){
        switch(c) {
            case 'v':
                verbose_level++;
                break;
            case 'q':
                verbose_level = VERBOSITY_QUIET;
                break;
            case 'o':
                filename = malloc(sizeof(BUILD_DIR) + sizeof(optarg) + 1);
                sprintf(filename, "%s%s", BUILD_DIR, optarg);
                break;
            case 'h':
                fprintf(stderr, "Usage: compiler [options] < FILE\n"
                                "Options:\n"
                                "  -v            Increase verbosity level.\n"
                                "  -q            Set verbosity level to quiet.\n"
                                "  -o filename   Write assembly to file. Default is stdout.\n"
                                "  -h            Display this help message.\n"
                );
                exit(EXIT_FAILURE);
            case '?':
                fprintf(stderr, "Incorrect option.\n");
                return EXIT_FAILURE;
        }
    }

    set_verbosity_level(verbose_level);
    set_asm_output(filename);

    if(filename) {
        free(filename);
    }

    return EXIT_SUCCESS;
}
