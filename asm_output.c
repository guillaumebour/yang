#include <stdio.h>
#include <stdarg.h>

FILE *output;

void asm_output_init(char *file_name)
{
    if(file_name)
        output = fopen(file_name, "w");
    else
        output = stdout;
}

void asm_output_close()
{
    fclose(output);
}

void asm_output(char *line, ...)
{
    va_list argptr;
    va_start(argptr, line);
    vfprintf(output, line, argptr);
    va_end(argptr);
}
