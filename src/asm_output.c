#include <stdio.h>
#include <stdarg.h>

FILE *output;

void asm_output_init() {}

void set_asm_output(char * filename)
{
    if(filename)
        output = fopen(filename, "w");
    else
        output = stdout;
}

void asm_output(char *line, ...)
{
    va_list argptr;
    va_start(argptr, line);
    vfprintf(output, line, argptr);
    va_end(argptr);
}

void asm_output_close()
{
    fclose(output);
}