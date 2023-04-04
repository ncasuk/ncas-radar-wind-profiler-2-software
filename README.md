ncas-radar-wind-profiler-2-software
===================================

This repo contains code and scripts to make AMOF v2 netCDF files for the ncas-radar-wind-profiler-1 instrument from trw files.

Requirements
------------

* python 3.7 or above
* python modules:
  * netCDF4
  * numpy
  * [ncas_amof_netcdf_template](https://ncas-amof-netcdf-template.readthedocs.io/en/stable/index.html)

Installation
------------

To install, either clone the repo `git clone https://github.com/ncasuk/ncas-radar-wind-profiler-2-software.git` or download and extract a release version.

Download the required modules using `conda install --file requirements.txt` or `pip install -r requirements.txt`.


Usage
-----

```
python process_wp.py /path/to/raw1.trw /path/to/raw2.trw ... -m metadata.csv
```
Additional flags that can be given for each python script:
* `-o` or `--ncfile-location` - where to write the netCDF files to. If not given, default is `'.'`
* `-v` or `--verbose` - print additional information as the script runs
* `-t` or `--options` - define options for netCDF file name as allowed by the standard, e.g. `high-mode_15min`

A description of all the available options can be obtained using the `-h` flag, for example
```
python process_wp.py -h
```

### BASH scripts

Three [scripts] are provided for easy use:
* `make_netcdf.sh` - makes netCDF file for a given date: `./make_netcdf.sh YYYYmmdd`
* `make_today_netcdf.sh` - makes netCDF file for today's data: `./make_today_netcdf.sh`
* `make_yesterday_netcdf.sh` - makes netCDF file for yesterday's data: `./make_yesterday_netcdf.sh`

Within `make_netcdf.sh`, the following may need adjusting:
* `netcdf_path="/gws/..."`: replace file path with where to write netCDF files
* `filepath_trt0="/gws/..."`: replace file path with path to data. The same applies to `filepath_trt1="/gws/..."`
* `logfilepath"/home/..."`: replace file path with path for where to write log files


[scripts]: scripts

## Further Information

* `read_wp.py` contains the code that actually reads the raw data. This is called from within `process_wp.py`.
* Some quality control is performed on the data. This is based on code from Emily Norton, the instrument scientist, and is included within `read_wp.py`.
* See [ncas_amof_netcdf_template] or its [documentation] for more information on how the netCDF file is created, and the additional useful functions it contains.

[documentation]: https://ncas-amof-netcdf-template.readthedocs.io/en/stable/index.html
[ncas_amof_netcdf_template]: https://github.com/joshua-hampton/ncas_amof_netcdf_template
