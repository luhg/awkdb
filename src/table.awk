BEGIN {
    _tb_name = ""
}
@include "init.awk"


function _error(ctx) {
    printf("\n Error %s", ctx)
    exit
}

function _success(ctx) {
    printf("\n Success %s", ctx)
    return 0
}

function _fields_check (fields) {
    printf("DEBUG: _fields_check")
}

function _update_meta (meta_info) {
    printf("DEBUG: _update_meta")
    if (meta_info ~ " ")
	_error("No meta info")
    # Always append on reaching this point
    cmd = sprintf("echo %s >> ../db/.meta ",meta_info)
    system(cmd)
}

function _write_database_file (tb_name, fields) {
    printf("DEBUG: _write_database_file")
}

# catch most of the return values
function _create_new_table(tb_name) {
    printf("DEBUG:Creating table %s\n", tb_name)
    cmd = sprintf("touch ../db/%s",tb_name)
    stat = system(cmd)
    if (stat != 0)
	_error("Table Creation")
    # think of structred input to meta updation
    _update_meta(tb_name)
}

# Path, need to be relative or from config

{
    printf ("%s", $0)
    _ip_tb_nm = $3

    while (getline line <"../db/.meta") {
	if ((line !~ _comment) && (line !~ _separator)) {
	    split(line, arr, " ")
	    if (arr[1] ~ _ip_tb_nm) {
		printf("Table Exists")
		_exists = 1
	    }
	}
    }

    if (_exists != 1 )
	_create_new_table(_ip_tb_nm)
}

END {
    
}
