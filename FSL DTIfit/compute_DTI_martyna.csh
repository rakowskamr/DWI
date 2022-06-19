#!/bin/csh -f

if ($#argv < 1) then
        goto usage
endif

set argv = (`getopt i:b:r: $*`)
foreach opt($*)
        switch ($opt)
                case -i:
                set input = $2
                shift; shift;
                breaksw
                case -b:
                set bvalfile = $2
                shift; shift;
                breaksw
                case -r:
                set bvecfile = $2
                shift; shift;
                breaksw
	endsw
end


echo -n "===splitting input file...."

set name = `date +"%F"`
mkdir tmp${name}
fslsplit $input tmp${name}/
echo "done."


set blist = `cat $bvalfile`
set glist = `cat $bvecfile`
set DTI_blist = ()
set Gx_blist = ()
set Gy_blist = ()
set Gz_blist = ()
set bval = ()

echo -n "===identifying b<=1500 volumes:"
set n = 1
while ($n < 267)
set m = `echo $n 1 - p |dc`
set ny = `echo $n 266 + p |dc`
set nz = `echo $n 532 + p |dc`
if ($blist[$n] < 1501) then
	set DTI_blist = ($DTI_blist tmp${name}/`zeropad $m 4` )
	set bval = ($bval $blist[$n] )
	set Gx_blist = ($Gx_blist $glist[$n] )
	set Gy_blist = ($Gy_blist $glist[$ny] )
	set Gz_blist = ($Gz_blist $glist[$nz] )
endif
echo -n "*"
@ n ++
end
echo "done."

echo -n "===concatenating and averaging files...."
mkdir output${name}
fslmerge -t output${name}/DWIseries $DTI_blist
echo $bval >> output${name}/DTI_bval
echo $Gx_blist >> output${name}/DTI_bvec
echo $Gy_blist >> output${name}/DTI_bvec
echo $Gz_blist >> output${name}/DTI_bvec
echo "done."

cleanup:
#/bin/rm -r tmp${name}/

exit(0)

usage:
echo "$0 -i dwi_series -b bval_file -r bvec_file"
exit(1)

#B0list=($(awk '{ for(i=0;i<NF; i++) {if ($(i+1)<10) printf("vol%04d ",i)} }' bvals))
#Bb=($(awk '{ for(i=0;i<NF; i++) {if ($(i+1)<1100) printf("vol%04d ",i)} }' bvals))
