<#
    .SYNOPSIS 
      Searches DNS for records based on user input.  The -DeleteRecord switch will remove the record.  User can also specify DNS and zone to query.
    .EXAMPLE
     Find-DNS -Search Test
     This command finds records in DNS named "Test"
     .EXAMPLE
     Find-DNS -Search Test -DeleteRecord
     This command finds records in DNS named "Test" and deletes the record.  If an A recored is selected the PTR record is also removed
  #>

function Find-DNS {

param(
    [Parameter(Position=1)]
    [string]
    $Zone = "contoso.local",

    [Parameter(Position=2)]
    [string]
    $DNS = "DNSServer",

    [Parameter(Position=0, Mandatory=$True)]
    [string]
    $Search,

    [switch]$DeleteRecord
    )


$arecord = Get-DnsServerResourceRecord -ComputerName $DNS -ZoneName $Zone | ? {$_.HostName -like "*$search*"}
$arecord
 if($arecord -eq $null){
   Write-Output "Record for $search cannot be found"
 }
  else{
  $status = 1
  }


if($DeleteRecord -and $status -eq 1){

$arecord[1] | %{
  Remove-DnsServerResourceRecord -ComputerName $DNS -ZoneName $Zone -RRType $_.RecordType -Name $_.hostname -RecordData $_.RecordData.ipv4address.IPAddressToString -Force
   } 
   Write-Host "$arecord[1] has been removed" -backgroundcolor Red
  }

}
Find-DNS
