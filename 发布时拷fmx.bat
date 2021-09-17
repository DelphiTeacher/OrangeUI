copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\Win32\Debug\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\Win32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\Android\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\Android64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\iOSDevice32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\iOSDevice64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\iOSSimulator\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\OSX32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_1\OSX64\Release\

copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\Win32\Debug\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\Win32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\Android\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\Android64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\iOSDevice32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\iOSDevice64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\iOSSimulator\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\OSX32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_3\OSX64\Release\



copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\Win32\Debug\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\Win32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\Android\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\Android64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\iOSDevice32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\iOSDevice64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\iOSSimulator\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\OSX32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D10_4\OSX64\Release\




copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\Win32\Debug\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\Win32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\Android\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\Android64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\iOSDevice32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\iOSDevice64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\iOSSimulator\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\OSX32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx OrangeUIDesign\DCU\FMX\D11\OSX64\Release\




copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_3\Win32\
copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_3\Win64\


copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_4\Win32\
copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_4\Win64\








MKDIR DCU

CD DCU
MKDIR FMX

CD FMX
MKDIR D10_3

CD D10_3
MKDIR Win32
CD Win32
MKDIR Debug
MKDIR Release

CD ..
MKDIR Android
CD Android
MKDIR Release


CD ..
MKDIR Android64
CD Android64
MKDIR Release

CD ..
MKDIR iOSDevice32
CD iOSDevice32
MKDIR Release


CD ..
MKDIR iOSDevice64
CD iOSDevice64
MKDIR Release


CD ..
MKDIR iOSSimulator
CD iOSSimulator
MKDIR Release


CD ..
MKDIR OSX32
CD OSX32
MKDIR Release


CD ..
MKDIR OSX64
CD OSX64
MKDIR Release

CD ..
MKDIR Win64
CD Win64
MKDIR Release


CD ..
CD ..
CD ..
CD ..













































MKDIR DCU

CD DCU
MKDIR FMX

CD FMX
MKDIR D10_1

CD D10_1
MKDIR Win32
CD Win32
MKDIR Debug
MKDIR Release

CD ..
MKDIR Android
CD Android
MKDIR Release


CD ..
MKDIR Android64
CD Android64
MKDIR Release

CD ..
MKDIR iOSDevice32
CD iOSDevice32
MKDIR Release


CD ..
MKDIR iOSDevice64
CD iOSDevice64
MKDIR Release


CD ..
MKDIR iOSSimulator
CD iOSSimulator
MKDIR Release


CD ..
MKDIR OSX32
CD OSX32
MKDIR Release


CD ..
MKDIR OSX64
CD OSX64
MKDIR Release

CD ..
MKDIR Win64
CD Win64
MKDIR Release


CD ..
CD ..
CD ..
CD ..





copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\Win32\Debug\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\Win32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\Win64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\Android\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\Android64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\iOSDevice32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\iOSDevice64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\iOSSimulator\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\OSX32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_3\OSX64\Release\





copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\Win32\Debug\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\Win32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\Win64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\Android\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\Android64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\iOSDevice32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\iOSDevice64\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\iOSSimulator\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\OSX32\Release\
copy OrangeUIControl\Source\Common\CommonFrames\*.fmx DCU\FMX\D10_4\OSX64\Release\




copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_3\Win32\
copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_3\Win64\


copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_4\Win32\
copy OrangeUIControl\Source\Controls\Windows\*.dfm OrangeUIDesign\DCU\VCL\D10_4\Win64\




PAUSE


