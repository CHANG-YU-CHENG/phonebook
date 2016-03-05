#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "phonebook_orig.h"

/* original version */
// search string(last name) under linked-list structrue(name-name-name-...)
// return matching node(matching last name)
entry *findName(char lastname[], entry *pHead)
{
    while (pHead != NULL) {
        if (strcasecmp(lastname, pHead->lastName) == 0) // compare string, ignore case
            return pHead;
        pHead = pHead->pNext; // if not find, the pointer points to the next node
    }
    return NULL;
}

entry *append(char lastName[], entry *e)
{
    /* allocate memory for the new entry and put lastName */
    e->pNext = (entry *) malloc(sizeof(entry));
    e = e->pNext;
    strcpy(e->lastName, lastName); // copy lastName to e->lastName
    e->pNext = NULL;

    return e;
}
