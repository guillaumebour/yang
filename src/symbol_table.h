#include <stdbool.h>
#define INCORRECT_ADDRESS 0

typedef char   addr_t; /* 8-bits addresses */
typedef char * identifier_t;

enum vartype_t {
    INTEGER,
    FUNCTION,
    POINTER
};
typedef enum vartype_t vartype_t;


void st_init();
addr_t st_push(identifier_t name, vartype_t type);
addr_t st_peak(unsigned int index);
addr_t st_pop();
addr_t st_new_tmp();
addr_t st_search(identifier_t name, vartype_t type);
void st_enter_scope();
void st_leave_scope();

