
#include <stdio.h>
#include <string.h>

extern void caml_startup(char** argv);

char* argv[] = {"mirage", NULL};

int main(void)
{
    printf("Hello.\n");
    caml_startup(argv);
    return 0;
}
