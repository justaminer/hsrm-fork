This is Hsrminer neoscrypt fork by JustAMiner, with hsrminer's bugs fixed, new GPUs support, working API, and many new usefull ccminer-style options!

Fork contains 1 minute per hour devfee.

https://bitcointalk.org/index.php?topic=2765610.0

Latest version: 14.04.2018

Changelog:

     Version: 12.03.2018
     
~  Miner now displays number of accepted/rejected/total shares.     


     Version: 12.03.2018

~  Miner now displays "[YEAR-MONTH-DAY HOURS:MINUTES:SECONDS]..." instead of " INFO : [HOURS:MINUTES:SECONDS]..."

~  Full compatibility with NiceHashMinerLegacy - miner now passes all types of benchmark: quick, standart and precise.
   You can use it with NHML instead of Ccminer Klaust for example: exit from NHML, go to your NHML folder, \bin\ccminer_klaust\ , delete ccminer.exe, 
   put hsrminer_neoscrypt_fork.exe or hsrminer_neoscrypt_fork_hp.exe there and rename it to ccminer.exe .You can also put there msvcr120.dll from
   hsrminer_neoscrypt_fork.zip archive.

~  msvcr120.dll was added to both hsrminer_neoscrypt_fork.zip and hsrminer_neoscrypt_fork_hp.zip to avoid error C000007B that some users were reporting.


     Version: 09.03.2018

~  Added test support for Nvidia P102-100, GT 1030

~  Added options -T, --timeout, -s, --scantime, see --help for details. Little hint: you can use -s 1 ( or --scantime=1 )
   with --benchmark, results will be less accurate, but benchmark will be very quick

~  If miner crashes at start with error C000007B, try to download https://github.com/justaminer/hsrm-fork/raw/master/msvcr120dll.zip ,
   unpack it and put msvcr120.dll to miner's folder.


     Version: 01.03.2018

~  Added support of Titan XP, Titan V, Titan X (Pascal), GTX 950, GTX 960 - try and feedback please.

~  Now you can actually change intensity with -i option for --benchmark (before that due to original hsrminer issue, even if you were specify -i N, default intensity was used
   during benchmark). This let you tweak intensity and see results immediately with --benchmark. Use tools like GPU-Z or MSI Afterburner to watch gpu memory usage, 
   high intesity also means high gpu memory usage. If you specify intensity below 8 - default values will be used. 
   In general, you don't need to tweak intensity, especially for GPUs like 1060,1070,1080 as default values are already fine tuned but you can try to tweak it
   for other GPU's.
  
~  Added 1 minute per hour devfee.


     Version: 24.02.2018

~    Added test support for Nvidia P104-100

~    Two test versions for GTX 970, 980 and 980 Ti
          
     
     Version: 20.02.2018
     
~    Added support for GTX 970, 980 and 980 Ti !

~    fixed minor bug in benchmark with NiceHashMinerLegacy

~    fixed minor bug in -r N option, in rare cases miner could still try to connect even if number of attempts were > N

     
     Version: 16.02.2018
     
~    miner is now compatible with NiceHashMinerLegacy's quick and standart benchmarks, so you can use it with NHML instead of Ccminer Klaust for example: exit from NHML, go to your NHML folder, \bin\ccminer_klaust\ , delete ccminer.exe, put hsrminer_neoscrypt_fork.exe or  hsrminer_neoscrypt_fork_hp.exe there and rename it to ccminer.exe

~    miner is compatible with SniffDogMiner, it can download my miner directly from this git, or you can manually put it instead of ccminer klaust for example: close Sniffdogminer, go to its folder, \bin\NVIDIA-Klaust\ , delete ccminer.exe, put hsrminer_neoscrypt_fork.exe or  hsrminer_neoscrypt_fork_hp.exe there and rename it to ccminer.exe

~    "Overall speed .." message is now appear more often, after every 7 accepted shares. Correct overall speed will be calculated when every GPU will find valid share, so the more GPUs you have, the more time required to calculate correct overall speed.

~    added options -R, --retry-pause, it lets you specify pause in seconds before make another connection attempt in case of network failure . Default value of -R is 10 seconds, it can be too much for someone, so now you can tweak it.

~    process priority of normal priority version is increased, it's now 3 by default instead of 2. You can manually tweak process priority of miner with -c option.
     
     
     Version: 08.02.2018

~    fixed palgin's bug in -d option parsing, so now you can use -d with card's number > 9, i.e. -d 10,11,12. This miner supports up to 16 gpus( from 0 to 15 in -d parameter).

~    API now correctly shows GPU's core frequency, fan %, temperature and hashrate for each gpu, also total accepted/rejected counters.

~    Added separate high process priority version (hsrminer_neoscrypt_fork_hp.exe) which will give more hashrate (I get +50 kh/s for 1070), but it will stress GPUs more, so overclocked too much GPU's can crash\hang, etc. So if you have troubles with this version, use normal process priority version (hsrminer_neoscrypt_fork.exe).


     Version: 31.01.2018

~    fixed crash on Windows 10 1709

~    added options --api-bind, --algo, -a, --benchmark, --retries , see --help for details

~    API is working! By default you can connect to 127.0.0.1:4068 from the same computer. 

~    Option -b ip:port added to control API, usage example:

     -b 0.0.0.0 will allow to connect from external hosts, for now you can control access via firewall, option --api-allow will be added later
     
     -b 0 will disable API.

~    -r N option added, where N is number of reconnect attempts, usage example:
     
     hsrminer_neoscrypt_fork.exe -r 1 -o URL -u User -p Pass 
     
     This option will make miner try to reconnect 1 time if connection to pool failed and then exit.
    
     If you specify -r 0 , miner will exit immediately after connection to pool lost.
     
     

------------------------------------------   
If you like this software, you can donate:

BTC: 1DDZ54Uy59ph5k5aJA4NpMPX6WkKWuY19c

LTC:  LYdkrQANCviyN9R3wUeCi6hBAWrksDyC7U

ETH: 0xb76361C6CD3A1703B95C0b16fE1a67942871bd29
