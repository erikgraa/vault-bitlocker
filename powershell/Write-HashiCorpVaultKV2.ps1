function Write-HashiCorpVaultKV2 {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$MountPath,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$Path,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [HashTable]$Data,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$Server,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [SecureString]$Token
  )

  begin {
    $headers = @{
      'Content-Type' = 'application/json'
      'Accept-Type'  = 'application/json'
      'X-Vault-Token' = ConvertFrom-SecureString -SecureString $Token -AsPlainText
    }

    $body = @{}
  }

  process {
    foreach ($_data in $Data.GetEnumerator()) {
      $body.Add($_data.Key, $_data.Value) 
    }

    $body = @{'data' = $body} | ConvertTo-Json

    Invoke-RestMethod -Uri ('{0}/v1/{1}/data/{2}' -f $uri, $MountPath, $Path) -Headers $headers -Method Post -Body $body -SkipCertificateCheck
  }
}