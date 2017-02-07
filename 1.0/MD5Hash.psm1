<# 
    .SYNOPSIS 
        
 
    .DESCRIPTION 
		
 
    .NOTES 
        Name: MD5Hash.psm1 
        Author: Baur Simon 
        Created: 6 Feb 2017 
        Version History 
            Version 1.0 -- 6 Feb 2017 
                -Initial Version 
#>
#region Private Functions

#endregion Private Functions

#region Public Functions

################################################################################

function IsValidMD5Hash($md5) {
	$ret = $false
	Try {
		if ($md5.Length -eq 47 -And ([regex]::Matches($md5, "-" )).count -eq 15) {
			$ret = $true
		}
	} Catch {
		Write-Verbose "Failed to verify MD5-Hash"
	}
	return $ret
}

function MD5HashFromFile($path) {
	$md5 = $null
	Try {
		If (Test-Path $path) {
			$fullPath = Resolve-Path $path
			$crypt = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
			$data = [System.IO.File]::Open($fullPath,[System.IO.Filemode]::Open, [System.IO.FileAccess]::Read)
			$md5 = [System.BitConverter]::ToString($crypt.ComputeHash($data))
			$data.Dispose()
			if (!(IsValidMD5Hash -md5 $md5)) {
				$md5 = $null
			}
		}
	} Catch {
		Write-Verbose "Failed to get MD5-Hash from $path"
		Break
	}
	return $md5
}

function IsMD5HashFromFile($hash, $path) {
	$ret = $null
	Try {
		$md5str = MD5HashFromFile -path $path
		if ($hash -eq $md5str -And (IsValidMD5Hash -md5 $hash)) {
			$ret = $true
		} else {
			$ret = $false
		}
	} Catch {
		Write-Verbose "Failed to compare MD5-Hash for $path with $hash"
		Break
	}
	return $ret
}

################################################################################

#endregion Public Functions

#region Aliases

#New-Alias -Name GetAvailableVersionsForRestore -Value Altaro-GetAvailableVersionsForRestore

#endregion Aliases

#region Export Module Members

Export-ModuleMember -Function IsValidMD5Hash
Export-ModuleMember -Function MD5HashFromFile
Export-ModuleMember -Function IsMD5HashFromFile

#Export-ModuleMember -Alias APIService

#endregion Export Module Members
