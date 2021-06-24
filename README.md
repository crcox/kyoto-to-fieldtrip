# kyoto-to-fieldtrip

Basic script and helper functions for getting a Kyoto ECoG file into a
format the FieldTrip understands.

## Requirements
* [FieldTrip](https://github.com/fieldtrip/fieldtrip)
* [ECoG_Data_Prep](https://github.com/crcox/ECoG_data_prep): In addition to scripts written to process the raw Kyoto data into windowed matrices and associated metadata files, thie repository also contains important metadata like stimulus lists, timing files, and coordinates.
* [MNI ICBM152 non-linear atlas](http://nist.mni.mcgill.ca/mni-icbm152-non-linear-6th-generation-symmetric-average-brain-stereotaxic-registration-model/)
* A Kyoto dataset in it's original format.


## Usage
Update the paths in the script to point to files on your local machine,
and run it line by line.

