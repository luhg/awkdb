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

    i = NR
    printf("\n TABLE META\n")
    printf("\n $name      $no_columns     $depends\n")
    printf("\n ===================================\n")
    while(i > 0) {
	printf("\n %s", tab_info[i]) 
	i = i - 1
    }
    msg = "Done Read info"
}

# create_table function
function _create_table (tb_name) {
    
    msg = "Done Create table"
}

# Think how do we handle syntax checking
function _proc_query(data) {
    if (data ~ /CREATE/)
	_create_table($3)
    if (data ~ /SELECT/)
	_read_meta_info($0)
    return -1
}

{
    act = _proc_query($0)
}

END {
    printf("\n %s", msg)
}
