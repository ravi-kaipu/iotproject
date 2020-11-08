#include <stdio.h>
#include <stdlib.h>


typedef struct node {
    int data;
    struct node *next;
}Node;

Node *allocate_node(int value) {
    Node *tmp = (Node *) malloc(sizeof(Node));
    tmp->data = value;
    tmp->next = NULL;
    return tmp;
}

void insert(Node **root, int value) {
    Node **walk = root;
    while (*root != NULL)
        root = &(*walk)->next;
    *root = allocate_node(value);
    printf("insertion of %d is done\n", value);
}

void print_list(Node *head) {
    if (head == NULL)
        return;
    printf("Singly linked list:\n  ");    
    Node *walk = head;
    while (walk->next != NULL) {
        printf("%d -> ", walk->data);
        walk = walk->next;
    }
    printf("%d\n", walk->data);
}

int main() {
    Node *head = NULL;
    insert(&head, 10);
    insert(&head, 20);
    print_list(head);
    return 0;
}
