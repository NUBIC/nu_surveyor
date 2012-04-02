# Surveyor on iOS

This project is an iOS port of the Surveyor ruby gem (http://github.com/NUBIC/surveyor). It brings surveys to iPads and other iOS devices, with offline and sync capabilities. It is implemented as a Cocoa Touch static library (NUSurveyor), but also has an example target (NUSurveyorExample). See the NUAppDelegate for an example of how to use the NUSurveyor library in your application.

## Installation

* Clone nu_surveyor from http://github.com/NUBIC/nu_surveyor into the same parent directory as this project, e.g. ~/ios/nu_surveyor
* Click your project, your target and the "Build Phases" tab, "Link Binary With Libraries", click the "+", and add the entire nu_surveyor directory
* Click the "+" again and add "libNUSurveyor.a"
* Under the "Build Settings" tab, make sure "User Header Search Paths" is set to $(BUILT_PRODUCTS_DIR) and "Recursive" is checked
* Under the "Build Settings" tab, make sure "Other linker flags" contains -all_load and -ObjC (capitalization matters)

## Special thanks

* wakibbe (enabling this project)
* abby c-b (managing finances)
* seanvolution (managing expectations)
* rsutphin (guidance)
* jdzak (commiseration)
* Nataliya (stretching the functionality of surveyor)
* ybushmanova (stretching the functionality of surveyor)
* yipdw (dependency graph)
* hyperjeff (dependency evaluation)
* l wy (ethnography, ux)
* The American Mustache Institute (http://www.americanmustacheinstitute.org/mustache-information/styles)