<#
.SYNOPSIS
    Tests TCP connectivity to multiple hosts on a specified port and reports results.

.DESCRIPTION
    Runs Test-NetConnection against a list of hostnames/IPs on a given port and
    outputs RemoteAddress, RemotePort, and TcpTestSucceeded for each.

.PARAMETER ComputerName
    One or more hostnames or IP addresses to test.

.PARAMETER Port
    TCP port to test on each host. Defaults to 8080.

.EXAMPLE
    .\Test-Hosts.ps1 -ComputerName host1,host2,host3 -Port 8080

.EXAMPLE
    .\Test-Hosts.ps1 -ComputerName (Get-Content .\hosts.txt) -Port 443

.EXAMPLE
    "host1","host2" | .\Test-Hosts.ps1 -Port 22
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
    [string[]]$ComputerName,

    [Parameter(Position = 1)]
    [int]$Port = 8080
)

begin {
    $results = @()
}

process {
    foreach ($computer in $ComputerName) {
        Write-Verbose "Testing $computer on port $Port..."

        try {
            $test = Test-NetConnection -ComputerName $computer -Port $Port -WarningAction SilentlyContinue -ErrorAction Stop

            $results += [PSCustomObject]@{
                ComputerName      = $computer
                RemoteAddress     = $test.RemoteAddress
                RemotePort        = $test.RemotePort
                TcpTestSucceeded  = $test.TcpTestSucceeded
            }
        }
        catch {
            Write-Warning "Failed to test $computer : $($_.Exception.Message)"

            $results += [PSCustomObject]@{
                ComputerName      = $computer
                RemoteAddress     = $null
                RemotePort        = $Port
                TcpTestSucceeded  = $false
            }
        }
    }
}

end {
    $results | Format-Table -AutoSize

    # Uncomment to export results to CSV:
    # $results | Export-Csv -Path ".\TestResults.csv" -NoTypeInformation
}
