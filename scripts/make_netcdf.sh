#!/bin/bash

#
# ./make_netcdf.sh YYYYmmdd
#


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

gws_path=/gws/pw/j07/ncas_obs_vol2

netcdf_path=${gws_path}/cao/processing/ncas-radar-wind-profiler-2/netcdf_files
filepath_trt0=/gws/pw/j07/ncas_obs_vol2/cao/raw_data/ncas-radar-wind-profiler-2/data/long-term/trt0
filepath_trt1=/gws/pw/j07/ncas_obs_vol2/cao/raw_data/ncas-radar-wind-profiler-2/data/long-term/trt1
logfilepath=${gws_path}/cao/logs/ncas-radar-wind-profiler-2
metadata_file=${SCRIPT_DIR}/../metadata.csv


datadate=$1  # YYYYmmdd

year=${datadate:0:4}
month=${datadate:4:2}
day=${datadate:6:2}


# month needs to be alpha-numeric-ised (I'm going with it)

case $month in
  10)
    anmonth=a
  ;;
  11)
    anmonth=b
  ;;
  12)
    anmonth=c
  ;;
  *)
    anmonth=${month:1:1}
  ;;
esac


trt0_files=$(ls ${filepath_trt0}/${year}${anmonth}${day}.TRT/*.trw)
no_trt0_files=$(ls ${filepath_trt0}/${year}${anmonth}${day}.TRT/*.trw | wc -l)
trt1_files=$(ls ${filepath_trt1}/${year}${anmonth}${day}.TRT/*.trw)
no_trt1_files=$(ls ${filepath_trt1}/${year}${anmonth}${day}.TRT/*.trw | wc -l)

python ${SCRIPT_DIR}/../process_wp.py ${trt0_files} -o ${netcdf_path} -t high-mode_15min -m ${metadata_file}
python ${SCRIPT_DIR}/../process_wp.py ${trt1_files} -o ${netcdf_path} -t low-mode_15min -m ${metadata_file}


if [ -f ${netcdf_path}/ncas-radar-wind-profiler-2_cao_${year}${month}${day}_snr-winds_low-mode_*.nc ]
then 
  low_file_exists=True
else
  low_file_exists=False
fi

if [ -f ${netcdf_path}/ncas-radar-wind-profiler-1_cdao_${year}${month}${day}_snr-winds_high-mode_*.nc ]
then 
  high_file_exists=True
else
  high_file_exists=False
fi



cat << EOF | sed -e 's/#.*//; s/  *$//' > ${logfilepath}/${year}${month}${day}.txt
Date: $(date -u)
Number of trt0 files: ${no_trt0_files}
Number of trt1 files: ${no_trt1_files}
low-mode file created: ${low_file_exists}
high-mode file created: ${high_file_exists}
EOF
