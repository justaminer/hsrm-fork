; To run this AutoIt script you need to download AutoIT3 from its homepage https://www.autoitscript.com/site/autoit/downloads/
; Direct link is https://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3-setup.exe
;
; Install autoit-v3-setup.exe, then run C:\Program Files (x86)\AutoIt3\Aut2Exe\Aut2exe_x64.exe and convert this script to .exe file for easy use
; Then you can run miner_autorun.exe manually or put SHORTCUT (not .exe file itself!) to it into Windows Startup folder to autorun it with Windows start.


; ---- set your values here --------

$full_miner_path="C:\Miners\HsrminerFork\hsrminer_neoscrypt_fork.exe"			; change to your full path to the miner
$miner_path="C:\Miners\HsrminerFork"							; change to your path to the miner
$miner_to_start="hsrminer_neoscrypt_fork.exe"						; change to your miner .exe name

Global $TotalNumPools=2									; change to number of pools you are going to use

Global $cmdLineArray[$TotalNumPools]

$cmdLineArray[0]="-r 0 -o stratum+tcp://neoscrypt.mine.ahashpool.com:4233 -u ADDRESS -p ID=WorkerName,c=COIN"	; change to your URL USER PASS COIN etc but don't remove -r option or script won't help you in case of pool's connection failure
$cmdlineArray[1]="-r 0 -o stratum+tcp://neoscrypt.mine.zpool.ca:4233 -u ADDRESS -p ID=WorkerName,c=COIN"	; change to your URL USER PASS COIN etc but don't remove -r option or script won't help you in case of pool's connection failure

; if you have more than 2 pools, increase $TotalNumPools value and add additional pools here as shown above, like
;
; $cmdlineArray[2]="...."
; $cmdlineArray[3]="...."

$logfile_path="C:\Miners\HsrminerFork\Hsrminer_Neoscrypt_Fork.log"			; change to your full path to the log file name			

Sleep(10000)										; timeout in ms, 10 seconds default, if script runs with Windows start, change to your value or remove line


; ---- start -------

Global $reskill=0
Global $resrun1=0
Global $resrun2=0
Global $resultcheck=0
Global $currentpool=0

Global $logfile = FileOpen($logfile_path, 1)

FileWriteLine($logfile, "------------------------------------------------------------------------------------")
FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d %s Log is ON",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$full_miner_path))
FileWriteLine($logfile, "------------------------------------------------------------------------------------")

Send("#d") ; minimize all windows

; ---- main loop -----

While 1  ; infinite loop
	$currentpool=0
	While $currentpool<$TotalNumPools     ; pool switch loop
		StartMiner()
		$resultcheck=0
		While $resultcheck=0     ; while there is no exit/crash of the miner
			Sleep(3000)	 ; sleep 3 seconds
			$resultcheck=CheckExitCrash() ; and check if miner crashed or exited
		Wend
		If $resultcheck=1 Then   ; if miner exited
			$currentpool=$currentpool+1   ; switch to next pool
		Endif ; else miner crashed and it will be started again with the same pool
	Wend
Wend

; --- main loop ends ---


Func CheckExitCrash()
	If Not ProcessExists($miner_to_start) Then
		FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d [-]  Exited: %s %s",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start,$cmdLineArray[$currentpool]))
	        Return 1
	Endif
If ProcessExists("werfault.exe") Then  ;
		FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d [!] Crashed: %s %s",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start,$cmdLineArray[$currentpool]))
		Return 2
Endif
Return 0
EndFunc



Func StartMiner()

If ProcessExists($miner_to_start) Then
	If $resultcheck<>2 Then
		FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d %s is already running!",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start))
	Endif
	Sleep(300)
	$reskill=Run(StringFormat("Taskkill /IM %s /F /T",$miner_to_start))   
	if $reskill=0 then
		FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d Can't kill %s process!",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start))
		Sleep(500)
		FileClose($logfile)
		Exit
	endif
	If $resultcheck<>2 Then
		FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d %s process killed!",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start))
	Endif
	Sleep(1000)
Endif
        $resrun1=ShellExecute($full_miner_path,$cmdLineArray[$currentpool],$miner_path, "open") ;,@SW_MINIMIZE)

If $resrun1=0 then
	Sleep(1000)
        $resrun2=ShellExecute($full_miner_path,$cmdLineArray[$currentpool],$miner_path, "open") ;,@SW_MINIMIZE)
	If $resrun2=0 then 
		FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d Can't start %s !",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start))
		Sleep(500)
		FileClose($logfile)	
		Exit
	Endif
Endif

FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d [+] Started: %s %s",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start,$cmdLineArray[$currentpool]))
EndFunc