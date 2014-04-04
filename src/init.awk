# init.awk
BEGIN {
    # Save File names here 
    _table_info = "TABLE_INFO"
    _table_name = "_[A-Za-z]+"
    _comment    = "##"
    _separator  = "[=]+"
    tab_info_found = 0
    _create_query = "^CREATE TABLE [A-Za-z]+"
    _select_query = "^SELECT FROM [A-Za-z]+"
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
# Check for [table_name] syntax, [A-Za-z]+
# Check if table already exists
# Check for fields
# _fields_check() 
# on return success
# create table, add .meta info, create file $table_name
function _create_table (tb_name) {
    _proto_tb_name = "^[A-Za-z_]+$"
    
    if(tb_name !~ _proto_tb_name) {
	printf "Table has unknown syntax"
	return -1
    }

    msg = "Done Create table"
}

function _check_syntax(data, type) {
    if (type ~ "create") {
	if (data ~ _create_query)
	    return 0 
	return -1
    }
    if (type ~ "select") {
	if (data ~ _select_query)
	    return 0 
	return -1
    }
}

# Think how do we handle syntax checking
function _proc_query(data) {
    if (data ~ /CREATE/) {
	x = _check_syntax(data, "create")
	if (x == 0)
	    _create_table($3)
	else 
	    printf("Syntax Error, Please check")
    }
    if (data ~ /SELECT/) {
	x = _check_syntax(data, "select")
	if (x == 0)
	    _read_meta_info($0)
	else 
	    printf("Syntax Error, Please check")
    }
}

{
    _proc_query($0)
}

END {
    printf("\n %s", msg)
}
