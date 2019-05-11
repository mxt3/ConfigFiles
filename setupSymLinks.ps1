# powershell install script for Windows
# not all unix tools work on Windows. A list with exceptions to be ignored, is
# read from the file ExceptOnWindows.txt
#
# Run this from its root directory

# get files & folder to make links for
$lnk_trgts_unfiltered = (Get-ChildItem . | where { $_.Name -like '_*' }).Name

# Read ExceptonWindows file
$lnk_excpt = Get-Content .\exceptonWindows.txt | where { ($_ -ne '') -and ($_ -notlike '#*') }

# filter file list with Exception list
$lnk_trgts = @() # empty array
foreach ( $lnk in $lnk_trgts_unfiltered )
{
	$isExcept = $false
	foreach ( $exc in $lnk_excpt )
	{
		if ( $lnk -like "_$exc" )
		{
			$isExcept = $true	
			break
		}
	}
	if (! $isExcept )
	{
		$lnk_trgts += $lnk
	}	
}

# Make links
foreach ( $lnk_t in $lnk_trgts )
{
	$lnk_pth = "~\.$( $lnk_t.substring(1) )"
	if ( Test-Path -path $lnk_pth )
	{
		# ask for permission to overwrite
		$res = Read-host -prompt "Target '$lnk_pth' already exists. Overwrite [Y/N]?"
		if ($res -notmatch "^y(es)?$" )
		{
			continue
		}
	}
	New-Item -Path $lnk_pth -ItemType SymbolicLink -Value ".\$lnk_t" -Force # -Whatif
}
