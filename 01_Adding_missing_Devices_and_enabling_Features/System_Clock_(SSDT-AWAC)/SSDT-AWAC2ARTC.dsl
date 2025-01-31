// Fake ARTC Device. Disables AWAC and HPET. Enables RTC and attachs it to ARTC in IOReag
// For: 300/400/500/600 Series Chipsets
// Experimental! Use one of the SSDT-AWAC variants first if you don't know how this works.

DefinitionBlock ("", "SSDT", 2, "STZO", "ARTC", 0x00000000)
{
    External (_SB_, DeviceObj)
    External (HPTE, IntObj)
    External (STAS, FieldUnitObj)

    Scope (\)
    {
        If (_OSI ("Darwin"))
        {
            STAS = 0x02
            HPTE = Zero
        }
    }

    Scope (\)
    {
        Device (ARTC)
        {
            Name (_HID, EisaId ("PNP0B00") /* AT Real-Time Clock */)  // _HID: Hardware ID
            Name (_CRS, ResourceTemplate ()  // _CRS: Current Resource Settings
            {
                IO (Decode16,
                    0x0070,             // Range Minimum
                    0x0070,             // Range Maximum
                    0x01,               // Alignment
                    0x02,               // Length
                    )
            })
            Method (_STA, 0, NotSerialized)  // _STA: Status
            {
                If (_OSI ("Darwin"))
                {
                    Return (0x0F)
                }
                Else
                {
                    Return (Zero)
                }
            }
        }
    }
}

