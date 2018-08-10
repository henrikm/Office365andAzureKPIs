<#
    .SYNOPSIS 
        Jede Ressource in einer Subscription wird getaggt. Zuerst findet ein Tagging auf Ressourcegroup statt, dann werden dieses Werte auf die Ressourcen übertragen
    .PARAMETER ResourceGroupName
        None
    .NOTES
        AUTHOR: Henrik Motzkus, COMPAREX AG
        LASTEDIT: 10.08.2018
#>

$subname = "<SUBSCRIPTION NAME>"
$Contact = "<CONTACT NAME>"
$Charge = "<YES>, <NO>"
$DistributionKey = "<PROJEKTNAME, etc.>"


Login-AzureRmAccount
Get-AzureRmSubscription
Set-AzureRmContext -Subscription $subname

$rgs = Get-AzureRmResourceGroup
foreach ($rg in $rgs){
    Set-AzureRmResourceGroup -Name $rg.ResourceGroupName -Tag @{ ContactPerson=$Contact; Charge=$Charge; DistributionKey=$DistributionKey }
    }

$rgarray = get-azurermresourcegroup | where-object {$_.Tags -ne $null}
foreach ($rg in $rgarray){
    $resarray = get-azurermresource | where-object {$_.ResourceGroupName -eq $rg.ResourceGroupName}
    foreach ($res in $resarray) {
        if ($rg.Tags -ne $null){
            set-azurermresource -tag $rg.Tags -ResourceId $res.ResourceId -Force
        }  
    }
}