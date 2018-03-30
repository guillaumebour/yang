#define INCORRECT_ADDRESS -1

typedef char   addr_t; /* 8-bits addresses */
typedef char * identifier_t;

void st_init();
addr_t st_push(identifier_t variable_name);
addr_t st_peak(unsigned int index);
addr_t st_pop();
addr_t st_new_tmp();
addr_t st_search(identifier_t variable_name);
void st_enter_scope();
void st_leave_scope();

