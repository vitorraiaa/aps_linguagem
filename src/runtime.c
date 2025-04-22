// src/runtime.c
#include <stdio.h>
#include <stdlib.h>

void show_dialogue(const char *ator, const char *texto) {
    printf("%s: \"%s\"\n", ator, texto);
    fflush(stdout);
}

void move_camera(const char *ator, const char *pos) {
    printf("[camera] movendo %s para %s\n", ator, pos);
    fflush(stdout);
}

void fade_in(int t) {
    printf("[fade in %d s]\n", t);
    fflush(stdout);
}

void fade_out(int t) {
    printf("[fade out %d s]\n", t);
    fflush(stdout);
}
