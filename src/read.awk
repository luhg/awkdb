BEGIN {
    _table_name = "^_NAME:[A-Za-z]+"
    _table_fields = "^_FIELDS:[A-Za-z]+"
    _comment    = "^#[#A-Za-z]+"
    _separator  = "^[=]+"
}

function _read_table_data(input) {
    printf("\n %s", input)
}

{
    if (($0 ~ _table_name) && ($0 !~ _comment)) {
	split($0, a, ":")
	tab_name = a[2]
    }
    
    if (($0 ~ _table_fields) && ($0 !~ _comment)) { 
	# technology to do a two split text method, not a good way (Will replace once I read more
	split($0, _fields, " ")
	split(_fields[1], tmp, ":")
	_fields[1] = tmp[2]
    }

    if (($0 !~ _table_name) && ($0 !~ _table_fields) && ($0 !~ _comment) && ($0 !~ _separator))
	_read_table_data($0)
}

END {
    print (" Info")
    printf(" Table_name : %s\n", tab_name)
    printf("Table fields:\n")
    printf("==================================\n")
    for ( i in _fields ) 
	printf("%s\t",_fields[i])
}
