loop 5
{
	try
	{
		Run("C:\Users\iCap\Desktop\Virtual Serial Ports Emulator\VSPEmulator64.exe",,"Min")
		break
	}
	catch as e
	{
		sleep(2000)
	}
}

exitapp()