#include <stdio.h>

void log_error(char *msg)
{
    fprintf(stderr, "\x1b[31m(╯°□°）╯︵ ┻━┻\x1b[0m: %s\n", msg);
}

void log_warning(char *msg)
{
    fprintf(stderr, "\x1b[33m¯\\_(ツ)_/¯\x1b[0m: %s\n", msg);
}
