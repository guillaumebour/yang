#define VERBOSITY_QUIET         -1
#define VERBOSITY_NORMAL         0
#define VERBOSITY_VERBOSE        1
#define VERBOSITY_VERY_VERBOSE   2
#define VERBOSITY_DEBUG          3

void log_error(char *msg, ...);
void log_warning(char *msg, ...);
void set_verbosity_level(int level);