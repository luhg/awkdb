# init.awk
BEGIN {
    # Save File names here 
    _table_info = "TABLE_INFO"
    _table_name = "_[A-Za-z]+"
    _comment    = "##"
    _separator  = "[=]+"
    tab_info_found = 0
}

function _read_meta_info (data) {
    # Still doubt this piece of code
    if (data ~ _table_info) {
	tab_info_found = 1
	return
    }
    
    if (tab_info_found == 1) 
	if((data !~ _comment) && (data !~ _separator))
	    tab_info[NR]=$0
}

{
    _read_meta_info($0)
    if(tab_info_found)
	next
}

END { 
    i = NR
    printf("\n TABLE META\n")
    printf("\n $name      $no_columns     $depends\n")
    printf("\n ===================================\n")
    while(i > 0) {
	printf("\n %s", tab_info[i]) 
	i = i - 1
    }
}
