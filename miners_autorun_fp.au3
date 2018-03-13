; Version with failover pools, $cmdLineArray[0] is main pool, all others are failover pools. If main pool fails, script will work on next failover pool from the list
; for $FailoverLimit minutes and then will switch back to main pool.

; ---- set your values here --------

$full_miner_path="C:\Miners\HsrminerFork\hsrminer_neoscrypt_fork.exe"			; change to your full path to the miner
$miner_path="C:\Miners\HsrminerFork"							; change to your path to the miner
$miner_to_start="hsrminer_neoscrypt_fork.exe"						; change to your miner .exe name

Global $FailoverLimit=15								; change to number of minutes to work on failover pools, after that script will switch pool to main one

Global $TotalNumPools=3									; change to total (main + failover) number of pools you are going to use

Global $cmdLineArray[$TotalNumPools]

; main pool
$cmdLineArray[0]="-r 1 -R 3 -o stratum+tcp://neoscrypt.mine.zpool.ca:4233 -u ADDRESS -p ID=worker1,c=BTC"	; change to your cmdline params but don't remove -r option or script won't help you in case of pool's connection failure
; failover pools
$cmdlineArray[1]="-r 1 -R 3 -o stratum+tcp://neoscrypt.mine.ahashpool.com:4233 -u ADDRESS -p ID=worker1,c=BTC"	; change to your cmdline params but don't remove -r option or script won't help you in case of pool's connection failure
$cmdlineArray[2]="-r 1 -R 3 -o stratum+tcp://mine.zergpool.com:4233 -u ADDRESS -p ID=worker1,c=BTC"		; change to your cmdline params but don't remove -r option or script won't help you in case of pool's connection failure

; failover pools
; if you have more than 2 failover pools, increase $TotalNumPools value and add additional failover pools here as shown above, like
;
; $cmdlineArray[3]="...."
; $cmdlineArray[4]="...."

$logfile_path="C:\Miners\HsrminerFork\Hsrminer_Neoscrypt_Fork.log"			; change to your full path to the log file name			

Sleep(10000)										; timeout in ms, 10 seconds default, to let Windows and MSI Afterburner starts, change to your value or remove line


; ---- start -------

Global $reskill=0
Global $resrun1=0
Global $resrun2=0
Global $resultcheck=0
Global $currentpool=0
Global $failovertimer=0
Global $poolswitching=0

Global $logfile = FileOpen($logfile_path, 1)

FileWriteLine($logfile, "-------------------------------------------------------------------------------------")
FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d %s Log is ON",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$full_miner_path))
FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d Number of failover pools: %d, failover timelimit in minutes: %d ",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$TotalNumPools-1,$FailoverLimit))
FileWriteLine($logfile, "-------------------------------------------------------------------------------------")

$FailoverLimit=$FailoverLimit*60 ; convert to seconds
Send("#d") ; minimize all windows

; ---- main loop -----

While 1  ; infinite loop
	$currentpool=0
	$failovertimer=0			; reset failover timer
	While $currentpool<$TotalNumPools	; pool switch loop
		StartMiner()
		$poolswitching=0
		$resultcheck=0
		While $resultcheck=0     ; while there is no exit/crash of the miner
			Sleep(3000)	 ; sleep 3 seconds
			$resultcheck=CheckExitCrash()	; and check if miner crashed or exited
			If $currentpool<>0 Then		;if we are on failover pool
				$failovertimer=$failovertimer+3		; increase failover timer by 3 seconds 
				If $failovertimer>=$FailoverLimit Then  ; if we were worked on failover pools for more than N minutes
					FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d [*]  Failover timelimit has been reached, switching back to main pool...",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC))
					$poolswitching=1
					ExitLoop 2			; and exit to the start of infinite loop
				Endif
			Endif
		Wend
		If $resultcheck=1 Then; if miner exited
			$currentpool=$currentpool+1	; switch to next pool
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
	If $resultcheck<>2 And $poolswitching=0 Then
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
	If $resultcheck<>2 And $poolswitching=0 Then
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

If $currentpool=0 Then
	FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d [+] Started at MAIN pool: %s %s",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$miner_to_start,$cmdLineArray[$currentpool]))
Else
	FileWriteLine($logfile, StringFormat("%02d:%02d:%04d %02d:%02d:%02d [+] Started Failover #%02d: %s %s",@MDAY,@MON,@YEAR,@HOUR,@MIN,@SEC,$currentpool,$miner_to_start,$cmdLineArray[$currentpool]))
Endif
EndFunc