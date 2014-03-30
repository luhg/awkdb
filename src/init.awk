# init.awk
BEGIN {
    # Save File names here 
    _table_info = "TABLE_INFO"
    _table_name = "_[A-Za-z]+"
    _comment    = "##"
    _separator  = "[=]+"
    tab_info_found = 0
}
{
    # Do not read this pattern
    if ($0 ~ _table_info) {
	tab_info_found = 1
    }
    
    if (tab_info_found == 1) 
	if(($0 !~ _comment) && ($0 !~_table_info))
	    tab_info[NR]=$0
}
END { 
    i = NR
    printf("\n TABLE META\n")
    printf("\n $name      $no_columns     $depends\n")
    while(i > 0) {
	printf("\n %s", tab_info[i]) 
	i = i - 1
    }
}
