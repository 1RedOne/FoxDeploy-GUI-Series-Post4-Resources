    #ERASE ALL THIS AND PUT XAML BELOW between the @" "@ 
$inputXML = @"
<Window x:Class="Tab_Me_baby_one_more_time.MainWindow"
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:Tab_Me_baby_one_more_time"
        mc:Ignorable="d"
        Title="Tab me baby one more time" Height="320" Width="498.256">
    <Grid>
        <StackPanel HorizontalAlignment="Left" Height="325" Width="160">
            <Image x:Name="image" HorizontalAlignment="Left" Height="100" Margin="0,0,0,0" Width="160" Source="C:\Users\Stephen\Dropbox\Docs\blog\Foxdeploy_FOX.png" Stretch="UniformToFill"/>
            <TextBlock x:Name="textBlock" Height="75" TextWrapping="Wrap" Text="This will be a side menu that the user can use to move between UI elements"/>
            
            <Button x:Name="button" Content="Processes" HorizontalAlignment="Left" Height="28" Width="160" VerticalAlignment="Top" Background="#FFBDE9FC" BorderBrush="#FFFAFAFA"/>
            <Button x:Name="button3" Content="Services" HorizontalAlignment="Left" Height="28" Width="160" Background="#FFBDE9FC" BorderBrush="#FFFAFAFA"/>
            <Button x:Name="button2" Content="Computer Management" HorizontalAlignment="Left" Height="28" Width="160" Background="#FFBDE9FC" BorderBrush="#FFFAFAFA"/>
            
            <Button x:Name="button4" Content="Software Center" HorizontalAlignment="Left" Height="28" Width="160" Background="#FFBDE9FC" BorderBrush="#FFFAFAFA"/>


        </StackPanel>
        <TabControl x:Name="tabControl" HorizontalAlignment="Left" Height="280" Margin="165,00,0,0" VerticalAlignment="Top" Width="327">
            <TabItem Header="System Info" FontSize="10.667">
                <Grid Background="#FFFFF5F5"/>
            </TabItem>
            <TabItem Header="Remote Management" FontSize="10.667">
                <Grid Background="#FFE5E5E5">
                    <ProgressBar Minimum="0" Maximum="100" Value="55" HorizontalAlignment="Left" Height="23" Margin="21,47,0,0" VerticalAlignment="Top" Width="177" Foreground="#FF26ACE2" Background="White"/>
                    <Label x:Name="label" Content="Connecting to $env:ComputerName&#xD;&#xA;Checking WinRM.......[OK]&#xD;&#xA;Connecting Session..[OK]" HorizontalAlignment="Left" Height="60" Margin="21,86,0,0" VerticalAlignment="Top" Width="176"/>
                </Grid>
            </TabItem>
        </TabControl>

    </Grid>
</Window>

"@ 

$inputXML = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = $inputXML
#Read XAML

    $reader=(New-Object System.Xml.XmlNodeReader $xaml) 
  try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch [System.Management.Automation.MethodInvocationException] {
    Write-Warning "We ran into a problem with the XAML code.  Check the syntax for this control..."
    write-host $error[0].Exception.Message -ForegroundColor Red
    if ($error[0].Exception.Message -like "*button*"){
        write-warning "Ensure your &lt;button in the `$inputXML does NOT have a Click=ButtonClick property.  PS can't handle this`n`n`n`n"}
}
catch{#if it broke some other way :D
    Write-Host "Unable to load Windows.Markup.XamlReader. Double-check syntax and ensure .net is installed."
        }

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================

$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name "WPF$($_.Name)" -Value $Form.FindName($_.Name)}

Function Get-FormVariables{
if ($global:ReadmeDisplay -ne $true){Write-host "If you need to reference this display again, run Get-FormVariables" -ForegroundColor Yellow;$global:ReadmeDisplay=$true}
write-host "Found the following interactable elements from our form" -ForegroundColor Cyan
get-variable WPF*
}

Get-FormVariables

#===========================================================================
# Use this space to add code to the various form elements in your GUI
#===========================================================================
                                                                   
    
#Reference 

#Adding items to a dropdown/combo box
    #$vmpicklistView.items.Add([pscustomobject]@{'VMName'=($_).Name;Status=$_.Status;Other="Yes"})
    
#Setting the text of a text box to the current PC name    
    #$WPFtextBox.Text = $env:COMPUTERNAME
    
#Adding code to a button, so that when clicked, it pings a system
# $WPFbutton.Add_Click({ Test-connection -count 1 -ComputerName $WPFtextBox.Text
# })

$WPFProgress.Add_MouseEnter({
$WPFProgress.BeginAnimation(1,2)
})
#===========================================================================
# Shows the form
#===========================================================================
write-host "To show the form, run the following" -ForegroundColor Cyan
'$Form.ShowDialog() | out-null'


