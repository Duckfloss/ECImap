# ECI Map

## ecimap.rb FILE.csv IN/OUT [OPTIONS]

ECImap is a command-line Ruby script for parsing color and style information to and from RPro's ECI module. You can access help by typing ecimap.rb -h

### default FILE.csv IN/OUT
  Will take a CSV-formatted file (FILE.csv) with "Attr" and "Color" headers and import (IN) or export (OUT) color-mapping data from or to a copy of RPro's ECLink.ini file.

##### ```-e     FILE.ini```
  Specifies an alternative ECI file to parse color-mapping data to or from.

##### ```-v```
  Runs program verbosely.


### Example
```ecimap.rb "C:/Documents and Settings/pos/desktop/test.csv" IN -e "C:/Documents and Settings/pos/Desktop/ECLink.INI"```

This code will take a CSV-formatted file "test.csv", parse the "Attr" column, look up corresponding color-mapping data from the specified ECI file "ECLink.INI", and save that data back to "test.csv".


### NOTES:
The CSV file should have two columns: "Attr" and "Color".

The default ECI file is located at "C:/Documents and Settings/pos/Desktop/Website/Toolbox/ECImap/data/ECLink.INI". Once this script is run you will have to manually copy the local ECLink.INI to the real ECLink.INI file on the remote RPro server.

You can set the real ECLink.INI file for color mapping IN or OUT; I just don't like monkeying around with RPro's files any more than I have to.