
/**
 * @file queue.c
 * @author François Cayre <francois.cayre@grenoble-inp.fr>
 * @date Fri Jul  2 19:02:17 2021
 * @brief Queue.
 *
 * Queue.
 */

#include <assert.h>
#include <stdio.h>
#include <stdlib.h> /* NULL */

#include "../include/rv32ias/list.h"
#include "../include/rv32ias/queue.h"

queue_t queue_new( void ) { 
  return NULL; 
}

int queue_empty(queue_t q) { 
  return queue_new() == q; 
}

void queue_affiche(queue_t q){
  if (queue_empty(q)){
    printf ("la file est vide \n");
    return;
  }
  queue_t p;
  p= q->next;
  do{
    printf("%s \n", (char*)p->content);
    p = p->next;
    } while(q->next!=p);
  printf("\n");
  // return q;
}

queue_t enqueue( queue_t q, void* object ) { 
  queue_t new = queue_new(); 
  //printf("On rentre dans enqueue\n");
  new = calloc(1,sizeof(*new));
  new->content = object;
  if (queue_empty(q)){
    new->next = new;
    //printf("on est dans le if la queue est vide\n");
    return new;
  }
  //printf("On est dans le else, la queue est non vide\n");
  new->next = q->next;
  q->next = new;
  return new; 
}

list_t  queue_to_list( queue_t q ) { 
  list_t lnew = list_new(); 
  printf("on est entré dans queue to list\n");
  if (queue_empty(q)){
    return lnew;
  }
  else{
    queue_t p;
    p = q->next;
    while(p!=q){// On rajoute une boucle pour que l'ajout dans la liste s'arrête bien
      lnew = list_add_last(lnew,p->content);
      p=p->next;
    }
    lnew = list_add_last(lnew, p->content);
  } 
  return lnew; 
}