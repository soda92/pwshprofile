. $PSScriptRoot/myconfig.ps1

function w {
    where_command_go $args
}

$Env:PATH += ";C:\Program Files\Chez Scheme 9.5.8\bin\ta6nt"
Import-Module -Name Terminal-Icons

oh-my-posh init pwsh --config C:\Users\18463\scoop\apps\oh-my-posh\current\themes/jandedobbeleer.omp.json | Invoke-Expression