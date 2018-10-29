/*
 * Harbour 2.0.0 (Rev. 13372)
 * MinGW GNU C 4.4.1 (32-bit)
 * Generated C source from "C:/DesarrollosLidei/daniel/buscoprecio.prg"
 */

#include "hbvmpub.h"
#include "hbinit.h"


HB_FUNC( BUSCOPRECIO );
HB_FUNC_EXTERN( _ISWINDOWACTIVE );
HB_FUNC_EXTERN( _DEFINEWINDOW );
HB_FUNC( BUSCOCONFILTRO );
HB_FUNC_EXTERN( DOMETHOD );
HB_FUNC_EXTERN( _DEFINETEXTBOX );
HB_FUNC_EXTERN( _DEFINEMASKEDTEXTBOX );
HB_FUNC_EXTERN( _DEFINECHARMASKTEXTBOX );
HB_FUNC( DEVBUSCOPRECIO );
HB_FUNC_EXTERN( VALTYPE );
HB_FUNC_EXTERN( _DEFINEGRID );
HB_FUNC_EXTERN( _BEGINFRAME );
HB_FUNC_EXTERN( _ENDWINDOW );
HB_FUNC_EXTERN( SETPROPERTY );
HB_FUNC_EXTERN( MSGINFO );
HB_FUNC_EXTERN( RELEASEALLWINDOWS );
HB_FUNC_EXTERN( _ACTIVATEWINDOW );
HB_FUNC_EXTERN( GETPROPERTY );
HB_FUNC_EXTERN( ALLTRIM );
HB_FUNC_EXTERN( ERRORSYS );
HB_FUNC_EXTERN( __DBGENTRY );
HB_FUNC_INITLINES();


HB_INIT_SYMBOLS_BEGIN( hb_vm_SymbolInit_BUSCOPRECIO )
{ "BUSCOPRECIO", {HB_FS_PUBLIC | HB_FS_FIRST | HB_FS_LOCAL}, {HB_FUNCNAME( BUSCOPRECIO )}, NULL },
{ "_ISWINDOWACTIVE", {HB_FS_PUBLIC}, {HB_FUNCNAME( _ISWINDOWACTIVE )}, NULL },
{ "_HMG_SYSDATA", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "_DEFINEWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINEWINDOW )}, NULL },
{ "BUSCOCONFILTRO", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( BUSCOCONFILTRO )}, NULL },
{ "DOMETHOD", {HB_FS_PUBLIC}, {HB_FUNCNAME( DOMETHOD )}, NULL },
{ "_DEFINETEXTBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINETEXTBOX )}, NULL },
{ "_DEFINEMASKEDTEXTBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINEMASKEDTEXTBOX )}, NULL },
{ "_DEFINECHARMASKTEXTBOX", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINECHARMASKTEXTBOX )}, NULL },
{ "DEVBUSCOPRECIO", {HB_FS_PUBLIC | HB_FS_LOCAL}, {HB_FUNCNAME( DEVBUSCOPRECIO )}, NULL },
{ "VALTYPE", {HB_FS_PUBLIC}, {HB_FUNCNAME( VALTYPE )}, NULL },
{ "_DEFINEGRID", {HB_FS_PUBLIC}, {HB_FUNCNAME( _DEFINEGRID )}, NULL },
{ "_BEGINFRAME", {HB_FS_PUBLIC}, {HB_FUNCNAME( _BEGINFRAME )}, NULL },
{ "_ENDWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( _ENDWINDOW )}, NULL },
{ "SETPROPERTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( SETPROPERTY )}, NULL },
{ "QUERY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OSERVER", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "NETERR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "MSGINFO", {HB_FS_PUBLIC}, {HB_FUNCNAME( MSGINFO )}, NULL },
{ "ERROR", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "RELEASEALLWINDOWS", {HB_FS_PUBLIC}, {HB_FUNCNAME( RELEASEALLWINDOWS )}, NULL },
{ "I", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "GETROW", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "OROW", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "FIELDGET", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "LASTREC", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "DESTROY", {HB_FS_PUBLIC | HB_FS_MESSAGE}, {NULL}, NULL },
{ "_ACTIVATEWINDOW", {HB_FS_PUBLIC}, {HB_FUNCNAME( _ACTIVATEWINDOW )}, NULL },
{ "GETPROPERTY", {HB_FS_PUBLIC}, {HB_FUNCNAME( GETPROPERTY )}, NULL },
{ "ALLTRIM", {HB_FS_PUBLIC}, {HB_FUNCNAME( ALLTRIM )}, NULL },
{ "CARTICULO", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CDESCRIPCION", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CPROVEEDOR", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "CARTICULOGLOBAL", {HB_FS_PUBLIC | HB_FS_MEMVAR}, {NULL}, NULL },
{ "ERRORSYS", {HB_FS_PUBLIC}, {HB_FUNCNAME( ERRORSYS )}, NULL },
{ "__DBGENTRY", {HB_FS_PUBLIC}, {HB_FUNCNAME( __DBGENTRY )}, NULL },
{ "(_INITLINES)", {HB_FS_INITEXIT | HB_FS_LOCAL}, {hb_INITLINES}, NULL }
HB_INIT_SYMBOLS_EX_END( hb_vm_SymbolInit_BUSCOPRECIO, "C:/DesarrollosLidei/daniel/buscoprecio.prg", 0x0, 0x0002 )

#if defined( HB_PRAGMA_STARTUP )
   #pragma startup hb_vm_SymbolInit_BUSCOPRECIO
#elif defined( HB_DATASEG_STARTUP )
   #define HB_DATASEG_BODY    HB_DATASEG_FUNC( hb_vm_SymbolInit_BUSCOPRECIO )
   #include "hbiniseg.h"
#endif

HB_FUNC( BUSCOPRECIO )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,51,67,58,47,68,101,115,97,114,114,111,
		108,108,111,115,76,105,100,101,105,47,100,97,110,105,
		101,108,47,98,117,115,99,111,112,114,101,99,105,111,
		46,112,114,103,58,66,85,83,67,79,80,82,69,67,
		73,79,0,36,9,0,37,1,0,67,81,85,69,82,
		89,0,106,1,0,80,1,36,10,0,37,2,0,79,
		81,85,69,82,89,0,36,13,0,176,1,0,106,12,
		98,117,115,99,111,80,114,101,99,105,111,0,12,1,
		32,173,31,36,15,0,106,12,98,117,115,99,111,80,
		114,101,99,105,111,0,98,2,0,93,214,0,2,51,
		98,117,115,99,111,80,114,101,99,105,111,46,102,109,
		103,58,0,36,4,0,176,3,0,100,106,1,0,93,
		107,1,93,146,0,93,82,3,93,191,1,9,9,120,
		9,9,9,106,1,0,90,33,51,98,117,115,99,111,
		80,114,101,99,105,111,46,102,109,103,58,66,85,83,
		67,79,80,82,69,67,73,79,0,100,6,90,36,51,
		98,117,115,99,111,80,114,101,99,105,111,46,102,109,
		103,58,66,85,83,67,79,80,82,69,67,73,79,0,
		36,4,0,100,6,90,36,51,98,117,115,99,111,80,
		114,101,99,105,111,46,102,109,103,58,66,85,83,67,
		79,80,82,69,67,73,79,0,36,4,0,100,6,90,
		36,51,98,117,115,99,111,80,114,101,99,105,111,46,
		102,109,103,58,66,85,83,67,79,80,82,69,67,73,
		79,0,36,4,0,100,6,90,36,51,98,117,115,99,
		111,80,114,101,99,105,111,46,102,109,103,58,66,85,
		83,67,79,80,82,69,67,73,79,0,36,4,0,100,
		6,90,36,51,98,117,115,99,111,80,114,101,99,105,
		111,46,102,109,103,58,66,85,83,67,79,80,82,69,
		67,73,79,0,36,4,0,100,6,100,90,36,51,98,
		117,115,99,111,80,114,101,99,105,111,46,102,109,103,
		58,66,85,83,67,79,80,82,69,67,73,79,0,36,
		4,0,100,6,9,9,9,100,9,100,100,100,100,90,
		36,51,98,117,115,99,111,80,114,101,99,105,111,46,
		102,109,103,58,66,85,83,67,79,80,82,69,67,73,
		79,0,36,4,0,100,6,90,36,51,98,117,115,99,
		111,80,114,101,99,105,111,46,102,109,103,58,66,85,
		83,67,79,80,82,69,67,73,79,0,36,4,0,100,
		6,90,36,51,98,117,115,99,111,80,114,101,99,105,
		111,46,102,109,103,58,66,85,83,67,79,80,82,69,
		67,73,79,0,36,4,0,100,6,100,100,90,36,51,
		98,117,115,99,111,80,114,101,99,105,111,46,102,109,
		103,58,66,85,83,67,79,80,82,69,67,73,79,0,
		36,4,0,100,6,90,36,51,98,117,115,99,111,80,
		114,101,99,105,111,46,102,109,103,58,66,85,83,67,
		79,80,82,69,67,73,79,0,36,4,0,100,6,90,
		36,51,98,117,115,99,111,80,114,101,99,105,111,46,
		102,109,103,58,66,85,83,67,79,80,82,69,67,73,
		79,0,36,4,0,100,6,90,36,51,98,117,115,99,
		111,80,114,101,99,105,111,46,102,109,103,58,66,85,
		83,67,79,80,82,69,67,73,79,0,36,4,0,100,
		6,90,36,51,98,117,115,99,111,80,114,101,99,105,
		111,46,102,109,103,58,66,85,83,67,79,80,82,69,
		67,73,79,0,36,4,0,100,6,90,36,51,98,117,
		115,99,111,80,114,101,99,105,111,46,102,109,103,58,
		66,85,83,67,79,80,82,69,67,73,79,0,36,4,
		0,100,6,9,90,36,51,98,117,115,99,111,80,114,
		101,99,105,111,46,102,109,103,58,66,85,83,67,79,
		80,82,69,67,73,79,0,36,4,0,100,6,90,36,
		51,98,117,115,99,111,80,114,101,99,105,111,46,102,
		109,103,58,66,85,83,67,79,80,82,69,67,73,79,
		0,36,4,0,100,6,100,9,90,36,51,98,117,115,
		99,111,80,114,101,99,105,111,46,102,109,103,58,66,
		85,83,67,79,80,82,69,67,73,79,0,36,4,0,
		100,6,100,100,100,100,100,100,100,100,9,20,56,36,
		6,0,106,7,84,101,120,116,95,49,0,98,2,0,
		93,160,1,2,100,98,2,0,93,161,1,2,100,98,
		2,0,93,176,1,2,100,98,2,0,93,42,1,2,
		100,98,2,0,93,43,1,2,100,98,2,0,93,175,
		1,2,100,98,2,0,93,164,1,2,100,98,2,0,
		93,165,1,2,100,98,2,0,93,178,1,2,100,98,
		2,0,93,166,1,2,100,98,2,0,93,129,1,2,
		100,98,2,0,93,167,1,2,100,98,2,0,93,168,
		1,2,100,98,2,0,93,186,1,2,9,98,2,0,
		93,219,1,2,9,98,2,0,93,220,1,2,9,98,
		2,0,93,221,1,2,9,98,2,0,93,222,1,2,
		100,98,2,0,93,171,1,2,100,98,2,0,93,170,
		1,2,100,98,2,0,93,179,1,2,100,98,2,0,
		93,181,1,2,9,98,2,0,93,184,1,2,9,98,
		2,0,93,185,1,2,9,98,2,0,93,144,1,2,
		100,98,2,0,93,173,1,2,100,98,2,0,93,223,
		1,2,100,98,2,0,93,244,1,2,100,98,2,0,
		93,201,1,2,100,98,2,0,93,202,1,2,9,98,
		2,0,93,156,1,2,9,98,2,0,93,172,1,2,
		9,98,2,0,93,174,1,2,9,98,2,0,93,157,
		1,2,9,98,2,0,93,158,1,2,9,98,2,0,
		93,159,1,2,36,7,0,92,30,98,2,0,93,175,
		1,2,36,8,0,92,20,98,2,0,93,176,1,2,
		36,9,0,92,100,98,2,0,93,164,1,2,36,10,
		0,92,24,98,2,0,93,165,1,2,36,11,0,106,
		6,65,114,105,97,108,0,98,2,0,93,166,1,2,
		36,12,0,92,9,98,2,0,93,167,1,2,36,13,
		0,106,1,0,98,2,0,93,168,1,2,36,14,0,
		90,37,51,98,117,115,99,111,80,114,101,99,105,111,
		46,102,109,103,58,66,85,83,67,79,80,82,69,67,
		73,79,0,176,4,0,12,0,6,98,2,0,93,179,
		1,2,36,15,0,90,33,51,98,117,115,99,111,80,
		114,101,99,105,111,46,102,109,103,58,66,85,83,67,
		79,80,82,69,67,73,79,0,100,6,98,2,0,93,
		170,1,2,36,16,0,90,33,51,98,117,115,99,111,
		80,114,101,99,105,111,46,102,109,103,58,66,85,83,
		67,79,80,82,69,67,73,79,0,100,6,98,2,0,
		93,171,1,2,36,17,0,9,98,2,0,93,156,1,
		2,36,18,0,9,98,2,0,93,157,1,2,36,19,
		0,9,98,2,0,93,159,1,2,36,20,0,9,98,
		2,0,93,158,1,2,36,21,0,90,71,51,98,117,
		115,99,111,80,114,101,99,105,111,46,102,109,103,58,
		66,85,83,67,79,80,82,69,67,73,79,0,176,5,
		0,106,12,98,117,115,99,111,80,114,101,99,105,111,
		0,106,7,116,101,120,116,95,50,0,106,9,115,101,
		116,70,111,99,117,115,0,12,3,6,98,2,0,93,
		181,1,2,36,22,0,100,98,2,0,93,173,1,2,
		36,23,0,9,98,2,0,93,172,1,2,36,24,0,
		9,98,2,0,93,174,1,2,36,25,0,9,98,2,
		0,93,185,1,2,36,26,0,9,98,2,0,93,184,
		1,2,36,27,0,100,98,2,0,93,42,1,2,36,
		28,0,100,98,2,0,93,43,1,2,36,29,0,120,
		98,2,0,93,219,1,2,36,30,0,100,98,2,0,
		93,201,1,2,36,31,0,100,98,2,0,93,202,1,
		2,36,32,0,100,98,2,0,93,223,1,2,36,33,
		0,100,98,2,0,93,244,1,2,36,34,0,106,1,
		0,98,2,0,93,178,1,2,36,35,0,98,2,0,
		93,223,1,1,100,8,29,254,0,98,2,0,93,144,
		1,1,9,8,29,242,0,176,6,0,98,2,0,93,
		160,1,1,98,2,0,93,161,1,1,98,2,0,93,
		176,1,1,98,2,0,93,175,1,1,98,2,0,93,
		164,1,1,98,2,0,93,165,1,1,98,2,0,93,
		178,1,1,98,2,0,93,166,1,1,98,2,0,93,
		167,1,1,98,2,0,93,168,1,1,98,2,0,93,
		186,1,1,98,2,0,93,219,1,1,98,2,0,93,
		220,1,1,98,2,0,93,221,1,1,98,2,0,93,
		222,1,1,98,2,0,93,171,1,1,98,2,0,93,
		170,1,1,98,2,0,93,179,1,1,98,2,0,93,
		181,1,1,98,2,0,93,184,1,1,98,2,0,93,
		173,1,1,98,2,0,93,185,1,1,98,2,0,93,
		156,1,1,98,2,0,93,157,1,1,98,2,0,93,
		159,1,1,98,2,0,93,158,1,1,98,2,0,93,
		129,1,1,98,2,0,93,201,1,1,98,2,0,93,
		202,1,1,98,2,0,93,174,1,1,98,2,0,93,
		172,1,1,98,2,0,93,42,1,1,98,2,0,93,
		43,1,1,20,33,26,192,1,98,2,0,93,221,1,
		1,120,8,29,221,0,176,7,0,98,2,0,93,160,
		1,1,98,2,0,93,161,1,1,98,2,0,93,176,
		1,1,98,2,0,93,175,1,1,98,2,0,93,223,
		1,1,98,2,0,93,164,1,1,98,2,0,93,178,
		1,1,98,2,0,93,166,1,1,98,2,0,93,167,
		1,1,98,2,0,93,168,1,1,98,2,0,93,171,
		1,1,98,2,0,93,170,1,1,98,2,0,93,179,
		1,1,98,2,0,93,165,1,1,98,2,0,93,181,
		1,1,98,2,0,93,184,1,1,98,2,0,93,173,
		1,1,98,2,0,93,244,1,1,98,2,0,93,156,
		1,1,98,2,0,93,157,1,1,98,2,0,93,159,
		1,1,98,2,0,93,158,1,1,98,2,0,93,129,
		1,1,98,2,0,93,201,1,1,98,2,0,93,202,
		1,1,98,2,0,93,185,1,1,98,2,0,93,174,
		1,1,98,2,0,93,172,1,1,98,2,0,93,42,
		1,1,98,2,0,93,43,1,1,20,30,26,218,0,
		176,8,0,98,2,0,93,160,1,1,98,2,0,93,
		161,1,1,98,2,0,93,176,1,1,98,2,0,93,
		175,1,1,98,2,0,93,223,1,1,98,2,0,93,
		164,1,1,98,2,0,93,178,1,1,98,2,0,93,
		166,1,1,98,2,0,93,167,1,1,98,2,0,93,
		168,1,1,98,2,0,93,171,1,1,98,2,0,93,
		170,1,1,98,2,0,93,179,1,1,98,2,0,93,
		165,1,1,98,2,0,93,181,1,1,98,2,0,93,
		184,1,1,98,2,0,93,173,1,1,98,2,0,93,
		156,1,1,98,2,0,93,157,1,1,98,2,0,93,
		159,1,1,98,2,0,93,158,1,1,98,2,0,93,
		129,1,1,98,2,0,93,201,1,1,98,2,0,93,
		202,1,1,98,2,0,93,144,1,1,98,2,0,93,
		185,1,1,98,2,0,93,174,1,1,98,2,0,93,
		172,1,1,98,2,0,93,42,1,1,98,2,0,93,
		43,1,1,20,30,36,37,0,106,7,84,101,120,116,
		95,50,0,98,2,0,93,160,1,2,100,98,2,0,
		93,161,1,2,100,98,2,0,93,176,1,2,100,98,
		2,0,93,42,1,2,100,98,2,0,93,43,1,2,
		100,98,2,0,93,175,1,2,100,98,2,0,93,164,
		1,2,100,98,2,0,93,165,1,2,100,98,2,0,
		93,178,1,2,100,98,2,0,93,166,1,2,100,98,
		2,0,93,129,1,2,100,98,2,0,93,167,1,2,
		100,98,2,0,93,168,1,2,100,98,2,0,93,186,
		1,2,9,98,2,0,93,219,1,2,9,98,2,0,
		93,220,1,2,9,98,2,0,93,221,1,2,9,98,
		2,0,93,222,1,2,100,98,2,0,93,171,1,2,
		100,98,2,0,93,170,1,2,100,98,2,0,93,179,
		1,2,100,98,2,0,93,181,1,2,9,98,2,0,
		93,184,1,2,9,98,2,0,93,185,1,2,9,98,
		2,0,93,144,1,2,100,98,2,0,93,173,1,2,
		100,98,2,0,93,223,1,2,100,98,2,0,93,244,
		1,2,100,98,2,0,93,201,1,2,100,98,2,0,
		93,202,1,2,9,98,2,0,93,156,1,2,9,98,
		2,0,93,172,1,2,9,98,2,0,93,174,1,2,
		9,98,2,0,93,157,1,2,9,98,2,0,93,158,
		1,2,9,98,2,0,93,159,1,2,36,38,0,92,
		30,98,2,0,93,175,1,2,36,39,0,92,120,98,
		2,0,93,176,1,2,36,40,0,93,200,0,98,2,
		0,93,164,1,2,36,41,0,92,24,98,2,0,93,
		165,1,2,36,42,0,106,6,65,114,105,97,108,0,
		98,2,0,93,166,1,2,36,43,0,92,9,98,2,
		0,93,167,1,2,36,44,0,106,1,0,98,2,0,
		93,168,1,2,36,45,0,90,37,51,98,117,115,99,
		111,80,114,101,99,105,111,46,102,109,103,58,66,85,
		83,67,79,80,82,69,67,73,79,0,176,4,0,12,
		0,6,98,2,0,93,179,1,2,36,46,0,90,33,
		51,98,117,115,99,111,80,114,101,99,105,111,46,102,
		109,103,58,66,85,83,67,79,80,82,69,67,73,79,
		0,100,6,98,2,0,93,170,1,2,36,47,0,90,
		33,51,98,117,115,99,111,80,114,101,99,105,111,46,
		102,109,103,58,66,85,83,67,79,80,82,69,67,73,
		79,0,100,6,98,2,0,93,171,1,2,36,48,0,
		9,98,2,0,93,156,1,2,36,49,0,9,98,2,
		0,93,157,1,2,36,50,0,9,98,2,0,93,159,
		1,2,36,51,0,9,98,2,0,93,158,1,2,36,
		52,0,90,71,51,98,117,115,99,111,80,114,101,99,
		105,111,46,102,109,103,58,66,85,83,67,79,80,82,
		69,67,73,79,0,176,5,0,106,12,98,117,115,99,
		111,80,114,101,99,105,111,0,106,7,116,101,120,116,
		95,51,0,106,9,115,101,116,70,111,99,117,115,0,
		12,3,6,98,2,0,93,181,1,2,36,53,0,100,
		98,2,0,93,173,1,2,36,54,0,9,98,2,0,
		93,172,1,2,36,55,0,9,98,2,0,93,174,1,
		2,36,56,0,9,98,2,0,93,185,1,2,36,57,
		0,9,98,2,0,93,184,1,2,36,58,0,100,98,
		2,0,93,42,1,2,36,59,0,100,98,2,0,93,
		43,1,2,36,60,0,120,98,2,0,93,219,1,2,
		36,61,0,100,98,2,0,93,201,1,2,36,62,0,
		100,98,2,0,93,202,1,2,36,63,0,100,98,2,
		0,93,223,1,2,36,64,0,100,98,2,0,93,244,
		1,2,36,65,0,106,1,0,98,2,0,93,178,1,
		2,36,66,0,98,2,0,93,223,1,1,100,8,29,
		254,0,98,2,0,93,144,1,1,9,8,29,242,0,
		176,6,0,98,2,0,93,160,1,1,98,2,0,93,
		161,1,1,98,2,0,93,176,1,1,98,2,0,93,
		175,1,1,98,2,0,93,164,1,1,98,2,0,93,
		165,1,1,98,2,0,93,178,1,1,98,2,0,93,
		166,1,1,98,2,0,93,167,1,1,98,2,0,93,
		168,1,1,98,2,0,93,186,1,1,98,2,0,93,
		219,1,1,98,2,0,93,220,1,1,98,2,0,93,
		221,1,1,98,2,0,93,222,1,1,98,2,0,93,
		171,1,1,98,2,0,93,170,1,1,98,2,0,93,
		179,1,1,98,2,0,93,181,1,1,98,2,0,93,
		184,1,1,98,2,0,93,173,1,1,98,2,0,93,
		185,1,1,98,2,0,93,156,1,1,98,2,0,93,
		157,1,1,98,2,0,93,159,1,1,98,2,0,93,
		158,1,1,98,2,0,93,129,1,1,98,2,0,93,
		201,1,1,98,2,0,93,202,1,1,98,2,0,93,
		174,1,1,98,2,0,93,172,1,1,98,2,0,93,
		42,1,1,98,2,0,93,43,1,1,20,33,26,192,
		1,98,2,0,93,221,1,1,120,8,29,221,0,176,
		7,0,98,2,0,93,160,1,1,98,2,0,93,161,
		1,1,98,2,0,93,176,1,1,98,2,0,93,175,
		1,1,98,2,0,93,223,1,1,98,2,0,93,164,
		1,1,98,2,0,93,178,1,1,98,2,0,93,166,
		1,1,98,2,0,93,167,1,1,98,2,0,93,168,
		1,1,98,2,0,93,171,1,1,98,2,0,93,170,
		1,1,98,2,0,93,179,1,1,98,2,0,93,165,
		1,1,98,2,0,93,181,1,1,98,2,0,93,184,
		1,1,98,2,0,93,173,1,1,98,2,0,93,244,
		1,1,98,2,0,93,156,1,1,98,2,0,93,157,
		1,1,98,2,0,93,159,1,1,98,2,0,93,158,
		1,1,98,2,0,93,129,1,1,98,2,0,93,201,
		1,1,98,2,0,93,202,1,1,98,2,0,93,185,
		1,1,98,2,0,93,174,1,1,98,2,0,93,172,
		1,1,98,2,0,93,42,1,1,98,2,0,93,43,
		1,1,20,30,26,218,0,176,8,0,98,2,0,93,
		160,1,1,98,2,0,93,161,1,1,98,2,0,93,
		176,1,1,98,2,0,93,175,1,1,98,2,0,93,
		223,1,1,98,2,0,93,164,1,1,98,2,0,93,
		178,1,1,98,2,0,93,166,1,1,98,2,0,93,
		167,1,1,98,2,0,93,168,1,1,98,2,0,93,
		171,1,1,98,2,0,93,170,1,1,98,2,0,93,
		179,1,1,98,2,0,93,165,1,1,98,2,0,93,
		181,1,1,98,2,0,93,184,1,1,98,2,0,93,
		173,1,1,98,2,0,93,156,1,1,98,2,0,93,
		157,1,1,98,2,0,93,159,1,1,98,2,0,93,
		158,1,1,98,2,0,93,129,1,1,98,2,0,93,
		201,1,1,98,2,0,93,202,1,1,98,2,0,93,
		144,1,1,98,2,0,93,185,1,1,98,2,0,93,
		174,1,1,98,2,0,93,172,1,1,98,2,0,93,
		42,1,1,98,2,0,93,43,1,1,20,30,36,68,
		0,106,7,84,101,120,116,95,51,0,98,2,0,93,
		160,1,2,100,98,2,0,93,161,1,2,100,98,2,
		0,93,176,1,2,100,98,2,0,93,42,1,2,100,
		98,2,0,93,43,1,2,100,98,2,0,93,175,1,
		2,100,98,2,0,93,164,1,2,100,98,2,0,93,
		165,1,2,100,98,2,0,93,178,1,2,100,98,2,
		0,93,166,1,2,100,98,2,0,93,129,1,2,100,
		98,2,0,93,167,1,2,100,98,2,0,93,168,1,
		2,100,98,2,0,93,186,1,2,9,98,2,0,93,
		219,1,2,9,98,2,0,93,220,1,2,9,98,2,
		0,93,221,1,2,9,98,2,0,93,222,1,2,100,
		98,2,0,93,171,1,2,100,98,2,0,93,170,1,
		2,100,98,2,0,93,179,1,2,100,98,2,0,93,
		181,1,2,9,98,2,0,93,184,1,2,9,98,2,
		0,93,185,1,2,9,98,2,0,93,144,1,2,100,
		98,2,0,93,173,1,2,100,98,2,0,93,223,1,
		2,100,98,2,0,93,244,1,2,100,98,2,0,93,
		201,1,2,100,98,2,0,93,202,1,2,9,98,2,
		0,93,156,1,2,9,98,2,0,93,172,1,2,9,
		98,2,0,93,174,1,2,9,98,2,0,93,157,1,
		2,9,98,2,0,93,158,1,2,9,98,2,0,93,
		159,1,2,36,69,0,92,30,98,2,0,93,175,1,
		2,36,70,0,93,64,1,98,2,0,93,176,1,2,
		36,71,0,93,200,0,98,2,0,93,164,1,2,36,
		72,0,92,24,98,2,0,93,165,1,2,36,73,0,
		106,6,65,114,105,97,108,0,98,2,0,93,166,1,
		2,36,74,0,92,9,98,2,0,93,167,1,2,36,
		75,0,106,1,0,98,2,0,93,168,1,2,36,76,
		0,90,37,51,98,117,115,99,111,80,114,101,99,105,
		111,46,102,109,103,58,66,85,83,67,79,80,82,69,
		67,73,79,0,176,4,0,12,0,6,98,2,0,93,
		179,1,2,36,77,0,90,33,51,98,117,115,99,111,
		80,114,101,99,105,111,46,102,109,103,58,66,85,83,
		67,79,80,82,69,67,73,79,0,100,6,98,2,0,
		93,170,1,2,36,78,0,90,33,51,98,117,115,99,
		111,80,114,101,99,105,111,46,102,109,103,58,66,85,
		83,67,79,80,82,69,67,73,79,0,100,6,98,2,
		0,93,171,1,2,36,79,0,9,98,2,0,93,156,
		1,2,36,80,0,9,98,2,0,93,157,1,2,36,
		81,0,9,98,2,0,93,159,1,2,36,82,0,9,
		98,2,0,93,158,1,2,36,83,0,90,71,51,98,
		117,115,99,111,80,114,101,99,105,111,46,102,109,103,
		58,66,85,83,67,79,80,82,69,67,73,79,0,176,
		5,0,106,12,98,117,115,99,111,80,114,101,99,105,
		111,0,106,7,116,101,120,116,95,49,0,106,9,115,
		101,116,70,111,99,117,115,0,12,3,6,98,2,0,
		93,181,1,2,36,84,0,100,98,2,0,93,173,1,
		2,36,85,0,9,98,2,0,93,172,1,2,36,86,
		0,9,98,2,0,93,174,1,2,36,87,0,9,98,
		2,0,93,185,1,2,36,88,0,9,98,2,0,93,
		184,1,2,36,89,0,100,98,2,0,93,42,1,2,
		36,90,0,100,98,2,0,93,43,1,2,36,91,0,
		120,98,2,0,93,219,1,2,36,92,0,100,98,2,
		0,93,201,1,2,36,93,0,100,98,2,0,93,202,
		1,2,36,94,0,100,98,2,0,93,223,1,2,36,
		95,0,100,98,2,0,93,244,1,2,36,96,0,106,
		1,0,98,2,0,93,178,1,2,36,97,0,98,2,
		0,93,223,1,1,100,8,29,254,0,98,2,0,93,
		144,1,1,9,8,29,242,0,176,6,0,98,2,0,
		93,160,1,1,98,2,0,93,161,1,1,98,2,0,
		93,176,1,1,98,2,0,93,175,1,1,98,2,0,
		93,164,1,1,98,2,0,93,165,1,1,98,2,0,
		93,178,1,1,98,2,0,93,166,1,1,98,2,0,
		93,167,1,1,98,2,0,93,168,1,1,98,2,0,
		93,186,1,1,98,2,0,93,219,1,1,98,2,0,
		93,220,1,1,98,2,0,93,221,1,1,98,2,0,
		93,222,1,1,98,2,0,93,171,1,1,98,2,0,
		93,170,1,1,98,2,0,93,179,1,1,98,2,0,
		93,181,1,1,98,2,0,93,184,1,1,98,2,0,
		93,173,1,1,98,2,0,93,185,1,1,98,2,0,
		93,156,1,1,98,2,0,93,157,1,1,98,2,0,
		93,159,1,1,98,2,0,93,158,1,1,98,2,0,
		93,129,1,1,98,2,0,93,201,1,1,98,2,0,
		93,202,1,1,98,2,0,93,174,1,1,98,2,0,
		93,172,1,1,98,2,0,93,42,1,1,98,2,0,
		93,43,1,1,20,33,26,192,1,98,2,0,93,221,
		1,1,120,8,29,221,0,176,7,0,98,2,0,93,
		160,1,1,98,2,0,93,161,1,1,98,2,0,93,
		176,1,1,98,2,0,93,175,1,1,98,2,0,93,
		223,1,1,98,2,0,93,164,1,1,98,2,0,93,
		178,1,1,98,2,0,93,166,1,1,98,2,0,93,
		167,1,1,98,2,0,93,168,1,1,98,2,0,93,
		171,1,1,98,2,0,93,170,1,1,98,2,0,93,
		179,1,1,98,2,0,93,165,1,1,98,2,0,93,
		181,1,1,98,2,0,93,184,1,1,98,2,0,93,
		173,1,1,98,2,0,93,244,1,1,98,2,0,93,
		156,1,1,98,2,0,93,157,1,1,98,2,0,93,
		159,1,1,98,2,0,93,158,1,1,98,2,0,93,
		129,1,1,98,2,0,93,201,1,1,98,2,0,93,
		202,1,1,98,2,0,93,185,1,1,98,2,0,93,
		174,1,1,98,2,0,93,172,1,1,98,2,0,93,
		42,1,1,98,2,0,93,43,1,1,20,30,26,218,
		0,176,8,0,98,2,0,93,160,1,1,98,2,0,
		93,161,1,1,98,2,0,93,176,1,1,98,2,0,
		93,175,1,1,98,2,0,93,223,1,1,98,2,0,
		93,164,1,1,98,2,0,93,178,1,1,98,2,0,
		93,166,1,1,98,2,0,93,167,1,1,98,2,0,
		93,168,1,1,98,2,0,93,171,1,1,98,2,0,
		93,170,1,1,98,2,0,93,179,1,1,98,2,0,
		93,165,1,1,98,2,0,93,181,1,1,98,2,0,
		93,184,1,1,98,2,0,93,173,1,1,98,2,0,
		93,156,1,1,98,2,0,93,157,1,1,98,2,0,
		93,159,1,1,98,2,0,93,158,1,1,98,2,0,
		93,129,1,1,98,2,0,93,201,1,1,98,2,0,
		93,202,1,1,98,2,0,93,144,1,1,98,2,0,
		93,185,1,1,98,2,0,93,174,1,1,98,2,0,
		93,172,1,1,98,2,0,93,42,1,1,98,2,0,
		93,43,1,1,20,30,36,99,0,120,98,2,0,93,
		127,1,2,100,98,2,0,93,126,1,2,106,7,71,
		114,105,100,95,49,0,98,2,0,93,160,1,2,100,
		98,2,0,93,161,1,2,100,98,2,0,93,176,1,
		2,100,98,2,0,93,175,1,2,100,98,2,0,93,
		164,1,2,100,98,2,0,93,165,1,2,100,98,2,
		0,93,189,1,2,100,98,2,0,93,190,1,2,100,
		98,2,0,93,25,1,2,100,98,2,0,93,180,1,
		2,100,98,2,0,93,178,1,2,100,98,2,0,93,
		166,1,2,100,98,2,0,93,167,1,2,100,98,2,
		0,93,168,1,2,100,98,2,0,93,170,1,2,100,
		98,2,0,93,179,1,2,100,98,2,0,93,171,1,
		2,100,98,2,0,93,191,1,2,100,98,2,0,93,
		192,1,2,9,98,2,0,93,193,1,2,100,98,2,
		0,93,194,1,2,100,98,2,0,93,195,1,2,100,
		98,2,0,93,173,1,2,9,98,2,0,93,199,1,
		2,9,98,2,0,93,187,1,2,9,98,2,0,93,
		156,1,2,9,98,2,0,93,157,1,2,9,98,2,
		0,93,158,1,2,9,98,2,0,93,159,1,2,100,
		98,2,0,93,152,1,2,100,98,2,0,93,151,1,
		2,100,98,2,0,93,201,1,2,100,98,2,0,93,
		202,1,2,100,98,2,0,93,185,1,2,9,98,2,
		0,93,154,1,2,9,98,2,0,93,145,1,2,9,
		98,2,0,93,200,1,2,9,98,2,0,93,73,1,
		2,100,98,2,0,93,135,1,2,100,98,2,0,93,
		134,1,2,100,98,2,0,93,132,1,2,100,98,2,
		0,93,246,0,2,100,98,2,0,93,131,1,2,100,
		98,2,0,93,71,1,2,100,98,2,0,93,70,1,
		2,9,98,2,0,93,69,1,2,9,98,2,0,93,
		226,1,2,100,98,2,0,93,230,1,2,100,98,2,
		0,93,244,0,2,100,98,2,0,93,21,1,2,100,
		98,2,0,93,130,1,2,36,100,0,92,60,98,2,
		0,93,175,1,2,36,101,0,92,20,98,2,0,93,
		176,1,2,36,102,0,93,32,3,98,2,0,93,164,
		1,2,36,103,0,93,74,1,98,2,0,93,165,1,
		2,36,104,0,100,98,2,0,93,180,1,2,36,105,
		0,100,98,2,0,93,178,1,2,36,106,0,92,80,
		93,200,0,93,200,0,92,80,92,80,93,200,0,4,
		6,0,98,2,0,93,190,1,2,36,107,0,106,7,
		67,111,100,105,103,111,0,106,12,68,101,115,99,114,
		105,112,99,105,111,110,0,106,8,73,110,116,101,114,
		110,111,0,106,6,70,101,99,104,97,0,106,13,80,
		114,101,99,105,111,32,86,101,110,116,97,0,106,10,
		80,114,111,118,101,101,100,111,114,0,4,6,0,98,
		2,0,93,189,1,2,36,108,0,106,6,65,114,105,
		97,108,0,98,2,0,93,166,1,2,36,109,0,92,
		9,98,2,0,93,167,1,2,36,110,0,106,1,0,
		98,2,0,93,168,1,2,36,111,0,90,33,51,98,
		117,115,99,111,80,114,101,99,105,111,46,102,109,103,
		58,66,85,83,67,79,80,82,69,67,73,79,0,100,
		6,98,2,0,93,179,1,2,36,112,0,90,33,51,
		98,117,115,99,111,80,114,101,99,105,111,46,102,109,
		103,58,66,85,83,67,79,80,82,69,67,73,79,0,
		100,6,98,2,0,93,170,1,2,36,113,0,90,33,
		51,98,117,115,99,111,80,114,101,99,105,111,46,102,
		109,103,58,66,85,83,67,79,80,82,69,67,73,79,
		0,100,6,98,2,0,93,171,1,2,36,114,0,9,
		98,2,0,93,156,1,2,36,115,0,9,98,2,0,
		93,157,1,2,36,116,0,9,98,2,0,93,159,1,
		2,36,117,0,9,98,2,0,93,158,1,2,36,118,
		0,90,37,51,98,117,115,99,111,80,114,101,99,105,
		111,46,102,109,103,58,66,85,83,67,79,80,82,69,
		67,73,79,0,176,9,0,12,0,6,98,2,0,93,
		191,1,2,36,119,0,100,98,2,0,93,192,1,2,
		36,120,0,90,33,51,98,117,115,99,111,80,114,101,
		99,105,111,46,102,109,103,58,66,85,83,67,79,80,
		82,69,67,73,79,0,100,6,98,2,0,93,152,1,
		2,36,121,0,9,98,2,0,93,199,1,2,36,122,
		0,9,98,2,0,93,200,1,2,36,123,0,9,98,
		2,0,93,154,1,2,36,124,0,100,98,2,0,93,
		135,1,2,36,125,0,100,98,2,0,93,134,1,2,
		36,126,0,100,98,2,0,93,130,1,2,36,127,0,
		100,98,2,0,93,131,1,2,36,128,0,100,98,2,
		0,93,132,1,2,36,129,0,120,98,2,0,93,126,
		1,2,36,130,0,9,98,2,0,93,73,1,2,36,
		131,0,9,98,2,0,93,193,1,2,36,132,0,100,
		98,2,0,93,173,1,2,36,133,0,100,98,2,0,
		93,194,1,2,36,134,0,100,100,100,100,122,4,5,
		0,98,2,0,93,195,1,2,36,135,0,100,98,2,
		0,93,151,1,2,36,136,0,100,98,2,0,93,201,
		1,2,36,137,0,100,98,2,0,93,202,1,2,36,
		138,0,100,98,2,0,93,246,0,2,36,139,0,100,
		98,2,0,93,71,1,2,36,140,0,100,98,2,0,
		93,70,1,2,36,141,0,9,98,2,0,93,230,1,
		2,36,142,0,9,98,2,0,93,226,1,2,36,143,
		0,9,98,2,0,93,69,1,2,36,144,0,100,98,
		2,0,93,244,0,2,36,145,0,176,10,0,100,12,
		1,106,2,85,0,8,28,5,100,25,35,90,33,51,
		98,117,115,99,111,80,114,101,99,105,111,46,102,109,
		103,58,66,85,83,67,79,80,82,69,67,73,79,0,
		100,6,98,2,0,93,21,1,2,36,146,0,121,98,
		2,0,93,25,1,2,36,147,0,9,98,2,0,93,
		127,1,2,176,11,0,98,2,0,93,160,1,1,98,
		2,0,93,161,1,1,98,2,0,93,176,1,1,98,
		2,0,93,175,1,1,98,2,0,93,164,1,1,98,
		2,0,93,165,1,1,98,2,0,93,189,1,1,98,
		2,0,93,190,1,1,98,2,0,93,180,1,1,98,
		2,0,93,178,1,1,98,2,0,93,166,1,1,98,
		2,0,93,167,1,1,98,2,0,93,168,1,1,98,
		2,0,93,179,1,1,98,2,0,93,191,1,1,98,
		2,0,93,192,1,1,98,2,0,93,170,1,1,98,
		2,0,93,171,1,1,98,2,0,93,193,1,1,98,
		2,0,93,194,1,1,98,2,0,93,195,1,1,98,
		2,0,93,187,1,1,98,2,0,93,173,1,1,98,
		2,0,93,156,1,1,98,2,0,93,157,1,1,98,
		2,0,93,159,1,1,98,2,0,93,158,1,1,98,
		2,0,93,154,1,1,98,2,0,93,152,1,1,98,
		2,0,93,151,1,1,100,100,100,98,2,0,93,199,
		1,1,100,98,2,0,93,201,1,1,98,2,0,93,
		202,1,1,98,2,0,93,200,1,1,98,2,0,93,
		132,1,1,98,2,0,93,135,1,1,98,2,0,93,
		134,1,1,98,2,0,93,131,1,1,98,2,0,93,
		130,1,1,98,2,0,93,126,1,1,98,2,0,93,
		246,0,1,98,2,0,93,73,1,1,98,2,0,93,
		71,1,1,98,2,0,93,70,1,1,98,2,0,93,
		230,1,1,98,2,0,93,69,1,1,98,2,0,93,
		226,1,1,98,2,0,93,244,0,1,98,2,0,93,
		21,1,1,98,2,0,93,25,1,1,20,54,36,149,
		0,106,8,70,114,97,109,101,95,49,0,98,2,0,
		93,160,1,2,100,98,2,0,93,161,1,2,100,98,
		2,0,93,175,1,2,100,98,2,0,93,176,1,2,
		100,98,2,0,93,164,1,2,100,98,2,0,93,165,
		1,2,100,98,2,0,93,162,1,2,100,98,2,0,
		93,166,1,2,100,98,2,0,93,167,1,2,100,98,
		2,0,93,201,1,2,100,98,2,0,93,202,1,2,
		9,98,2,0,93,207,1,2,9,98,2,0,93,188,
		1,2,9,98,2,0,93,156,1,2,9,98,2,0,
		93,157,1,2,9,98,2,0,93,158,1,2,9,98,
		2,0,93,159,1,2,36,150,0,92,10,98,2,0,
		93,175,1,2,36,151,0,92,10,98,2,0,93,176,
		1,2,36,152,0,93,52,3,98,2,0,93,164,1,
		2,36,153,0,93,134,1,98,2,0,93,165,1,2,
		36,154,0,106,6,65,114,105,97,108,0,98,2,0,
		93,166,1,2,36,155,0,92,9,98,2,0,93,167,
		1,2,36,156,0,120,98,2,0,93,156,1,2,36,
		157,0,9,98,2,0,93,157,1,2,36,158,0,9,
		98,2,0,93,159,1,2,36,159,0,9,98,2,0,
		93,158,1,2,36,160,0,106,8,70,114,97,109,101,
		95,49,0,98,2,0,93,162,1,2,36,161,0,100,
		98,2,0,93,201,1,2,36,162,0,100,98,2,0,
		93,202,1,2,36,163,0,120,98,2,0,93,188,1,
		2,36,164,0,176,12,0,98,2,0,93,160,1,1,
		98,2,0,93,161,1,1,98,2,0,93,175,1,1,
		98,2,0,93,176,1,1,98,2,0,93,164,1,1,
		98,2,0,93,165,1,1,98,2,0,93,162,1,1,
		98,2,0,93,166,1,1,98,2,0,93,167,1,1,
		98,2,0,93,188,1,1,98,2,0,93,156,1,1,
		98,2,0,93,157,1,1,98,2,0,93,159,1,1,
		98,2,0,93,158,1,1,98,2,0,93,201,1,1,
		98,2,0,93,202,1,1,98,2,0,93,207,1,1,
		20,17,36,166,0,176,13,0,20,0,51,67,58,47,
		68,101,115,97,114,114,111,108,108,111,115,76,105,100,
		101,105,47,100,97,110,105,101,108,47,98,117,115,99,
		111,112,114,101,99,105,111,46,112,114,103,58,0,36,
		16,0,176,14,0,106,12,98,117,115,99,111,80,114,
		101,99,105,111,0,106,6,116,105,116,108,101,0,106,
		18,80,114,101,99,105,111,115,32,65,114,116,105,99,
		117,108,111,115,0,20,3,36,17,0,176,14,0,106,
		12,98,117,115,99,111,80,114,101,99,105,111,0,106,
		8,102,114,97,109,101,95,49,0,106,8,99,97,112,
		116,105,111,110,0,106,10,82,101,112,117,101,115,116,
		111,115,0,20,4,36,18,0,106,132,32,115,101,108,
		101,99,116,32,97,46,99,111,100,105,103,111,95,98,
		97,114,114,97,44,32,97,46,100,101,115,99,114,105,
		112,99,105,111,110,44,97,46,100,97,116,111,95,105,
		110,116,101,114,110,111,44,32,100,97,116,101,95,102,
		111,114,109,97,116,40,97,46,102,101,99,104,97,95,
		112,114,101,99,105,111,44,39,37,100,47,37,109,47,
		37,89,39,41,44,99,111,110,99,97,116,40,39,36,
		32,39,44,97,46,112,114,101,99,105,111,95,118,101,
		110,116,97,41,44,32,112,46,110,111,109,98,114,101,
		32,0,80,1,36,19,0,96,1,0,106,31,32,102,
		114,111,109,32,97,114,116,105,99,117,108,111,32,97,
		32,44,32,112,114,111,118,101,101,100,111,114,32,112,
		0,135,36,20,0,96,1,0,106,40,32,119,104,101,
		114,101,32,97,46,105,100,95,112,114,111,118,101,101,
		100,111,114,32,61,32,112,46,105,100,95,112,114,111,
		118,101,101,100,111,114,32,0,135,36,21,0,96,1,
		0,106,22,32,111,114,100,101,114,32,98,121,32,50,
		32,108,105,109,105,116,32,50,48,48,0,135,36,22,
		0,48,15,0,109,16,0,95,1,112,1,80,2,36,
		23,0,48,17,0,95,2,112,0,28,55,36,24,0,
		176,18,0,106,19,83,81,76,32,83,69,76,69,67,
		84,32,101,114,114,111,114,58,32,0,48,19,0,95,
		2,112,0,72,20,1,36,25,0,176,20,0,20,0,
		36,26,0,176,20,0,20,0,36,29,0,122,165,83,
		21,0,26,133,0,36,30,0,48,22,0,95,2,109,
		21,0,112,1,83,23,0,36,31,0,176,5,0,106,
		12,98,117,115,99,111,80,114,101,99,105,111,0,106,
		7,103,114,105,100,95,49,0,106,8,97,100,100,73,
		116,101,109,0,48,24,0,109,23,0,122,112,1,48,
		24,0,109,23,0,92,2,112,1,48,24,0,109,23,
		0,92,3,112,1,48,24,0,109,23,0,92,4,112,
		1,48,24,0,109,23,0,92,5,112,1,48,24,0,
		109,23,0,92,6,112,1,4,6,0,20,4,36,29,
		0,109,21,0,23,21,83,21,0,48,25,0,95,2,
		112,0,15,29,118,255,36,34,0,48,26,0,95,2,
		112,0,73,36,35,0,176,5,0,106,12,98,117,115,
		99,111,80,114,101,99,105,111,0,106,7,67,101,110,
		116,101,114,0,20,2,36,36,0,176,27,0,106,12,
		98,117,115,99,111,80,114,101,99,105,111,0,4,1,
		0,20,1,36,39,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( BUSCOCONFILTRO )
{
	static const HB_BYTE pcode[] =
	{
		13,2,0,51,67,58,47,68,101,115,97,114,114,111,
		108,108,111,115,76,105,100,101,105,47,100,97,110,105,
		101,108,47,98,117,115,99,111,112,114,101,99,105,111,
		46,112,114,103,58,66,85,83,67,79,67,79,78,70,
		73,76,84,82,79,0,36,42,0,37,1,0,67,81,
		85,69,82,89,0,37,2,0,79,81,85,69,82,89,
		0,36,47,0,176,5,0,106,12,98,117,115,99,111,
		80,114,101,99,105,111,0,106,7,103,114,105,100,95,
		49,0,106,15,100,101,108,101,116,101,65,108,108,73,
		116,101,109,115,0,20,3,36,49,0,176,28,0,106,
		12,98,117,115,99,111,80,114,101,99,105,111,0,106,
		7,116,101,120,116,95,49,0,106,6,118,97,108,117,
		101,0,12,3,100,5,28,10,106,4,34,37,34,0,
		25,55,106,3,32,34,0,176,29,0,176,28,0,106,
		12,98,117,115,99,111,80,114,101,99,105,111,0,106,
		7,116,101,120,116,95,49,0,106,6,118,97,108,117,
		101,0,12,3,12,1,72,106,3,37,34,0,72,83,
		30,0,36,50,0,176,28,0,106,12,98,117,115,99,
		111,80,114,101,99,105,111,0,106,7,116,101,120,116,
		95,50,0,106,6,118,97,108,117,101,0,12,3,100,
		5,28,10,106,4,34,37,34,0,25,55,106,3,32,
		34,0,176,29,0,176,28,0,106,12,98,117,115,99,
		111,80,114,101,99,105,111,0,106,7,116,101,120,116,
		95,50,0,106,6,118,97,108,117,101,0,12,3,12,
		1,72,106,3,37,34,0,72,83,31,0,36,51,0,
		176,28,0,106,12,98,117,115,99,111,80,114,101,99,
		105,111,0,106,7,116,101,120,116,95,51,0,106,6,
		118,97,108,117,101,0,12,3,100,5,28,10,106,4,
		34,37,34,0,25,55,106,3,32,34,0,176,29,0,
		176,28,0,106,12,98,117,115,99,111,80,114,101,99,
		105,111,0,106,7,116,101,120,116,95,51,0,106,6,
		118,97,108,117,101,0,12,3,12,1,72,106,3,37,
		34,0,72,83,32,0,36,55,0,106,132,32,115,101,
		108,101,99,116,32,97,46,99,111,100,105,103,111,95,
		98,97,114,114,97,44,32,97,46,100,101,115,99,114,
		105,112,99,105,111,110,44,97,46,100,97,116,111,95,
		105,110,116,101,114,110,111,32,44,100,97,116,101,95,
		102,111,114,109,97,116,40,97,46,102,101,99,104,97,
		95,112,114,101,99,105,111,44,39,37,100,47,37,109,
		47,37,89,39,41,44,99,111,110,99,97,116,40,39,
		36,32,39,44,97,46,112,114,101,99,105,111,95,118,
		101,110,116,97,41,44,32,112,46,110,111,109,98,114,
		101,32,0,80,1,36,56,0,96,1,0,106,31,32,
		102,114,111,109,32,97,114,116,105,99,117,108,111,32,
		97,44,32,112,114,111,118,101,101,100,111,114,32,112,
		32,0,135,36,57,0,96,1,0,106,40,32,119,104,
		101,114,101,32,97,46,105,100,95,112,114,111,118,101,
		101,100,111,114,32,61,32,112,46,105,100,95,112,114,
		111,118,101,101,100,111,114,32,0,135,36,58,0,96,
		1,0,106,26,32,97,110,100,32,32,97,46,100,101,
		115,99,114,105,112,99,105,111,110,32,76,73,75,69,
		32,0,109,31,0,72,106,3,32,32,0,72,135,36,
		59,0,96,1,0,106,26,32,97,110,100,32,97,46,
		100,97,116,111,95,105,110,116,101,114,110,111,32,76,
		73,75,69,32,0,109,32,0,72,106,2,32,0,72,
		135,36,60,0,96,1,0,106,26,32,97,110,100,32,
		97,46,99,111,100,105,103,111,95,98,97,114,114,97,
		32,76,73,75,69,32,0,109,30,0,72,106,23,32,
		32,111,114,100,101,114,32,98,121,32,50,32,108,105,
		109,105,116,32,49,48,48,0,72,135,36,62,0,48,
		15,0,109,16,0,95,1,112,1,80,2,36,63,0,
		48,17,0,95,2,112,0,28,55,36,64,0,176,18,
		0,106,19,83,81,76,32,83,69,76,69,67,84,32,
		101,114,114,111,114,58,32,0,48,19,0,95,2,112,
		0,72,20,1,36,65,0,176,20,0,20,0,36,66,
		0,176,20,0,20,0,36,69,0,122,165,83,21,0,
		26,133,0,36,70,0,48,22,0,95,2,109,21,0,
		112,1,83,23,0,36,71,0,176,5,0,106,12,98,
		117,115,99,111,80,114,101,99,105,111,0,106,7,103,
		114,105,100,95,49,0,106,8,97,100,100,73,116,101,
		109,0,48,24,0,109,23,0,122,112,1,48,24,0,
		109,23,0,92,2,112,1,48,24,0,109,23,0,92,
		3,112,1,48,24,0,109,23,0,92,4,112,1,48,
		24,0,109,23,0,92,5,112,1,48,24,0,109,23,
		0,92,6,112,1,4,6,0,20,4,36,69,0,109,
		21,0,23,21,83,21,0,48,25,0,95,2,112,0,
		15,29,118,255,36,74,0,48,26,0,95,2,112,0,
		73,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC( DEVBUSCOPRECIO )
{
	static const HB_BYTE pcode[] =
	{
		51,67,58,47,68,101,115,97,114,114,111,108,108,111,
		115,76,105,100,101,105,47,100,97,110,105,101,108,47,
		98,117,115,99,111,112,114,101,99,105,111,46,112,114,
		103,58,68,69,86,66,85,83,67,79,80,82,69,67,
		73,79,0,36,80,0,176,28,0,106,12,98,117,115,
		99,111,80,114,101,99,105,111,0,106,7,103,114,105,
		100,95,49,0,106,5,105,116,101,109,0,176,28,0,
		106,12,98,117,115,99,111,80,114,101,99,105,111,0,
		106,7,103,114,105,100,95,49,0,106,6,118,97,108,
		117,101,0,12,3,12,4,122,1,83,33,0,36,82,
		0,176,5,0,106,12,98,117,115,99,111,80,114,101,
		99,105,111,0,106,8,82,101,108,101,97,115,101,0,
		20,2,36,84,0,7
	};

	hb_vmExecute( pcode, symbols );
}

HB_FUNC_INITLINES()
{
	static const HB_BYTE pcode[] =
	{
		51,67,58,47,68,101,115,97,114,114,111,108,108,111,
		115,76,105,100,101,105,47,100,97,110,105,101,108,47,
		98,117,115,99,111,112,114,101,99,105,111,46,112,114,
		103,58,40,95,73,78,73,84,76,73,78,69,83,41,
		0,106,16,98,117,115,99,111,80,114,101,99,105,111,
		46,102,109,103,0,121,106,22,208,255,255,255,239,255,
		255,255,247,255,255,255,251,255,255,255,255,255,239,255,
		95,0,4,3,0,106,2,67,0,92,8,106,11,166,
		255,231,156,132,142,223,231,4,21,0,4,3,0,4,
		2,0,110,7
	};

	hb_vmExecute( pcode, symbols );
}
