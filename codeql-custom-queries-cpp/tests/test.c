#include <stdio.h>
#include <stdlib.h>



int main(int argc, char *argv[]) {
    int *p = malloc(sizeof(int));
    int *q = malloc(sizeof(int));
    int result = 0;

    scanf("%d", &result);

    if(result == 0) {
        free(p);
    } else {
        free(p);
    }
    
    //p = malloc(sizeof(int));
    free(p);
    free(q);
    return 0;
}