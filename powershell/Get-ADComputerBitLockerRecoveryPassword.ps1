function Get-ADComputerBitLockerRecoveryPassword {
    [CmdletBinding(DefaultParameterSetName='LastSet')]
    param(
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [Microsoft.ActiveDirectory.Management.ADComputer]$Name,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ParameterSetName='AllSet')]
        [Switch]$All
    )

    begin {}

    process {
        $objects = @()

        foreach ($_computer in $Name) {
            $entries = Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $_computer.DistinguishedName -Properties 'msFVE-RecoveryPassword','whenCreated'

            if ($PSCmdlet.ParameterSetName -eq 'LastSet') {
                $entries = $entries | Select-Object -Last 1
            }

	        foreach ($_entry in $entries) {
	            if ($null -ne $_entry) {
                    $hash = @{}

		            $passwordId = $_entry.name

                    $hash.Add('Name', $_computer.Name)
                    $hash.Add('DNSHostName', $_computer.DNSHostName)
		            $hash.Add('RecoveryPassword', $_entry.'msFVE-RecoveryPassword')
                    $hash.Add('Id', ($passwordId -split '{')[-1].replace('}',''))
                    $hash.Add('WhenCreated', $_entry.whenCreated)
                        
                    $objects += New-Object -TypeName PSCustomObject -Property $hash
	            }
            }
        }
    }

    end {
        $objects
    }
}