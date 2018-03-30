#include <stdio.h>
#include <stdarg.h>

void log_error(char *msg, ...)
{
    va_list argptr;
    va_start(argptr, msg);
    fprintf(stderr, "\x1b[31m(╯°□°）╯︵ ┻━┻\x1b[0m: ");
    vfprintf(stderr, msg, argptr);
    fprintf(stderr, "\n");
    va_end(argptr);
}

void log_warning(char *msg, ...)
{
    va_list argptr;
    va_start(argptr, msg);
    fprintf(stderr, "\x1b[33m¯\\_(ツ)_/¯\x1b[0m: ");
    vfprintf(stderr, msg, argptr);
    fprintf(stderr, "\n");
    va_end(argptr);
}
