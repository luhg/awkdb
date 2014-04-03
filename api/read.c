#include <stdio.h>
#include <string.h>
#include <readline/readline.h>
#include <readline/history.h>

#define MAX_QUERY_SIZE 2000

/* 
   - SingleLine query handling
   awkdb-> create table.....;
	
   - MultiLine query handling
   awkdb-> create table
   awkdb-> table_name ...;

   - MultipleQuery Handling  [Questionable as how to indicate the end of a query]
   awkdb-> create table ....; insert into...;
*/
     
char * proc_query ()
{
     const char *buf = NULL;
     char *saveptr;
     char *tmp;
     static char _query[MAX_QUERY_SIZE];
     static char _tmp_query[MAX_QUERY_SIZE];
     static int tmp_len = 0 ,tmp_buf_len = 0;

     while (1) 
     {
	  buf = readline("awkdb->");
	  saveptr = strchr(buf, ';');
	  tmp_len = strlen(buf);
	  tmp_buf_len = strlen(_tmp_query);

	  if (saveptr != NULL)
	  {
	       tmp = strtok(buf, ";");
	       int len = strlen(tmp);
	       strncpy (_query, tmp, len);
	       if(tmp_buf_len != 0)
		    strncat(_tmp_query, _query, strlen(_query));
	       break;
	  }
	  if (tmp_buf_len == 0)
	       strncpy(_tmp_query, buf, tmp_len);
	  else 
	       strncat(_tmp_query, buf, strlen(buf));
     }
     if(tmp_buf_len != 0) {
	  memset(_query, '\0', MAX_QUERY_SIZE);
	  strncpy(_query, _tmp_query, strlen(_tmp_query));
     }
     return _query;
}

#define MAX_COMMAND_SIZE 2000

int main (int argc, char *argv[])
{
     /* Query Processor */
     int stat = 0;
     char * query = proc_query();
     static char cmd[MAX_COMMAND_SIZE];
     if(query == NULL) 
	  return -1;
     printf("\n %s", query);
     sprintf(cmd, "echo '%s' | awk -f ../src/init.awk", query);
     system(cmd);
     return 0;
}
