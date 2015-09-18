#include <GUIConstantsEx.au3>
#include <FileConstants.au3>
#include <ButtonConstants.au3>
#include <GuiListView.au3>
#include <EditConstants.au3>
#include <Process.au3>

local $imsg,$btn,$file,$h,$pro,$i,$list,$in,$no,$foc
$h=GUICreate("Process Incinerator ", 280, 400)
$list=GUICtrlCreateListView("    Process_Name "&@TAB&"|PID",0,0,280,300,BitOR($LVS_SINGLESEL,$LVS_NOSORTHEADER),$LVS_EX_FULLROWSELECT)
$pro=ProcessList()
For $i=1 to $pro[0][0]
   _GUICtrlListView_AddItem ( $list,$pro[$i][0],0)
   _GUICtrlListView_AddSubItem($list,$i-1,$pro[$i][1],1,2)
Next
GUICtrlCreateLabel("[ Xtreme Process Incinerator ]-->>>>>"&@CR&@CR&" Enter PID : ",5,320,200,40)
$in=GUICtrlCreateInput("",10,370,170,20,$ES_READONLY)
$btn=GUICtrlCreateButton("Incinerate",195,368,75,25,$BS_DEFPUSHBUTTON)
$ref=GUICtrlCreateButton("Logoff User",195,338,75,25,$BS_DEFPUSHBUTTON)
GUISetState(@SW_SHOW)
$no=$pro[0][0]

While 1
   $imsg=GUIGetMsg()
   $pro=ProcessList()
   If $no<>$pro[0][0] Then
   _GUICtrlListView_DeleteAllItems($list)
   $pro=ProcessList()
   For $i=1 to $pro[0][0]
	  _GUICtrlListView_AddItem ( $list,$pro[$i][0],0)
	  _GUICtrlListView_AddSubItem($list,$i-1,$pro[$i][1],1,2)
   Next
   $no=$pro[0][0]
   EndIf
   $foc=_GUICtrlListView_GetSelectedIndices($list)
   If $foc<>0 Then
	 if NOT($pro[$foc+1][1]==GUICtrlRead($in)) Then
		 GUICtrlSetData($in,$pro[$foc+1][1])
	  EndIf
   Else
	  GUICtrlSetData($in,"")
   EndIf

   Select
	  Case $imsg=$GUI_EVENT_CLOSE
		 GUIDelete()
		 Exit
	  Case $imsg=$btn
		 ;$foc=_GUICtrlListView_GetSelectedIndices($list)
		 ProcessClose(GUICtrlRead($in))
		 if @error>0 Then
			MsgBox(0,"Attention","The Intended process cannot be closed.","",$h)
		 EndIf
		 GUICtrlSetData($in,"")
	  case $imsg=$ref
		 _RunDos("shutdown /l")
   EndSelect
WEnd