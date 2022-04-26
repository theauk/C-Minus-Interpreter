#include <stdbool.h>  
#include <stdio.h>   
#include <string.h>
#include "symbolTable.h"

struct Queue {
    struct Entry queue[100];
    int front;
    int nextIndex;
};

struct Queue push(struct Queue q, struct Entry e)
{
    q.queue[q.nextIndex] = e;
    q.nextIndex++;
    return q;
}

struct Entry pop(struct Queue q)
{
    return q.queue[q.front]; /* NEED TO CHANGE FRONT IN ANOTHER FILE */
}

