#! /bin/csh -fxv
#
set first_rest_year = 1958
set ocean_base_year = 62

#  1958-01-01 = 0062-01-01

set year = 1991


# Comment:  year translation:  if ($year == 1997 ) set ocnyr = 0101
# years used for ICs:   0062 (1958) - 0101 (1997)
# atmyr 1958 = ocnyr 62
@ offset = $first_rest_year - $ocean_base_year
@ ocnyr   = $year - $offset
#useOcnYr = printf "%04d\n" "$ocnyr"

set padded = `printf "%04d" $ocnyr`
echo $padded

