#!/usr/bin/env nash

# 'vars' needs to be a list of lists where each var
#  is a list containing the var name at index '0'
#  and the var value at index '1'
fn make_template(file, vars) {
	result <= cat $file

	for var in $vars {
		var_key     = $var[0]
		var_value   = $var[1]

		result, err <= echo $result | m4 "-D__"+$var_key+"__="+$var_value

		if $err != "0" {
			echo "There was a problem making the template out of "+$file+" for var: "+$var_key
		}
	}

	return $result
}

fn lib_create_file_from_tpl(template, vars, outfile) {
	compiled <= make_template($template, $vars)

	echo $compiled > $outfile
}
