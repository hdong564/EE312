#include <stdio.h>

int main(){

    int a = 3600;
    int return_total_0;
    int return_total_1;
    int return_total_2;

    int arg[3] = {100,500,1000};
    printf(" %d %d %d\n", arg[0], arg[1], arg[2] );
    return_total_0 = a/arg[2];
    a = a-(return_total_0*arg[2]);
    printf("%d\n ", a);
    return_total_1 = a/arg[1];
    a = a-(return_total_1*arg[1]);
    printf("%d\n ", a);
    return_total_1 = a/arg[0];
    a = a-(return_total_2*arg[0]);
    printf("%d\n ", a);

    printf("%d %d %d ",return_total_0, return_total_1, return_total_2);
    return 0;
}