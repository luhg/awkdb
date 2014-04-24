BEGIN {
    _tb_name = ""
}
@include "/home/sriramr/src/assorted_codes/awkdb/src/init.awk"


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
    printf("DEBUG: _update_meta\n")
    if (meta_info ~ " ")
	_error("DEBUG: No meta info\n")
    # Always append on reaching this point
    cmd = sprintf("echo %s >> ../db/.meta ",meta_info)
    system(cmd)
}

function _write_database_file (tb_name, fields) {
    printf("DEBUG: _write_database_file\n")
}

# catch most of the return values
function _create_new_table(tb_name) {
    printf("DEBUG:Creating table %s\n", tb_name)
    cmd = sprintf("touch ../db/%s",tb_name)
    stat = system(cmd)
    if (stat != 0)
	_error("DEBUG:Table Creation failed\n")
    # think of structred input to meta updation
    _update_meta(tb_name)
}

function _check_field_syntax(farr, f_size) {
    printf("DEBUG: f_size %d ", f_size)

    for (i = 1; i <= f_size; i++)
    	printf("DEBUG:fields %s",farr[i])
}

# Path, need to be relative or from config
{
    printf ("DEBUG: $0 @ table.awk :%s\n", $0)
    _ip_tb_nm = $3

    printf ("DEBUG: table_name = %s\n", _ip_tb_nm)
    # extract fields from the query
    split($0, a , "(");
    f = a[2]
    sub(/)/, "", f);

    while (getline line <"../db/.meta") {
	if ((line !~ _comment) && (line !~ _separator)) {
	    split(line, arr, " ")
	    if (arr[1] ~ _ip_tb_nm) {
		printf("DEBUG:Table Exists\n")
		_exists = 1
	    }
	}
    }

    if (_exists != 1 ) {
	_create_new_table(_ip_tb_nm)
	f_size = split(f, fd, ",");
	printf("\n DEBUG: %s %s", fd[1], fd[2])
	_check_field_syntax(fd, f_size)
    }
}

END {
    
}
