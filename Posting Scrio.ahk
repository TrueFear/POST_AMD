	#SingleInstance, force
	#InstallKeybdHook

	;------------------------------FUNCTION----------------------------------------------------------

	co253function(pr1,pr2,pr3,allowed,pmtamount)									;this function calculates co253 amount
	{
		return allowed-pmtamount-pr1-pr2-pr3
	}	
;-----------------------------EMERGENCY EXIT-----------------------------------------------------
	^q::ExitApp
;---------------------------Not Allowed--------------------------------------------------------------
	XButton1::				;This how key will set Allowed=Charge Amnt, Not allowed = 0, pmt ammount = 0, status=hold, w/o ammount = 0	
	
	send,`t					;You click into the "allowed" box and it Tabs to the next box "Not Allowed"
	sleep, 50				;small delay
	send, 0					;sends zero into "not allowed" and effectively makes "allowed" be charged ammount
	send,`t					;tabs to "pmt ammount"
	send,0					;types in a zero for "pmt ammount"
	sleep, 50				;sleepts for 50ms
	loop,2					;this loop brings you to the "status" menu														
	{
		send, `t
		sleep, 50
	}
	send, h					;sends h to select "hold"											
	
	loop,2					;this lop brings you to the W/O ammount
	{
		send, `t
		sleep, 50
	}
	send, 0					;enteres the zero in the W/O ammount
	loop,3					;this loop brings you to the start of the next CPT or if this was the last CPT to OK
	{
		send, `t
		sleep, 50
	}
	return	
	;------------------------------Alloed Zero Payment-------------------------------------------------------	
	XButton2::										;this scrip sets allowed=0, not allowed=charge ammount, pmt ammount = 0, w/o ammount = charge ammount
	wo=0											;sets the variable to zero
	Send, {Ctrl down}c{Ctrl up}				;scrip starts in the "allowed" box it usually has full charge ammount displayed. It copies this
	wo:=Clipboard									;transwers to the varible
	send, 0											;sets "allowed" to zero
	send, `t										;tabs to "not allowed"
	send, `t										;tabs to "pmt ammount"
	send, 0											;sets "pmt ammount" to zero
	loop,4											;tabs to "WO ammount"
	{
		send,`t
		sleep, 50
	}
	send, %wo%										;sets "wo ammount" to origional coppied "allowed" ammount wich is the charge ammount
	sleep, 50
		loop,3										;tabs to next cpt or if last cpt to OK
	{
		send, `t
		sleep, 50
	}
	wo=0											;clears the varible
	return
;-----------------------------NEW EOB------------------------------------------------------------
	#Numpadmult::
	loop,14																			;loops to clear EOB
	{
		send, `t
		sleep, 50
	}
	send, {enter}																	;pressed clear EOB
	loop,12																			;loops to eob
	{
		send, `t
		sleep, 50
	}
	send, {enter}																	;pressed EOB
	sleep,1000																		;waits to load
	send, `t																		;puts curos in deposit day	
	return	
;-----------------------------CO45 HOT KEY-------------------------------------------------------
	#numpad7::
	send, co45 {enter}
	return	
;-----------------------------NEW CPT AFTER PAYMNET----------------------------------------------
	^NumpadDiv::
	sleep, 100
	loop,8
	{
		send, `t
		sleep,50
	}
	return
;-----------------------------NEXT CPT CODE HOTKEY-----------------------------------------------
	#NumpadDiv:: 																	;this hotkey tabs to the next cpt code after finishing the first cpt
	loop,5
	{
		send, `t
		sleep,50
	}
	return
	
;-----------------------------FINAL OKAY AND STAY HOTKEY-----------------------------------------------
	^Numpad0:: 																	;this hotkey tabs to the final okay
	loop,9
	{
		send, `t
		sleep, 50
	}
	return
	
;-----------------------------MAIN HOTKEY-----------------------------------------------
	#numpad0::																		;this hot key gets to the payment reason codes
	
	pr1=0
	pr2=0
	pr3=0
	co253=0
	send, ^a 																		;selects allowed ammount
	send, ^c 																		;copies the allowed ammount
	send, `t 																		;tabs to not allowed ammount
	allowed := clipboard 															;saves the allowed amount to variable
	send, ^c																		;copies not allowed ammount
	notallowed := clipboard															;saves the not allowed ammount to varialbe
	send, `t																		;tabs to Pmt Amount
	KeyWait, Enter , D																;waits for key to be pressed
	keywait, enter																	;waits for key to be released
	sleep, 50																		;debounces the switch
	send, ^a																		;selects pmt amount
	send, ^c																		;copies pmt ammount
	pmtamount := clipboard															;saves the pmt amount to variable
	send, `t																		;tabs to payment reason code box
	send, {space}																	;enters payment reason code window
	sleep, 500																		;waits for paymnet reason code window to load
	inputbox, code, Main Payment Reason Code	;****create if statements to allow simple ## with out co or pr	;asks for the main write off code
	send, %code%																	;sends the code into the text box
	send, `t 																		;tabs to amount
	send, %notallowed%																;types in the not allowed amount
	send, `t																		;tabs to units
	send, `t																		;tabs to add
	send, {enter}																	;hits enter to enter the code
	
	
;*******************************allowed!=pmtamount*****************************************
	if(allowed!=pmtamount)															
		{
			gui, destroy
			gui, +alwaysontop
			gui, font, w700
			gui, add, text, x10 y10 , Deductable (PR1)
			gui, add, text, x10 y+20, Co-Insurance (PR2)
			gui, add, text, x10 y+20, Copay (PR3)
			gui, add, text, x10 y+20, Reduction (CO253)
			gui, add, button, x10 y+20 w50 h20  gcalculate, OK
			gui, show, x200 y650 w600 h190, Payment Reason Codes
			gui, font,
			gui, add, edit, x130 y10 vpr1 w40, 0 ; set it to zero and set the size
			gui, add, edit, x130 y+10 vpr2 w40, 0 ; set it to zero and set the size
			gui, add, edit, x130 y+10 vpr3 w40, 0 ; set it to zero and set the size
			gui, add, edit, x130 y+10 vco253 w40, 0 ; set it to zero and set the size
			sleep, 150
			send,`t																				;sets the cursor in the pr1 text box
			KeyWait, enter, D
			keywait,enter
			send,`t																				;sets the cursor in the pr2 text box
			KeyWait, enter, D
			keywait,enter
			send,`t																				;sets the cursor in the pr3 text box
			KeyWait, enter, D
			keywait,enter
			send,`t																				;sets the cursor in the co253 text box
			KeyWait, enter, D
			keywait,enter
			send,`t																				;selects OK button
			send, {enter}
			return
	
	
;*********************************lables***************************************************
			calculate:
	
			gui,submit																			;saves entreted values for pr1, pr2, pr3, co253 into the variables
			gui, cancel   																		;closes the gui
			calcco253:= co253function(pr1,pr2,pr3,allowed,pmtamount)
				if(calcco253!=0)
					{
						send, co253
						send, `t
						sleep 100
						send, %calcco253%
						sleep 100
						send, `t
						send, `t
						sleep, 50
						send, {enter}
					}
			
				if(pr1!=0)
					{
						send, pr1
						send, `t
						sleep 100
						send, %pr1%
						sleep 100
						send, `t
						send, `t
						sleep, 50
						send, {enter}
					}
	
				if(pr2!=0)
					{
						send, pr2
						send, `t
						sleep 100
						send, %pr2%
						sleep 100
						send, `t
						send, `t
						sleep, 50
						send, {enter}
					}
	
				if(pr3!=0)
					{
						send, pr3
						send, `t
						sleep 100
						send, %pr3%
						sleep 100
						send, `t
						send, `t
						sleep, 50
						send, {enter}
						return
					}					
				
	
	;*******************************allowed=Pmtamount******************************************
	else
	{
	KeyWait, space , D																;waits for key to be pressed
	keywait, enter																	;waits for key to be released
	sleep, 100
	return
	}
}