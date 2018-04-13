#include "logs.h"
#include <stdio.h>
#include <stdarg.h>

static int verbosity_level;

void log_error(char *msg, ...)
{
    if(verbosity_level < 0)
    {
        return;
    }

    va_list argptr;
    va_start(argptr, msg);
    fprintf(stderr, "\x1b[31m(╯°□°）╯︵ ┻━┻\x1b[0m: ");
    vfprintf(stderr, msg, argptr);
    fprintf(stderr, "\n");
    va_end(argptr);
}

void log_warning(int verbosity, char *msg, ...)
{
    if(verbosity_level < verbosity)
    {
        return;
    }

    va_list argptr;
    va_start(argptr, msg);
    fprintf(stderr, "\x1b[33m¯\\_(ツ)_/¯\x1b[0m: ");
    vfprintf(stderr, msg, argptr);
    fprintf(stderr, "\n");
    va_end(argptr);
}

void set_verbosity_level(int level)
{
    if(level >= -1 || level <= 3) {
        verbosity_level = level;
    } else {
        verbosity_level = VERBOSITY_NORMAL;
    }
}