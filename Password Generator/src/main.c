#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

const char charset[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+";

char generate_random_char() {
    size_t index = rand() % strlen(charset);
    return charset[index];
}

int main(int argc, const char *argv[]) {
    if (argc != 2) {
        printf("Usage: %s <password_length>\n", argv[0]);
        return 1;
    }

    int password_length = atoi(argv[1]);

    if (password_length < 1) {
        printf("Error: Password length must be a positive integer.\n");
        return 1;
    }

    srand(time(NULL));
    char password[password_length + 1];

    for (int i = 0; i < password_length; i++) {
        password[i] = generate_random_char();
    }
    password[password_length] = '\0';

    printf("Generated Password: %s\n", password);
    return 0;
}
