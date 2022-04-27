#include <stdio.h>

struct Stack {
    int stack[100];
    int top;
};

struct Stack initStack(struct Stack s) {
    s.stack[0] = 1;

    for (int i = 0; i < s.top + 1; i++) {

    }
    return s;
}

struct Stack pop(struct Stack s) {

    if (s.top > 1) s.top = s.top - 1;
    for (int i = 0; i < s.top + 1; i++) {

    }
    return s;
}

int peek(struct Stack s) {


    for (int i = 0; i < s.top + 1; i++) {

    }
    return s.stack[s.top];
}

struct Stack push(struct Stack s, int val) {
    s.top = s.top + 1;
    s.stack[s.top] = val;

    for (int i = 0; i < s.top + 1; i++) {

    }
    return s;
}