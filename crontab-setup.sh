# Author: Matteo Bottacini, matteo.bottacini@usi.ch
# Last update: March 8, 2021

########################################### INSTRUCTION #############################################
# open the crontab from your terminal by typing "crontab -e" and then copy and paste this commands. 
# REMEBER TO CHANGE THE PATHS.
#####################################################################################################

# download option data every 5 minutes and store log files
*/5 * * * * python3 "src/option-data-download.py" >> logs/option-data-5min-download-log.log

# at the end of each day create a .csv file with daily values
58 23 * * * sqlite3 -header -csv /home/bottama/deliverables/option-data-5min.db "select * from btc_option_data;" > csv_files/btc_option_data.csv
58 23 * * * sqlite3 -header -csv /home/bottama/deliverables/option-data-5min.db "select * from eth_option_data;" > csv_files/eth_option_data.csv

# initialize the data base at 23:59
59 23 * * * rm /home/bottama/deliverables/option-data-5min.db

# zip the csv file at 00.05
5 0 * * * zip -9 -r btc_option_data.zip ./csv_files/btc_option_data.csv
5 0 * * * zip -9 -r eth_option_data.zip ./csv_files/eth_option_data.csv

# move the zipped files to the zip_files folder and rename it with timestamp (YYYYMMDD) at 00.15
15 00 * * * sh /home/bottama/src/move_files.sh

# remove the excel files at 00.30
30 0 * * * rm /home/bottama/csv_files/btc_option_data.csv
30 0 * * * rm /home/bottama/csv_files/eth_option_data.csv
